import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../widget/text/app_text.dart';
import '../../widget/tile/portfolio_tile.dart';

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
                        return PortfolioTile();
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
