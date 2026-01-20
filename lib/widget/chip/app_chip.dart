import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../text/app_text.dart';

class AppChip extends StatelessWidget {
  final String label;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  const AppChip({
    super.key,
    required this.label,
    this.leadingIcon,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceMD,
        vertical: AppSizes.spaceXS,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusSM),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingIcon != null) ...[
            Icon(
              leadingIcon,
              size: 14,
              color: AppColors.primary.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 4),
          ],
          AppText(
            text: label,
            type: AppTextType.labelMedium,
            color: AppColors.primary.withValues(alpha: 0.7),
          ),
          if (trailingIcon != null) ...[
            const SizedBox(width: 4),
            Icon(
              trailingIcon,
              size: 14,
              color: AppColors.primary.withValues(alpha: 0.7),
            ),
          ],
        ],
      ),
    );
  }
}
