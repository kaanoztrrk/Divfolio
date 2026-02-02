import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../core/theme/custom/text_theme.dart';
import '../../core/utils/device_utility.dart';
import '../text/app_text.dart';

class MiniInputField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;

  const MiniInputField({
    required this.title,
    required this.controller,
    required this.hintText,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);

    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceMD),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMD),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: title,
            type: AppTextType.labelSmall,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
          ),
          const SizedBox(height: AppSizes.spaceSM),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: AppTextTheme.textTheme.headlineSmall!.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTextTheme.textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.textSecondaryDark.withValues(alpha: 0.4)
                    : AppColors.textSecondary.withValues(alpha: 0.6),
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
