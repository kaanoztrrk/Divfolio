import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/theme/custom/text_theme.dart';
import '../../../../widget/field/mini_input_field.dart';
import '../../../../widget/text/app_text.dart';

class CalculateSection extends StatelessWidget {
  final TextEditingController sharesCtrl;
  final TextEditingController divPerShareCtrl;
  final double calculatedNet;
  final String currencySymbol;
  final bool isDark;
  final ValueChanged<String> onSharesChanged;
  final ValueChanged<String> onDivPerShareChanged;

  const CalculateSection({
    super.key,
    required this.sharesCtrl,
    required this.divPerShareCtrl,
    required this.calculatedNet,
    required this.currencySymbol,
    required this.isDark,
    required this.onSharesChanged,
    required this.onDivPerShareChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shares + Div/Share yan yana — Add Holding stili
          Row(
            children: [
              Expanded(
                child: MiniInputField(
                  title: 'SHARES',
                  controller: sharesCtrl,
                  hintText: '10.00',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: onSharesChanged,
                ),
              ),
              const SizedBox(width: AppSizes.spaceMD),
              Expanded(
                child: MiniInputField(
                  title: 'DIV / SHARE ($currencySymbol)',
                  controller: divPerShareCtrl,
                  hintText: '0.25',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: onDivPerShareChanged,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.spaceMD),

          // Estimated Net sonuç kartı
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceMD,
              vertical: AppSizes.spaceMD,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppSizes.radiusMD),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: 'Estimated Net',
                  type: AppTextType.labelMedium,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
                Text(
                  '$currencySymbol${calculatedNet.toStringAsFixed(2)}',
                  style: AppTextTheme.textTheme.titleMedium!.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
