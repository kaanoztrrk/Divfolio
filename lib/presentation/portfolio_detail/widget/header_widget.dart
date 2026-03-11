import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_size.dart';
import '../../../data/model/portfolio_model.dart';
import '../../../widget/chip/app_chip.dart';
import '../../../widget/text/app_text.dart';

class HeaderCard extends StatelessWidget {
  const HeaderCard({
    required this.portfolio,
    required this.isDark,
    required this.totalCost,
    required this.currencySymbol,
    required this.yieldOnCost,
  });

  final PortfolioModel portfolio;
  final bool isDark;
  final double totalCost; // totalIncome → totalCost oldu
  final String currencySymbol;
  final double yieldOnCost;

  @override
  Widget build(BuildContext context) {
    final yieldLabel =
        '${yieldOnCost > 0 ? '+' : ''}${yieldOnCost.toStringAsFixed(2)}%';

    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceXL),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMD),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.border,
        ),
      ),
      child: Column(
        children: [
          AppChip(
            label: portfolio.baseCurrencyCode.toUpperCase(),
            color: isDark ? AppColors.background : AppColors.overlay,
          ),
          const SizedBox(height: AppSizes.spaceMD),
          AppText(
            text: "TOTAL COST",
            type: AppTextType.labelMedium,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSizes.spaceXS),
          AppText(
            text: '$currencySymbol${totalCost.toStringAsFixed(2)}',
            type: AppTextType.headlineLarge,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spaceSM),
          AppChip(label: yieldLabel, signedValue: yieldOnCost),
        ],
      ),
    );
  }
}
