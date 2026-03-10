import 'package:divfolio/core/utils/device_utility.dart';
import 'package:divfolio/core/utils/money_extension.dart';
import 'package:divfolio/data/model/dividend_model.dart';
import 'package:divfolio/data/model/holding_model.dart';
import 'package:divfolio/widget/text/app_text.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/custom/text_theme.dart';
import '../../../dashboard/widget/portfolio_stats_row.dart';
import 'widget/stat_detail_row.dart';

class DividendDetailView extends StatelessWidget {
  const DividendDetailView({super.key, required this.dividend, this.holding});

  final DividendModel dividend;
  final HoldingModel? holding;

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);
    final currencySymbol = dividend.currencyCode.isNotEmpty
        ? MoneyX.symbolOf(dividend.currencyCode)
        : '';

    final companyId = holding?.companyId ?? '???';
    final companyName = holding?.companyName ?? 'Unknown';
    final shares = dividend.sharesAtPayDate;
    final avgCost = holding?.avgCost ?? 0.0;
    final totalValue = shares * avgCost;

    // Yield on Cost
    final totalCost = (holding?.avgCost ?? 0) * (holding?.shares ?? 0);
    final yieldOnCost = totalCost > 0
        ? (dividend.netAmount / totalCost * 100)
        : 0.0;

    // Div per share
    final divPerShare = dividend.dividendPerShare > 0
        ? dividend.dividendPerShare
        : (shares > 0 ? dividend.netAmount / shares : 0.0);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppText(
          text: "Dividend Details",
          type: AppTextType.titleMedium,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSizes.spaceMD),

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
                    text: companyId.length > 4
                        ? companyId.substring(0, 4)
                        : companyId,
                    type: AppTextType.labelSmall,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: AppSizes.spaceMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(text: companyName, type: AppTextType.titleLarge),
                      AppText(
                        text: _formatDate(dividend.payDate),
                        type: AppTextType.labelMedium,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSizes.space3XL),

            AppText(
              text: "Summary",
              type: AppTextType.bodyLarge,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textSecondaryDark.withValues(alpha: 0.75)
                  : AppColors.textSecondary.withValues(alpha: 0.75),
            ),
            const SizedBox(height: AppSizes.spaceXL),
            PortfolioStatsRow(
              color: isDark ? AppColors.surfaceDark : AppColors.surface,
              firstTitle: 'Shares',
              firstValue: shares.toStringAsFixed(0),
              secondTitle: 'Value',
              secondValue: '$currencySymbol${totalValue.toStringAsFixed(2)}',
              thirdTitle: 'Yield',
              thirdValue: '${yieldOnCost.toStringAsFixed(2)}%',
            ),

            const SizedBox(height: AppSizes.space3XL),

            AppText(
              text: "Details",
              type: AppTextType.bodyLarge,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textSecondaryDark.withValues(alpha: 0.75)
                  : AppColors.textSecondary.withValues(alpha: 0.75),
            ),
            const SizedBox(height: AppSizes.spaceXL),
            StatDetailList(
              items: [
                StatDetailItem(
                  title: "Pay Date",
                  value: _formatDate(dividend.payDate),
                ),
                StatDetailItem(
                  title: "Div / Share",
                  value: '$currencySymbol${divPerShare.toStringAsFixed(4)}',
                ),
                StatDetailItem(
                  title: "Avg Cost",
                  value: avgCost > 0
                      ? '$currencySymbol${avgCost.toStringAsFixed(2)}'
                      : '—',
                ),
                StatDetailItem(
                  title: "Yield on Cost",
                  value: '${yieldOnCost.toStringAsFixed(2)}%',
                ),
                if (dividend.notes != null && dividend.notes!.isNotEmpty)
                  StatDetailItem(title: "Notes", value: dividend.notes!),
              ],
            ),

            const SizedBox(height: AppSizes.space3XL),

            // Net Amount kartı
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
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
                    text: "NET AMOUNT RECEIVED\n",
                    type: AppTextType.labelMedium,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.surfaceDark.withValues(alpha: 0.75)
                        : AppColors.surface.withValues(alpha: 0.75),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              '$currencySymbol${dividend.netAmount.toStringAsFixed(2)}',
                          style: AppTextTheme.textTheme.displaySmall!.copyWith(
                            color: isDark
                                ? AppColors.surface
                                : AppColors.surface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: '  ${dividend.currencyCode.toUpperCase()}',
                          style: AppTextTheme.textTheme.labelMedium!.copyWith(
                            color: isDark
                                ? AppColors.surface.withValues(alpha: 0.75)
                                : AppColors.surface.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.spaceXXL),

            // Dividend history linki
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.holdingDetail,
                  arguments: {'holding': holding},
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSizes.spaceMD,
                  horizontal: AppSizes.spaceLG,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceDark
                      : AppColors.overlay.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(AppSizes.radiusLG),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSizes.spaceSM),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.surface.withValues(alpha: 0.1)
                            : AppColors.surface,
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
                      child: Icon(
                        Icons.history,
                        size: AppSizes.iconLG,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: AppSizes.spaceMD),
                    Expanded(
                      child: AppText(
                        text: "View Dividend History",
                        type: AppTextType.titleMedium,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: AppSizes.iconSM,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSizes.spaceXXL),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
