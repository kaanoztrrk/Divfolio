import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_size.dart';
import '../../../../../core/utils/device_utility.dart';
import '../../../../../widget/text/app_text.dart';

class StatDetailRow extends StatelessWidget {
  final String title;
  final String value;

  final double? signedValue;

  const StatDetailRow({
    super.key,
    required this.title,
    required this.value,
    this.signedValue,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);
    final isPositive = signedValue != null && signedValue! > 0;
    final isNegative = signedValue != null && signedValue! < 0;

    final color = isPositive
        ? AppColors.success
        : isNegative
        ? AppColors.error
        : AppColors.textPrimary;

    final icon = isPositive
        ? Icons.arrow_upward
        : isNegative
        ? Icons.arrow_downward
        : null;

    return Row(
      children: [
        Expanded(
          child: AppText(
            text: title,
            type: AppTextType.titleSmall,
            color: isDark
                ? AppColors.textPrimaryDark.withValues(alpha: 0.75)
                : AppColors.textPrimary.withValues(alpha: 0.75),
          ),
        ),
        if (icon != null) ...[
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
        ],
        AppText(
          text: value,
          type: AppTextType.titleSmall,
          fontWeight: FontWeight.w600,
          color: icon != null ? color : null,
        ),
      ],
    );
  }
}

class StatDetailList extends StatelessWidget {
  final List<StatDetailItem> items;

  const StatDetailList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);

    return Column(
      children: List.generate(items.length, (i) {
        final item = items[i];
        return Column(
          children: [
            StatDetailRow(
              title: item.title,
              value: item.value,
              signedValue: item.signedValue,
            ),
            if (i != items.length - 1) ...[
              SizedBox(height: AppSizes.spaceMD),
              Divider(
                color: isDark ? AppColors.dividerDark : AppColors.divider,
              ),
              SizedBox(height: AppSizes.spaceMD),
            ],
          ],
        );
      }),
    );
  }
}

class StatDetailItem {
  final String title;
  final String value;
  final double? signedValue;

  const StatDetailItem({
    required this.title,
    required this.value,
    this.signedValue,
  });
}
