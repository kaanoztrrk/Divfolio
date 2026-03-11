import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_size.dart';
import '../../../core/utils/device_utility.dart';
import '../../../widget/text/app_text.dart';

class MiniStat extends StatelessWidget {
  final String value;
  final String label;

  const MiniStat({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText(
          text: value,
          type: AppTextType.headlineSmall,
          fontWeight: FontWeight.w700,
        ),
        const SizedBox(height: AppSizes.spaceXS),
        AppText(
          text: label,
          type: AppTextType.labelSmall,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }
}
