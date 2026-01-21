import 'package:divfolio/widget/field/app_label_field.dart';
import 'package:divfolio/widget/field/select_field.dart';
import 'package:divfolio/widget/text/app_text.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../widget/button/primary_button.dart';
import '../../widget/field/mini_input_field.dart';
import '../../widget/field/pay_date_field.dart';

class AddHoldingView extends StatelessWidget {
  const AddHoldingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppText(text: "Add Holdings", type: AppTextType.titleMedium),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.spaceMD,
            AppSizes.spaceSM,
            AppSizes.spaceMD,
            AppSizes.spaceMD,
          ),
          child: PrimaryButton(label: "Add to Portfolio", onPressed: () {}),
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
              AppLabeledField(
                title: "Company ID",
                hintText: "Add a company ID...",
                leadingIcon: Icons.search,
                onChanged: (v) {},
              ),
              SizedBox(height: AppSizes.spaceMD),
              AppLabeledField(
                title: "Company",
                hintText: "Add a company...",
                leadingIcon: Icons.search,
                onChanged: (v) {},
              ),
              SizedBox(height: AppSizes.spaceXL),
              Row(
                children: [
                  Expanded(
                    child: MiniInputField(
                      title: "SHARES",
                      controller: TextEditingController(),
                      hintText: "10.00",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: AppSizes.spaceMD),
                  Expanded(
                    child: MiniInputField(
                      title: "AVG. COST (\$)",
                      controller: TextEditingController(),
                      hintText: "150.00",
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.spaceXL),
              Container(
                padding: EdgeInsets.all(AppSizes.spaceXXL),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMD),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calculate,
                          color: AppColors.textPrimary.withValues(alpha: 0.6),
                          size: 20,
                        ),
                        const SizedBox(width: AppSizes.spaceSM),
                        AppText(
                          text: "Total Cost",
                          type: AppTextType.bodyMedium,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary.withValues(alpha: 0.8),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        AppText(
                          text: "10.00 x 150.00",
                          type: AppTextType.labelLarge,
                          color: AppColors.textSecondary,
                        ),
                        AppText(
                          text: "\$1,500.00",
                          type: AppTextType.titleLarge,
                          color: AppColors.secondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.spaceXL),
              SelectField(
                title: "Portfolio",
                value: "Main Portfolio",
                onTap: () {},
              ),
              SizedBox(height: AppSizes.spaceXL),

              PayDateField(
                initialDate: DateTime(2023, 10, 24),
                onChanged: (d) {},
              ),
              SizedBox(height: AppSizes.spaceXL),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.spaceXL),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMD),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: "EST. ANNUAL INCOME",
                          type: AppTextType.labelSmall,
                          color: AppColors.primary,
                        ),
                        SizedBox(height: AppSizes.spaceSM),
                        AppText(
                          text: "\$45.00",
                          type: AppTextType.headlineSmall,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AppText(
                          text: "YIELD ON CONST",
                          type: AppTextType.labelSmall,
                          color: AppColors.primary,
                        ),
                        SizedBox(height: AppSizes.spaceSM),
                        AppText(text: "3.00%", type: AppTextType.headlineSmall),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
