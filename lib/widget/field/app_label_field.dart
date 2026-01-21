import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../text/app_text.dart';

class AppLabeledField extends StatelessWidget {
  final String title;

  final TextEditingController? controller;
  final String? hintText;

  final IconData? leadingIcon;
  final Widget? trailing;

  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const AppLabeledField({
    super.key,
    required this.title,
    this.controller,
    this.hintText,
    this.leadingIcon,
    this.trailing,
    this.readOnly = false,
    this.onTap,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: title,
          type: AppTextType.labelLarge,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w700,
        ),
        const SizedBox(height: AppSizes.spaceSM),
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: leadingIcon != null
                ? Icon(
                    leadingIcon,
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                    size: 20,
                  )
                : null,
            suffixIcon: trailing,
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceMD,
              vertical: AppSizes.spaceMD,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMD),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMD),
              borderSide: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.6),
                width: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
