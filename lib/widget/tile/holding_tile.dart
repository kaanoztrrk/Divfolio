import 'package:divfolio/core/utils/device_utility.dart';
import 'package:divfolio/core/utils/money_extension.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_size.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/custom/text_theme.dart';
import '../../data/model/holding_model.dart';
import '../text/app_text.dart';

class HoldingTile extends StatelessWidget {
  const HoldingTile({super.key, required this.holding, this.thisYearIncome});

  final HoldingModel holding;
  final double? thisYearIncome; // DividendBloc'tan gelen bu yılki gelir

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);
    final currencySymbol = holding.currencyCode != null
        ? MoneyX.symbolOf(holding.currencyCode!)
        : '';
    final totalCost = (holding.avgCost ?? 0) * holding.shares;
    final income = thisYearIncome ?? 0.0;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.holdingDetail,
          arguments: {'holding': holding},
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
              text: holding.companyId.length > 4
                  ? holding.companyId.substring(0, 4)
                  : holding.companyId,
              type: AppTextType.labelSmall,
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          title: AppText(
            text: holding.companyName,
            type: AppTextType.titleMedium,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          subtitle: AppText(
            text:
                '${holding.shares.toStringAsFixed(0)} Shares · $currencySymbol${totalCost.toStringAsFixed(2)}',
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
                  text: '$currencySymbol${income.toStringAsFixed(2)}\n',
                  style: AppTextTheme.textTheme.titleMedium!.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: 'This year',
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
    );
  }
}
