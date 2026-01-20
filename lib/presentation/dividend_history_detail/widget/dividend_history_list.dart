import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_size.dart';
import '../../../widget/text/app_text.dart';

class DividendHistoryItemTile extends StatelessWidget {
  final String date;
  final String periodLabel;
  final String title;
  final String amount;
  final String sharesText;
  final String perShareText;
  final bool isActive;

  const DividendHistoryItemTile({
    super.key,
    required this.date,
    required this.periodLabel,
    required this.title,
    required this.amount,
    required this.sharesText,
    required this.perShareText,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // timeline dot
        Column(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.border,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
        const SizedBox(width: 12),

        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppSizes.spaceMD),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusLG),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppText(
                        text: date,
                        type: AppTextType.labelMedium,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: AppText(
                        text: periodLabel,
                        type: AppTextType.labelSmall,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: AppText(
                        text: title,
                        type: AppTextType.titleMedium,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    AppText(
                      text: amount,
                      type: AppTextType.titleMedium,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _MetaRow(icon: Icons.layers_outlined, text: sharesText),
                    const SizedBox(width: 16),
                    _MetaRow(icon: Icons.attach_money, text: perShareText),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        AppText(
          text: text,
          type: AppTextType.labelMedium,
          color: AppColors.textSecondary,
        ),
      ],
    );
  }
}
