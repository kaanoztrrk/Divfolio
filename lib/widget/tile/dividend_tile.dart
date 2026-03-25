import 'package:divfolio/core/utils/device_utility.dart';
import 'package:divfolio/core/utils/money_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../bloc/dividend_bloc/dividend_bloc.dart';
import '../../bloc/dividend_bloc/dividend_event.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_size.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/custom/text_theme.dart';
import '../../data/model/dividend_model.dart';
import '../../data/model/holding_model.dart';
import '../button/slidable_button.dart';
import '../text/app_text.dart';

class DividendTile extends StatelessWidget {
  const DividendTile({super.key, required this.dividend, this.holding});

  final DividendModel dividend;
  final HoldingModel? holding;

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);
    final companyId = holding?.companyId ?? '???';
    final companyName = holding?.companyName ?? 'Unknown';
    final symbol = holding?.currencyCode != null
        ? MoneyX.symbolOf(holding!.currencyCode!)
        : '';
    final isCalculateMode = dividend.dividendPerShare > 0;

    return Slidable(
      key: ValueKey(dividend.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.55,
        children: [
          DeleteSlidableAction(
            confirmTitle: 'Delete Dividend',
            confirmMessage: 'This dividend record will be permanently deleted.',
            onConfirm: () {
              context.read<DividendBloc>().add(DeleteDividend(dividend.id));
            },
          ),
          EditSlidableAction(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.editDividend,
                arguments: {
                  'dividend': dividend,
                  'holding': holding,
                }, // ← holding ekle
              );
            },
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.dividendDetail,
            arguments: {'dividend': dividend, 'holding': holding},
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: AppSizes.spaceSM),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusLG),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.border,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceMD,
              vertical: AppSizes.spaceSM,
            ),
            leading: Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusMD),
              ),
              alignment: Alignment.center,
              child: AppText(
                text: companyId.length > 4
                    ? companyId.substring(0, 4)
                    : companyId,
                type: AppTextType.labelSmall,
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
            title: AppText(
              text: companyName,
              type: AppTextType.titleSmall,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            subtitle: AppText(
              text: isCalculateMode
                  ? '${dividend.sharesAtPayDate.toStringAsFixed(0)} Shares · ${_formatDate(dividend.payDate)}'
                  : 'Net Amount · ${_formatDate(dividend.payDate)}',
              type: AppTextType.labelMedium,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
            trailing: RichText(
              textAlign: TextAlign.end,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$symbol${dividend.netAmount.toStringAsFixed(2)}\n',
                    style: AppTextTheme.textTheme.titleMedium!.copyWith(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: 'Received',
                    style: AppTextTheme.textTheme.labelSmall!.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}
