import 'package:divfolio/core/constants/app_images.dart';
import 'package:divfolio/core/utils/device_utility.dart';
import 'package:divfolio/core/utils/money_extension.dart';
import 'package:divfolio/data/model/holding_model.dart';
import 'package:divfolio/widget/button/primary_button.dart';
import 'package:divfolio/widget/text/app_text.dart';
import 'package:divfolio/widget/tile/dividend_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/dividend_bloc/dividend_bloc.dart';
import '../../bloc/dividend_bloc/dividend_event.dart';
import '../../bloc/dividend_bloc/dividend_state.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_size.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/empty_state.dart';
import 'widget/mini_status.dart';

class HoldingDetailView extends StatelessWidget {
  const HoldingDetailView({super.key, required this.holding});

  final HoldingModel holding;

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);
    context.read<DividendBloc>().add(
      LoadDividendsByCompany(
        portfolioId: holding.portfolioId,
        companyId: holding.id,
      ),
    );

    final currencySymbol = holding.currencyCode != null
        ? MoneyX.symbolOf(holding.currencyCode!)
        : '';
    final totalCost = (holding.avgCost ?? 0) * holding.shares;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,

        title: AppText(
          text: holding.companyName,
          type: AppTextType.titleMedium,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceMD,
          vertical: AppSizes.spaceSM,
        ),
        child: PrimaryButton(
          label: "Add Dividend",
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.addDividend);
          },
        ),
      ),
      body: BlocBuilder<DividendBloc, DividendState>(
        builder: (context, dState) {
          final dividends = dState.dividends;

          final lifetimeTotal = dividends.fold<double>(
            0,
            (sum, d) => sum + d.netAmount,
          );

          // Yield on Cost
          final yieldOnCost = totalCost > 0
              ? (lifetimeTotal / totalCost * 100)
              : 0.0;

          return Column(
            children: [
              // ---- HEADER ----
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
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusMD,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: AppText(
                          text: holding.companyId.length > 4
                              ? holding.companyId.substring(0, 4)
                              : holding.companyId,
                          type: AppTextType.titleMedium,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: AppSizes.spaceLG),
                      AppText(
                        text:
                            '$currencySymbol${lifetimeTotal.toStringAsFixed(2)}',
                        type: AppTextType.displayMedium,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: AppSizes.spaceSM),
                      AppText(
                        text: "TOTAL RECEIVED LIFETIME",
                        type: AppTextType.labelMedium,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                      const SizedBox(height: AppSizes.spaceMD),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MiniStat(
                              value: '${yieldOnCost.toStringAsFixed(2)}%',
                              label: "YIELD ON COST",
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: isDark
                                  ? AppColors.borderDark
                                  : AppColors.border,
                            ),
                            MiniStat(
                              value: holding.shares.toStringAsFixed(0),
                              label: "TOTAL SHARES",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ---- HISTORY HEADER ----
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceMD,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: AppText(
                        text: "DIVIDEND HISTORY",
                        type: AppTextType.labelMedium,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondary,
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    AppText(
                      text: '${dividends.length} records',
                      type: AppTextType.labelSmall,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.spaceSM),

              // ---- LIST ----
              Expanded(
                flex: 6,
                child: dState.loading
                    ? const Center(child: CircularProgressIndicator())
                    : dividends.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          EmptyState(
                            imagePath: AppImages.emptySearch,
                            title: "No Dividends Yet",
                            subtitle:
                                "This holding hasn't received any dividends.",
                          ),
                        ],
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(
                          AppSizes.spaceMD,
                          0,
                          AppSizes.spaceMD,
                          AppSizes.spaceMD,
                        ),
                        itemCount: dividends.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSizes.spaceSM),
                        itemBuilder: (context, i) {
                          final dividends = [...dState.dividends]
                            ..sort(
                              (a, b) => b.payDate.compareTo(a.payDate),
                            ); // ← en yeni üstte

                          return DividendTile(
                            dividend: dividends[i],
                            holding: holding,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
