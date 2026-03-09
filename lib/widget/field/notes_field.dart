import 'package:divfolio/core/utils/device_utility.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_size.dart';
import '../../core/theme/custom/text_theme.dart';
import '../text/app_text.dart';

class NotesField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String hintText;

  const NotesField({
    super.key,
    required this.title,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);
    return Container(
      width: double.infinity,
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
            color: isDark ? AppColors.textPrimaryDark : AppColors.textSecondary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
          const SizedBox(height: AppSizes.spaceSM),
          TextField(
            controller: controller,
            maxLines: 3,
            keyboardType: TextInputType.multiline,
            style: AppTextTheme.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTextTheme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textSecondaryDark.withValues(alpha: 0.6)
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
