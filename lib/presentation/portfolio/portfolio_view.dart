import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../core/theme/custom/text_theme.dart';
import '../../widget/chip/app_chip.dart';
import '../../widget/text/app_text.dart';

class PortfoliosView extends StatelessWidget {
  const PortfoliosView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMD),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSizes.spaceXL),
                AppText(
                  text: "TOTAL NET DIVIDENDS",
                  type: AppTextType.labelMedium,
                  color: AppColors.primary,
                ),
                SizedBox(height: AppSizes.spaceSM),
                AppText(
                  text: "\$12,345.67",
                  type: AppTextType.displayMedium,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: AppSizes.space3XL),
                Divider(color: AppColors.divider),
                SizedBox(height: AppSizes.spaceXL),
              ],
            ),
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceMD,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          text: "Active Portfolios",
                          type: AppTextType.titleMedium,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        AppText(
                          text: "Edit List",
                          type: AppTextType.titleMedium,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.spaceXL,
                            vertical: AppSizes.spaceMD,
                          ),
                          margin: const EdgeInsets.symmetric(
                            vertical: AppSizes.spaceSM,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusLG,
                            ),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: AppText(
                                  text: "Tech Stocks",
                                  type: AppTextType.titleLarge,
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                                subtitle: Row(
                                  children: [
                                    AppChip(label: "USD"),
                                    AppText(
                                      text: " ● 12 Assets",
                                      type: AppTextType.labelMedium,
                                      color: AppColors.textSecondary,
                                    ),
                                  ],
                                ),
                                trailing: Icon(
                                  Icons.chevron_right,
                                  color: AppColors.icon,
                                ),
                              ),
                              SizedBox(height: AppSizes.spaceMD),
                              AppText(
                                text: "PORTFOLIO DIVIDENDS",
                                type: AppTextType.labelLarge,
                              ),
                              SizedBox(height: AppSizes.spaceXS),

                              AppText(
                                text: "\$12.450",
                                type: AppTextType.headlineLarge,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
