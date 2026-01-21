import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../core/theme/custom/text_theme.dart';
import '../text/app_text.dart';

class NotesField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String hintText;

  const NotesField({
    required this.title,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.spaceMD),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMD),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: title,
            type: AppTextType.labelSmall,
            color: AppColors.textSecondary,
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
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTextTheme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary.withValues(alpha: 0.6),
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
