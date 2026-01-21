import 'package:divfolio/constants/app_size.dart';
import 'package:divfolio/widget/chip/app_chip.dart';
import 'package:divfolio/widget/text/app_text.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../widget/tile/dividend_tile.dart';
import '../dashboard/widget/portfolio_stats_row.dart';

class PortfolioDetailView extends StatelessWidget {
  const PortfolioDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // MVP: fake item count
    const int dividendCount = 6;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: AppText(text: 'Tech Stocks', type: AppTextType.titleMedium),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.edit))],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSizes.spaceXL),
        children: [
          // -------------------------
          // Header area
          // -------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: AppSizes.spaceXXL),
                AppChip(label: "USD", color: AppColors.textPrimary),
                SizedBox(height: AppSizes.spaceSM),
                AppText(
                  text: "\$12,345.67",
                  type: AppTextType.displaySmall,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: AppSizes.spaceSM),
                AppChip(
                  label: "+4.2%",
                  signedValue: 4.2,
                  type: AppTextType.titleMedium,
                ),
                SizedBox(height: AppSizes.spaceXXL),
                PortfolioStatsRow(
                  color: AppColors.surface,
                  firstTitle: 'Shares',
                  firstValue: '50.00',
                  secondTitle: 'Value',
                  secondValue: '\$6,500.00',
                  thirdTitle: 'DIV. Yield',
                  thirdValue: '3.1%',
                ),
              ],
            ),
          ),

          SizedBox(height: AppSizes.spaceXXL),

          // -------------------------
          // Dividend Summary Card
          // -------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMD),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.spaceXL),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppSizes.radiusMD),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: AppColors.primary),
                      SizedBox(width: AppSizes.spaceSM),
                      AppText(
                        text: "Dividend Summary",
                        type: AppTextType.titleMedium,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.spaceXL),
                  _SummaryRow(label: "Year-to-date", value: "\$845.37"),
                  SizedBox(height: AppSizes.spaceXL),
                  _SummaryRow(label: "Monthly Average", value: "\$84.53"),
                  SizedBox(height: AppSizes.spaceXL),
                  _SummaryRow(label: "Yield on Cost", value: "4.2%"),
                ],
              ),
            ),
          ),

          SizedBox(height: AppSizes.spaceXL),

          // -------------------------
          // Recent dividends header
          // -------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMD),
            child: Row(
              children: [
                Expanded(
                  child: AppText(
                    text: "RECENT DIVIDENDS",
                    type: AppTextType.labelMedium,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: navigate to full history
                  },
                  child: AppText(
                    text: "VIEW ALL",
                    type: AppTextType.labelMedium,
                    color: AppColors.primary.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // -------------------------
          // Tiles (NO nested ListView)
          // -------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMD),
            child: Column(
              children: List.generate(
                dividendCount,
                (_) => const DividendTile(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppText(
            text: label,
            type: AppTextType.bodyMedium,
            color: AppColors.textPrimary.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
        AppText(
          text: value,
          type: AppTextType.titleMedium,
          fontWeight: FontWeight.w800,
        ),
      ],
    );
  }
}
