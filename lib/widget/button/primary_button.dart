import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../core/utils/device_utility.dart';
import '../text/app_text.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  final IconData? leadingIcon;
  final IconData? trailingIcon;

  final bool isDisabled;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);

    final backgroundColor = isDark
        ? AppColors.primary.withValues(alpha: 0.9)
        : AppColors.primary;

    final disabledColor = isDark
        ? AppColors.primary.withValues(alpha: 0.3)
        : AppColors.primary.withValues(alpha: 0.4);

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          disabledBackgroundColor: disabledColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMD),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leadingIcon != null) ...[
              Icon(leadingIcon, size: 18, color: Colors.white),
              const SizedBox(width: 8),
            ],
            AppText(
              text: label,
              type: AppTextType.titleMedium,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 8),
              Icon(trailingIcon, size: 18, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }
}
