import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_size.dart';
import '../text/app_text.dart';

class AppChip extends StatelessWidget {
  final String label;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final AppTextType? type;

  final double? signedValue;

  final Color? color;

  const AppChip({
    super.key,
    required this.label,
    this.leadingIcon,
    this.trailingIcon,
    this.type,
    this.signedValue,
    this.color,
  });

  Color _resolveColor() {
    if (color != null) return color!;

    if (signedValue != null) {
      if (signedValue! > 0) return AppColors.success;
      if (signedValue! < 0) return AppColors.error;
    }

    // 3. Label fallback
    if (label.startsWith('+')) return AppColors.success;
    if (label.startsWith('-')) return AppColors.error;

    return AppColors.primary;
  }

  IconData? _resolveTrailingIcon() {
    if (trailingIcon != null) return trailingIcon; // override varsa kullan
    if (signedValue == null) return null;
    if (signedValue! > 0) return Icons.trending_up_rounded;
    if (signedValue! < 0) return Icons.trending_down_rounded;
    return Icons.trending_flat_rounded; // sıfır
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = _resolveColor();
    final resolvedTrailingIcon = _resolveTrailingIcon();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceMD,
        vertical: AppSizes.spaceXS,
      ),
      decoration: BoxDecoration(
        color: baseColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusSM),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingIcon != null) ...[
            Icon(
              leadingIcon,
              size: 14,
              color: baseColor.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 4),
          ],
          AppText(
            text: label,
            type: type ?? AppTextType.titleSmall,
            color: baseColor.withValues(alpha: 0.7),
            fontWeight: FontWeight.w600,
          ),
          if (resolvedTrailingIcon != null) ...[
            const SizedBox(width: 4),
            Icon(
              resolvedTrailingIcon,
              size: 14,
              color: baseColor.withValues(alpha: 0.7),
            ),
          ],
        ],
      ),
    );
  }
}
