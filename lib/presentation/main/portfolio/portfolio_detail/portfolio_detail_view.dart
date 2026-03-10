import 'package:divfolio/core/utils/device_utility.dart';
import 'package:divfolio/core/utils/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/dividend_bloc/dividend_bloc.dart';
import '../../../../bloc/dividend_bloc/dividend_event.dart';
import '../../../../bloc/dividend_bloc/dividend_state.dart';
import '../../../../bloc/holding/holding_bloc.dart';
import '../../../../bloc/holding/holding_event.dart';
import '../../../../bloc/holding/holding_state.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../data/model/portfolio_model.dart';
import '../../../../widget/button/primary_button.dart';
import '../../../../widget/chip/app_chip.dart';
import '../../../../widget/text/app_text.dart';
import '../../../dashboard/widget/portfolio_stats_row.dart';
import '../../dividend/add_dividend/add_dividend_view.dart';
import 'widget/dividend_summary_card.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PortfolioDetailView extends StatelessWidget {
  const PortfolioDetailView({super.key, required this.portfolio});

  final PortfolioModel portfolio;

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);

    context.read<HoldingBloc>().add(LoadHoldings(portfolio.id));
    context.read<DividendBloc>().add(
      LoadDividendSummary(portfolioId: portfolio.id, year: DateTime.now().year),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppText(text: portfolio.name, type: AppTextType.titleMedium),
      ),

      body: BlocBuilder<HoldingBloc, HoldingState>(
        builder: (context, hState) {
          if (hState.loading && hState.holdings.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (hState.holdings.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceXL),
              child: Column(
                children: [
                  const Spacer(),
                  EmptyState(
                    imagePath: AppImages.emptySearch,
                    imageSize: 125,
                    title: "No holdings found",
                    subtitle: "Add a holding to start tracking dividends.",
                  ),
                  const Spacer(),
                  PrimaryButton(
                    label: "Add Holding",
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddDividendView(),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceXXL),
                ],
              ),
            );
          }

          return BlocBuilder<DividendBloc, DividendState>(
            builder: (context, dState) {
              final currencyCode = portfolio.baseCurrencyCode;
              final currencySymbol = _symbolOf(currencyCode);

              // Toplam maliyet → Header'da gösterilecek
              final totalCost = hState.holdings.fold<double>(
                0,
                (t, h) => t + ((h.avgCost ?? 0) * h.shares),
              );

              // Yıllık gelir → Summary Card'da gösterilecek
              final annualIncome = dState.totalsByCurrency[currencyCode] ?? 0.0;

              // Yield on Cost
              final yieldOnCost = totalCost > 0
                  ? (annualIncome / totalCost * 100)
                  : 0.0;

              // Monthly average
              final monthlyAverage = annualIncome / 12;

              return ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceXL,
                ),
                children: [
                  const SizedBox(height: AppSizes.spaceXXL),

                  // Header → toplam maliyet gösteriyor
                  _HeaderCard(
                    portfolio: portfolio,
                    isDark: isDark,
                    totalCost: totalCost,
                    currencySymbol: currencySymbol,
                    yieldOnCost: yieldOnCost,
                  ),
                  const SizedBox(height: AppSizes.spaceXXL),

                  PortfolioStatsRow(
                    color: isDark ? AppColors.surfaceDark : AppColors.surface,
                    firstTitle: 'Annual',
                    firstValue:
                        '$currencySymbol${annualIncome.toStringAsFixed(0)}',
                    secondTitle: 'Yield',
                    secondValue: '${yieldOnCost.toStringAsFixed(1)}%',
                    thirdTitle: 'Holdings',
                    thirdValue: hState.holdings.length.toString(),
                  ),
                  const SizedBox(height: AppSizes.spaceXXL),

                  // Summary Card → gelir detayları
                  DividendSummaryCard(
                    isDark: isDark,
                    yearToDate:
                        '$currencySymbol${annualIncome.toStringAsFixed(2)}',
                    monthlyAverage:
                        '$currencySymbol${monthlyAverage.toStringAsFixed(2)}',
                    yieldOnCost: '${yieldOnCost.toStringAsFixed(2)}%',
                  ),
                  const SizedBox(height: AppSizes.spaceXXL),

                  AppText(
                    text: "Holdings",
                    type: AppTextType.titleMedium,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: AppSizes.spaceMD),

                  // Holdings listesi → her holding'in bu yılki geliri
                  ...hState.holdings.map((h) {
                    final holdingIncome =
                        dState.byCompanyByCurrency[h.id]?[currencyCode] ?? 0.0;

                    return Slidable(
                      key: ValueKey(h.id),
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        extentRatio: 0.25,
                        children: [
                          SlidableAction(
                            onPressed: (_) {
                              // Silme onay dialog'u
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const AppText(
                                    text: 'Delete Holding',
                                    type: AppTextType.titleMedium,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  content: AppText(
                                    text:
                                        '${h.companyName} and all its dividends will be deleted.',
                                    type: AppTextType.bodyMedium,
                                    color: AppColors.textSecondary,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const AppText(
                                        text: 'Cancel',
                                        type: AppTextType.bodyMedium,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context.read<HoldingBloc>().add(
                                          DeleteHolding(h.id),
                                        );
                                        Navigator.pop(ctx);
                                      },
                                      child: const AppText(
                                        text: 'Delete',
                                        type: AppTextType.bodyMedium,
                                        color: AppColors.error,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            backgroundColor: AppColors.error,
                            foregroundColor: Colors.white,
                            icon: Icons.delete_outline_rounded,
                            label: 'Delete',
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusMD,
                            ),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: AppText(
                          text: h.companyName,
                          type: AppTextType.bodyMedium,
                        ),
                        subtitle: AppText(
                          text: h.companyId,
                          type: AppTextType.labelMedium,
                          color: AppColors.textSecondary,
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            AppText(
                              text:
                                  '$currencySymbol${holdingIncome.toStringAsFixed(2)}',
                              type: AppTextType.bodyMedium,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                            AppText(
                              text: 'this year',
                              type: AppTextType.labelSmall,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: AppSizes.spaceXXL),
                  PrimaryButton(
                    label: "Add Dividend",
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddDividendView(),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSizes.spaceXXL),
                ],
              );
            },
          );
        },
      ),
    );
  }

  String _symbolOf(String code) {
    switch (code.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'TRY':
        return '₺';
      default:
        return code;
    }
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.portfolio,
    required this.isDark,
    required this.totalCost,
    required this.currencySymbol,
    required this.yieldOnCost,
  });

  final PortfolioModel portfolio;
  final bool isDark;
  final double totalCost; // totalIncome → totalCost oldu
  final String currencySymbol;
  final double yieldOnCost;

  @override
  Widget build(BuildContext context) {
    final yieldLabel =
        '${yieldOnCost > 0 ? '+' : ''}${yieldOnCost.toStringAsFixed(2)}%';

    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceXL),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMD),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.border,
        ),
      ),
      child: Column(
        children: [
          AppChip(
            label: portfolio.baseCurrencyCode.toUpperCase(),
            color: isDark ? AppColors.background : AppColors.overlay,
          ),
          const SizedBox(height: AppSizes.spaceMD),
          AppText(
            text: "TOTAL COST",
            type: AppTextType.labelMedium,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSizes.spaceXS),
          AppText(
            text: '$currencySymbol${totalCost.toStringAsFixed(2)}',
            type: AppTextType.headlineLarge,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spaceSM),
          AppChip(label: yieldLabel, signedValue: yieldOnCost),
        ],
      ),
    );
  }
}
