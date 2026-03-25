import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../bloc/portfolio_bloc/portfolio_bloc.dart';
import '../../bloc/portfolio_bloc/portfolio_event.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_size.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/device_utility.dart';
import '../../data/model/portfolio_model.dart';
import '../bottom_sheet/edit_portfolio_sheet.dart';
import '../button/slidable_button.dart';
import '../chip/app_chip.dart';
import '../text/app_text.dart';

class PortfolioTile extends StatelessWidget {
  const PortfolioTile({
    super.key,
    required this.portfolio,
    required this.assetCount,
    required this.totalValue,
  });

  final PortfolioModel portfolio;
  final int assetCount;
  final double totalValue;

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);

    return Slidable(
      key: ValueKey(portfolio.id),
      endActionPane: portfolio.id == 'main_id'
          ? null
          : ActionPane(
              motion: const ScrollMotion(),
              extentRatio: 0.55,
              children: [
                DeleteSlidableAction(
                  confirmTitle: 'Delete Portfolio',
                  confirmMessage:
                      'This portfolio and all its holdings and dividends will be permanently deleted.',
                  onConfirm: () {
                    context.read<PortfolioBloc>().add(
                      DeletePortfolio(portfolio.id),
                    );
                  },
                ),
                EditSlidableAction(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      showDragHandle: true,
                      builder: (_) => BlocProvider.value(
                        value: context.read<PortfolioBloc>(),
                        child: EditPortfolioSheet(portfolio: portfolio),
                      ),
                    );
                  },
                ),
              ],
            ),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.portfolioDetails,
            arguments: portfolio,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceXL,
            vertical: AppSizes.spaceMD,
          ),
          margin: const EdgeInsets.symmetric(vertical: AppSizes.spaceSM),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusLG),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.border,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: AppText(
                  text: portfolio.name,
                  type: AppTextType.titleLarge,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: AppSizes.spaceXS),
                  child: Row(
                    children: [
                      AppChip(label: portfolio.baseCurrencyCode),
                      const SizedBox(width: AppSizes.spaceXS),
                      AppText(
                        text: "● $assetCount Assets",
                        type: AppTextType.labelMedium,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: isDark ? AppColors.iconDark : AppColors.icon,
                ),
              ),
              const SizedBox(height: AppSizes.spaceMD),
              const AppText(
                text: "PORTFOLIO DIVIDENDS",
                type: AppTextType.labelLarge,
              ),
              const SizedBox(height: AppSizes.spaceXS),
              AppText(
                text: totalValue > 0 ? totalValue.toStringAsFixed(2) : "-",
                type: AppTextType.headlineLarge,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
