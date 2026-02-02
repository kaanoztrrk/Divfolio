import 'package:divfolio/widget/text/app_text.dart';
import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_size.dart';
import 'widget/dividend_history_list.dart';

class DividendHistoryDetailView extends StatelessWidget {
  const DividendHistoryDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    const fakeHistory = [
      DividendHistoryUiItem(
        date: "Oct 15, 2023",
        periodLabel: "QUARTERLY",
        title: "Dividend Payout",
        amount: "\$12.00",
        sharesText: "50 Shares",
        perShareText: "\$0.24 / share",
        isActive: true,
      ),
      DividendHistoryUiItem(
        date: "Jul 15, 2023",
        periodLabel: "QUARTERLY",
        title: "Dividend Payout",
        amount: "\$11.50",
        sharesText: "50 Shares",
        perShareText: "\$0.23 / share",
      ),
      DividendHistoryUiItem(
        date: "Apr 15, 2023",
        periodLabel: "QUARTERLY",
        title: "Dividend Payout",
        amount: "\$10.35",
        sharesText: "45 Shares",
        perShareText: "\$0.23 / share",
      ),
      DividendHistoryUiItem(
        date: "Jan 15, 2023",
        periodLabel: "QUARTERLY",
        title: "Dividend Payout",
        amount: "\$9.20",
        sharesText: "40 Shares",
        perShareText: "\$0.23 / share",
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, elevation: 0),
      body: Column(
        children: [
          // Header (üst bölüm)
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.spaceMD),
              child: Column(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMD),
                    ),
                    alignment: Alignment.center,
                    child: AppText(
                      text: "AAPL",
                      type: AppTextType.labelLarge,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceLG),
                  AppText(
                    text: "\$12,345.67",
                    type: AppTextType.displayMedium,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: AppSizes.spaceSM),
                  AppText(
                    text: "TOTAL RECEIVED LIFETIME",
                    type: AppTextType.labelMedium,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: AppSizes.spaceMD),

                  // 2 stat
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _MiniStat(value: "4.2%", label: "YIELD ON COST"),
                        Container(
                          height: 40,
                          width: 1,
                          color: AppColors.border,
                        ),
                        _MiniStat(value: "155", label: "TOTAL SHARES"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Divider / Section header istersen ekle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMD),
            child: Row(
              children: [
                Expanded(
                  child: AppText(
                    text: "DIVIDEND HISTORY",
                    type: AppTextType.labelMedium,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                // year chip falan ekleyebilirsin
              ],
            ),
          ),
          const SizedBox(height: AppSizes.spaceSM),

          // List (alt bölüm)
          Expanded(
            flex: 6,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.spaceMD,
                0,
                AppSizes.spaceMD,
                AppSizes.spaceMD,
              ),
              itemCount: fakeHistory.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSizes.spaceSM),
              itemBuilder: (context, i) {
                final item = fakeHistory[i];
                return DividendHistoryItemTile(
                  date: item.date,
                  periodLabel: item.periodLabel,
                  title: item.title,
                  amount: item.amount,
                  sharesText: item.sharesText,
                  perShareText: item.perShareText,
                  isActive: item.isActive,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;

  const _MiniStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText(
          text: value,
          type: AppTextType.headlineSmall,
          fontWeight: FontWeight.w700,
        ),
        const SizedBox(height: AppSizes.spaceXS),
        AppText(
          text: label,
          type: AppTextType.labelSmall,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }
}

class DividendHistoryUiItem {
  final String date;
  final String periodLabel;
  final String title;
  final String amount;
  final String sharesText;
  final String perShareText;
  final bool isActive;

  const DividendHistoryUiItem({
    required this.date,
    required this.periodLabel,
    required this.title,
    required this.amount,
    required this.sharesText,
    required this.perShareText,
    this.isActive = false,
  });
}
