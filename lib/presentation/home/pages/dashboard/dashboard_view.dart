import 'package:divfolio/core/constants/app_colors.dart';
import 'package:divfolio/core/constants/app_images.dart';
import 'package:divfolio/core/constants/app_size.dart';
import 'package:divfolio/core/utils/money_extension.dart';
import 'package:divfolio/widget/text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/dividend_bloc/dividend_bloc.dart';
import '../../../../bloc/dividend_bloc/dividend_state.dart';
import '../../../../bloc/holding_bloc/holding_bloc.dart';
import '../../../../bloc/holding_bloc/holding_event.dart';
import '../../../../bloc/holding_bloc/holding_state.dart';
import '../../../../bloc/portfolio_bloc/portfolio_bloc.dart';
import '../../../../bloc/portfolio_bloc/portfolio_state.dart';
import '../../../../core/utils/device_utility.dart';
import '../../../../core/utils/empty_state.dart';
import '../../../../widget/tile/holding_tile.dart';
import '../../../main/pages/dashboard/widget/portfolio_stats_row.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMD),
          child: BlocBuilder<PortfolioBloc, PortfolioState>(
            builder: (context, portfolioState) {
              final portfolio = portfolioState.selectedPortfolio;
              final baseCurrency = portfolio?.baseCurrencyCode ?? 'USD';
              final currencySymbol = MoneyX.symbolOf(baseCurrency);

              // HoldingBloc'u tetikle
              final pid = portfolioState.selectedPortfolioId;
              if (pid != null) {
                context.read<HoldingBloc>().add(LoadHoldings(pid));
              }

              return BlocBuilder<DividendBloc, DividendState>(
                builder: (context, dividendState) {
                  final items = dividendState.dividends;
                  final recent = items.take(5).toList();

                  // Seçili portfolio'nun para birimine göre toplam
                  final totalNet =
                      dividendState.totalsByCurrency[baseCurrency] ?? 0.0;

                  // Yıllık toplam — mevcut yıl filtreli
                  final currentYear = DateTime.now().year;
                  final annualNet = items
                      .where((d) => d.payDate.year == currentYear)
                      .fold<double>(0, (sum, d) => sum + d.netAmount);

                  return BlocBuilder<HoldingBloc, HoldingState>(
                    builder: (context, holdingState) {
                      final holdingCount = holdingState.holdings.length;
                      final holdingMap = {
                        for (final h in holdingState.holdings) h.id: h,
                      };

                      return Column(
                        children: [
                          // ---- HEADER ----
                          Column(
                            children: [
                              const SizedBox(height: AppSizes.spaceXL),
                              AppText(
                                text: "TOTAL NET DIVIDENDS",
                                type: AppTextType.labelMedium,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(height: AppSizes.spaceMD),
                              AppText(
                                text: totalNet.moneyWithSymbol(
                                  context,
                                  baseCurrency,
                                ),
                                type: AppTextType.displayMedium,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                              const SizedBox(height: AppSizes.spaceSM),
                              AppText(
                                text: portfolio?.name ?? '',
                                type: AppTextType.labelMedium,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(height: AppSizes.spaceXXL),
                              PortfolioStatsRow(
                                color: isDark
                                    ? AppColors.surfaceDark
                                    : AppColors.surface,
                                firstTitle: 'Annual',
                                firstValue:
                                    '$currencySymbol${annualNet.toStringAsFixed(2)}',
                                secondTitle: 'Currency',
                                secondValue: baseCurrency,
                                thirdTitle: 'Holdings',
                                thirdValue: holdingCount.toString(),
                              ),
                              const SizedBox(height: AppSizes.spaceXL),
                              Divider(
                                color: isDark
                                    ? AppColors.dividerDark
                                    : AppColors.divider,
                              ),
                              const SizedBox(height: AppSizes.spaceMD),
                            ],
                          ),

                          // ---- BODY ----
                          Expanded(
                            child: Builder(
                              builder: (context) {
                                if (dividendState.loading && items.isEmpty) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (dividendState.error != null &&
                                    items.isEmpty) {
                                  return Center(
                                    child: AppText(
                                      text: dividendState.error!,
                                      type: AppTextType.bodyMedium,
                                      color: AppColors.error,
                                    ),
                                  );
                                }

                                if (items.isEmpty) {
                                  return Center(
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 340,
                                      ),
                                      child: const EmptyState(
                                        imagePath: AppImages.emptyReport,
                                        title: "Your portfolio is empty",
                                        subtitle:
                                            "Add your holdings to see dividend reports.",
                                      ),
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  itemCount: recent.length,
                                  itemBuilder: (context, index) {
                                    final dividend = recent[index];
                                    final holding =
                                        holdingMap[dividend.holdingId];
                                    return HoldingTile(holding: holding!);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
