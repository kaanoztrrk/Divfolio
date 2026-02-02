import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_size.dart';
import '../../../core/utils/device_utility.dart';
import '../../../widget/text/app_text.dart';

class HoldingCostSummary extends StatelessWidget {
  final double shares;
  final double avgCost;
  final String currencySymbol;

  const HoldingCostSummary({
    super.key,
    required this.shares,
    required this.avgCost,
    this.currencySymbol = '\$',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);
    final totalCost = shares * avgCost;

    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceXXL),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusMD),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.border,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.calculate,
                size: 20,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: AppSizes.spaceSM),
              AppText(
                text: "Total Cost",
                type: AppTextType.bodyMedium,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.textPrimaryDark.withValues(alpha: 0.8)
                    : AppColors.textPrimary.withValues(alpha: 0.8),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppText(
                text: "${_format(shares)} x ${_format(avgCost)}",
                type: AppTextType.labelLarge,
                color: AppColors.textSecondary,
              ),
              AppText(
                text: "${_format(totalCost)} $currencySymbol",
                type: AppTextType.titleLarge,
                color: isDark ? AppColors.primary : AppColors.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _format(double value) {
    return value.toStringAsFixed(2);
  }
}
