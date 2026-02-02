import 'package:divfolio/core/routes/app_routes.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../core/utils/device_utility.dart';
import '../../data/model/portfolio_model.dart';
import '../chip/app_chip.dart';
import '../text/app_text.dart';

class PortfolioTile extends StatelessWidget {
  const PortfolioTile({super.key, required this.portfolio});

  final PortfolioModel portfolio;

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.portfolioDetails,
          arguments: portfolio.id,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceXL,
          vertical: AppSizes.spaceMD,
        ),
        margin: const EdgeInsets.symmetric(vertical: AppSizes.spaceSM),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusLG),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.border,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: AppText(
                text: portfolio.name,
                type: AppTextType.titleLarge,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: AppSizes.spaceXS),
                child: Row(
                  children: [
                    AppChip(label: portfolio.baseCurrencyCode),
                    SizedBox(width: AppSizes.spaceXS),
                    AppText(
                      text: "● 0 Assets",
                      type: AppTextType.labelMedium,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: isDark ? AppColors.iconDark : AppColors.icon,
              ),
            ),
            const SizedBox(height: AppSizes.spaceMD),
            const AppText(
              text: "PORTFOLIO DIVIDENDS",
              type: AppTextType.labelLarge,
            ),
            const SizedBox(height: AppSizes.spaceXS),
            const AppText(
              text: "—",
              type: AppTextType.headlineLarge,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
