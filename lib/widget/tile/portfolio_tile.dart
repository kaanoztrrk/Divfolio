import 'package:divfolio/core/routes/app_routes.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../chip/app_chip.dart';
import '../text/app_text.dart';

class PortfolioTile extends StatelessWidget {
  const PortfolioTile({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.portfolioDetails);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceXL,
          vertical: AppSizes.spaceMD,
        ),
        margin: const EdgeInsets.symmetric(vertical: AppSizes.spaceSM),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusLG),
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
              trailing: Icon(Icons.chevron_right, color: AppColors.icon),
            ),
            SizedBox(height: AppSizes.spaceMD),
            AppText(text: "PORTFOLIO DIVIDENDS", type: AppTextType.labelLarge),
            SizedBox(height: AppSizes.spaceXS),

            AppText(
              text: "\$12.450",
              type: AppTextType.headlineLarge,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
