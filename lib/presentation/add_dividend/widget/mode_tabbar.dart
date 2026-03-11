// ---- MODE TAB ----
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_size.dart';
import '../../../core/utils/device_utility.dart';
import '../../../widget/text/app_text.dart';

class ModeTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const ModeTab({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceSM),
          decoration: BoxDecoration(
            color: selected
                ? (isDark ? AppColors.surfaceDark : AppColors.surface)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSizes.radiusSM),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: AppText(
              text: label,
              type: AppTextType.bodyMedium,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected
                  ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary)
                  : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
