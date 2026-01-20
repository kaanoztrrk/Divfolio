import 'package:divfolio/constants/app_colors.dart';
import 'package:divfolio/constants/app_size.dart';
import 'package:divfolio/widget/text/app_text.dart';
import 'package:flutter/material.dart';

import '../../core/theme/custom/text_theme.dart';
import '../../widget/tile/dividend_tile.dart';
import 'widget/portfolio_stats_row.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMD),
        child: Column(
          children: [
            Expanded(
              flex: 35,
              child: Column(
                children: [
                  AppText(
                    text: "TOTAL NET DIVIDENDS",
                    type: AppTextType.labelMedium,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: AppSizes.spaceMD),
                  AppText(
                    text: "\$12,345.67",
                    type: AppTextType.displayMedium,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: AppSizes.spaceSM),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "+5.67%",
                          style: AppTextTheme.textTheme.labelMedium!.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: " this year",
                          style: AppTextTheme.textTheme.labelMedium!.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSizes.spaceXXL),
                  PortfolioStatsRow(
                    color: AppColors.surface,
                    firstTitle: 'Annual',
                    firstValue: '\$1,200',
                    secondTitle: 'Yield',
                    secondValue: '5.6%',
                    thirdTitle: 'Holdings',
                    thirdValue: '24',
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 65,
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
                          text: "Recent Dividends",
                          type: AppTextType.titleMedium,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        AppText(
                          text: "See All",
                          type: AppTextType.titleSmall,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return DividendTile();
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
