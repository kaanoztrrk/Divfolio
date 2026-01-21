import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../text/app_text.dart';

class AppChip extends StatelessWidget {
  final String label;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final AppTextType? type;

  /// Otomatik + / - için
  final double? signedValue;

  /// Manuel override rengi
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
    // 1. Manuel renk her zaman öncelikli
    if (color != null) return color!;

    // 2. Numeric kontrol
    if (signedValue != null) {
      if (signedValue! > 0) return AppColors.success;
      if (signedValue! < 0) return AppColors.error;
    }

    // 3. Label fallback
    if (label.startsWith('+')) return AppColors.success;
    if (label.startsWith('-')) return AppColors.error;

    // 4. Default
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = _resolveColor();

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
          if (trailingIcon != null) ...[
            const SizedBox(width: 4),
            Icon(
              trailingIcon,
              size: 14,
              color: baseColor.withValues(alpha: 0.7),
            ),
          ],
        ],
      ),
    );
  }
}
