import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_size.dart';
import '../../../widget/text/app_text.dart';

class StatInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const StatInfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceXL),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSizes.radiusLG),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            text: title,
            type: AppTextType.labelMedium,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 4),
          AppText(
            text: value,
            type: AppTextType.titleMedium,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}

class PortfolioStatsRow extends StatelessWidget {
  final String firstTitle;
  final String firstValue;

  final String secondTitle;
  final String secondValue;

  final String thirdTitle;
  final String thirdValue;
  final Color color;

  const PortfolioStatsRow({
    super.key,
    required this.firstTitle,
    required this.firstValue,
    required this.secondTitle,
    required this.secondValue,
    required this.thirdTitle,
    required this.thirdValue,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatInfoCard(
            color: color,
            title: firstTitle,
            value: firstValue,
          ),
        ),
        const SizedBox(width: AppSizes.spaceSM),
        Expanded(
          child: StatInfoCard(
            color: color,

            title: secondTitle,
            value: secondValue,
          ),
        ),
        const SizedBox(width: AppSizes.spaceSM),
        Expanded(
          child: StatInfoCard(
            color: color,
            title: thirdTitle,
            value: thirdValue,
          ),
        ),
      ],
    );
  }
}
