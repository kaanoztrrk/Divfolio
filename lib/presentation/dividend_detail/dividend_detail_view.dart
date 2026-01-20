import 'package:divfolio/widget/text/app_text.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/custom/text_theme.dart';
import '../dashboard/widget/portfolio_stats_row.dart';
import 'widget/stat_detail_row.dart';

class DividendDetailView extends StatelessWidget {
  const DividendDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMD),
                  ),
                  alignment: Alignment.center,
                  child: AppText(
                    text: "AAPL",
                    type: AppTextType.labelSmall,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(width: AppSizes.spaceMD),
                AppText(text: "Apple Inc.", type: AppTextType.titleLarge),
              ],
            ),
            SizedBox(height: AppSizes.space3XL),
            AppText(
              text: "Summary",
              type: AppTextType.bodyLarge,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary.withValues(alpha: 0.75),
            ),
            SizedBox(height: AppSizes.spaceXL),
            PortfolioStatsRow(
              color: AppColors.background,
              firstTitle: 'Shares',
              firstValue: '50.00',
              secondTitle: 'Value',
              secondValue: '\$6,500.00',
              thirdTitle: 'DIV. Yield',
              thirdValue: '3.1%',
            ),
            SizedBox(height: AppSizes.space3XL),
            AppText(
              text: "Details",
              type: AppTextType.bodyLarge,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary.withValues(alpha: 0.75),
            ),
            SizedBox(height: AppSizes.spaceXL),
            StatDetailList(
              items: const [
                StatDetailItem(title: "Average Cost", value: "\$45.67"),
                StatDetailItem(
                  title: "Total Growth",
                  value: "\$45.67",
                  signedValue: -45.67,
                ),
                StatDetailItem(title: "Quarterly", value: "\$12.50"),
                StatDetailItem(title: "Yield on Cost", value: "5.2%"),
              ],
            ),
            SizedBox(height: AppSizes.space3XL),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: AppSizes.space3XL,
                horizontal: AppSizes.spaceXXL,
              ),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(AppSizes.radiusLG),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: "LIFETIME EARNINGS",
                    type: AppTextType.labelMedium,
                    color: AppColors.surface.withValues(alpha: 0.75),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "\$1,234.56",
                          style: AppTextTheme.textTheme.headlineLarge!.copyWith(
                            color: AppColors.surface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: "  Total Dividends",
                          style: AppTextTheme.textTheme.labelMedium!.copyWith(
                            color: AppColors.surface.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSizes.spaceXXL),
            GestureDetector(
              onTap: () {
                // Navigate to dividend history page
                Navigator.pushNamed(context, AppRoutes.dividendHistoryDetail);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSizes.spaceMD,
                  horizontal: AppSizes.spaceLG,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.overlay.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(AppSizes.radiusLG),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSizes.spaceSM),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusCircle,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.textPrimary.withValues(
                              alpha: 0.05,
                            ),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.history,
                        size: AppSizes.iconLG,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: AppSizes.spaceMD),
                    Expanded(
                      child: AppText(
                        text: "View Dividend History",
                        type: AppTextType.titleMedium,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: AppSizes.iconSM,
                      color: AppColors.textPrimary,
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
