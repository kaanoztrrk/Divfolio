import 'package:flutter/material.dart';

import '../../../../core/constants/app_size.dart';
import '../../../../widget/field/mini_input_field.dart';
import '../../../../widget/text/app_text.dart';
import '../../../../core/constants/app_colors.dart';

class NetAmountSection extends StatelessWidget {
  final TextEditingController controller;
  final String currencySymbol;
  final bool isDark;

  const NetAmountSection({
    super.key,
    required this.controller,
    required this.currencySymbol,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MiniInputField(
            title: 'NET AMOUNT ($currencySymbol)',
            controller: controller,
            hintText: '0.00',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: AppSizes.spaceSM),
          AppText(
            text: 'Actual amount received after tax withholdings.',
            type: AppTextType.labelSmall,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
