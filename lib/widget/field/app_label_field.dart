import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_size.dart';
import '../../core/utils/device_utility.dart';
import '../text/app_text.dart';

class AppLabeledField extends StatefulWidget {
  final String title;
  final TextEditingController? controller;
  final String? hintText;
  final String? initialValue; // EKLE
  final IconData? leadingIcon;
  final Widget? trailing;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final bool toUpperCase;
  final int? maxLength;

  const AppLabeledField({
    super.key,
    required this.title,
    this.controller,
    this.hintText,
    this.initialValue, // EKLE
    this.maxLength, // EKLE
    this.leadingIcon,
    this.trailing,
    this.readOnly = false,
    this.onTap,
    this.keyboardType,
    this.onChanged,
    this.toUpperCase = false,
  });

  @override
  State<AppLabeledField> createState() => _AppLabeledFieldState();
}

class _AppLabeledFieldState extends State<AppLabeledField> {
  late final TextEditingController _controller;
  bool _isInternalController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _isInternalController = true;
      _controller = TextEditingController(text: widget.initialValue ?? '');
    }
  }

  @override
  void dispose() {
    if (_isInternalController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: widget.title,
          type: AppTextType.labelMedium,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: AppSizes.spaceSM),
        TextField(
          maxLength: widget.maxLength,
          controller: _controller,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          keyboardType: widget.keyboardType,
          onChanged: (v) {
            final value = widget.toUpperCase ? v.toUpperCase() : v;
            if (widget.toUpperCase) {
              _controller.value = TextEditingValue(
                text: value,
                selection: _controller.selection,
              );
            }
            if (widget.onChanged != null) widget.onChanged!(value);
          },
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: AppSizes.fontMD,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
            prefixIcon: widget.leadingIcon != null
                ? Icon(
                    widget.leadingIcon,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                    size: 20,
                  )
                : null,
            suffixIcon: widget.trailing,
            filled: true,
            fillColor: isDark ? AppColors.surfaceDark : AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceMD,
              vertical: AppSizes.spaceMD,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMD),
              borderSide: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.border,
              ),
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
