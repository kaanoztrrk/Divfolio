import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../widget/text/app_text.dart';

class DividendSummaryCard extends StatelessWidget {
  final bool isDark;
  final String yearToDate;
  final String monthlyAverage;
  final String yieldOnCost;

  const DividendSummaryCard({
    super.key,
    required this.isDark,
    this.yearToDate = '—',
    this.monthlyAverage = '—',
    this.yieldOnCost = '-%',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceXL),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppSizes.radiusMD),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Iconsax.calendar,
                size: AppSizes.iconMD,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSizes.spaceSM),
              AppText(
                text: "Dividend Summary",
                type: AppTextType.labelMedium,
                color: AppColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceMD),
          _SummaryRow(isDark: isDark, label: "Year-to-Date", value: yearToDate),
          SizedBox(height: AppSizes.spaceSM),
          _SummaryRow(
            isDark: isDark,
            label: "Monthly Average",
            value: monthlyAverage,
          ),
          SizedBox(height: AppSizes.spaceSM),
          _SummaryRow(
            isDark: isDark,
            label: "Yield on Cost",
            value: yieldOnCost,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final bool isDark;
  final String label;
  final String value;

  const _SummaryRow({
    required this.isDark,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppText(
          text: label,
          type: AppTextType.bodySmall,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        ),
        const Spacer(),
        AppText(
          text: value,
          type: AppTextType.bodyMedium,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        ),
      ],
    );
  }
}
