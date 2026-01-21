import 'package:divfolio/constants/app_colors.dart';
import 'package:divfolio/widget/button/primary_button.dart';
import 'package:flutter/material.dart';

import '../../constants/app_size.dart';
import '../../core/theme/custom/text_theme.dart';
import '../../widget/field/pay_date_field.dart';
import '../../widget/field/select_field.dart';
import '../../widget/text/app_text.dart';
import 'widget/advanced_options_sections.dart';

class AddDividendView extends StatelessWidget {
  const AddDividendView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: AppText(text: 'Add Dividend', type: AppTextType.titleMedium),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const AppText(text: "Reset", type: AppTextType.bodyLarge),
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.spaceMD,
            AppSizes.spaceSM,
            AppSizes.spaceMD,
            AppSizes.spaceMD,
          ),
          child: PrimaryButton(label: "Save Dividend", onPressed: () {}),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(
            vertical: AppSizes.spaceLG,
            horizontal: AppSizes.spaceMD,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---- MAIN CARD ----
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMD),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppSizes.spaceMD),
                      child: SelectField(
                        title: "Company",
                        value: "Apple Inc. (AAPL)",
                        onTap: () {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSizes.spaceMD),
                      child: PayDateField(
                        initialDate: DateTime(2023, 10, 24),
                        onChanged: (d) {},
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.spaceMD,
                        horizontal: AppSizes.spaceMD,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(AppSizes.radiusMD),
                          bottomRight: Radius.circular(AppSizes.radiusMD),
                        ),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: "NET AMOUNT RECEIVED",
                            type: AppTextType.bodyMedium,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary.withValues(alpha: 0.8),
                          ),
                          const SizedBox(height: AppSizes.spaceSM),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AppText(
                                text: "\$",
                                type: AppTextType.headlineLarge,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: AppSizes.spaceXS),
                              Expanded(
                                child: TextField(
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  style: AppTextTheme.textTheme.headlineLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                  decoration: InputDecoration(
                                    hintText: "0.00",
                                    hintStyle: TextStyle(
                                      color: AppColors.textSecondary.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSizes.spaceSM),
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 16,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: AppSizes.spaceXS),
                              Expanded(
                                child: AppText(
                                  text:
                                      "This is the actual amount received in your account after any tax withholdings.",
                                  type: AppTextType.labelSmall,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.spaceXL),
              AppText(
                text: "ADVANCED OPTIONS",
                type: AppTextType.bodyMedium,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary.withValues(alpha: 0.75),
              ),
              const SizedBox(height: AppSizes.spaceXL),

              AdvancedOptionsSection(
                sharesController: TextEditingController(),
                divPerShareController: TextEditingController(),
                notesController: TextEditingController(),
                portfolioLabel: "Long Term Holdings",
                onTapPortfolio: () {},
              ),

              // ✅ sticky button ile çakışmasın diye ekstra boşluk
              const SizedBox(height: AppSizes.spaceXXL),
            ],
          ),
        ),
      ),
    );
  }
}
