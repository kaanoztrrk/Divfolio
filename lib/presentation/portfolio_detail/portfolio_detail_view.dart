// ignore_for_file: depend_on_referenced_packages

import 'package:divfolio/core/utils/device_utility.dart';
import 'package:divfolio/core/utils/empty_state.dart';
import '../../core/routes/app_routes.dart';
import '../../widget/button/slidable_button.dart';
import '../../widget/dialog/confirm_dialog.dart';
import '../main/pages/dashboard/widget/portfolio_stats_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/dividend_bloc/dividend_bloc.dart';
import '../../bloc/dividend_bloc/dividend_event.dart';
import '../../bloc/dividend_bloc/dividend_state.dart';
import '../../bloc/holding_bloc/holding_bloc.dart';
import '../../bloc/holding_bloc/holding_event.dart';
import '../../bloc/holding_bloc/holding_state.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_images.dart';
import '../../core/constants/app_size.dart';
import '../../core/utils/money_extension.dart';
import '../../data/model/portfolio_model.dart';
import '../../widget/button/primary_button.dart';
import '../../widget/text/app_text.dart';
import '../add_dividend/add_dividend_view.dart';
import 'widget/dividend_summary_card.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'widget/header_widget.dart';

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
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.addHolding,
                      arguments: portfolio,
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
              final currencySymbol = MoneyX.symbolOf(currencyCode);

              final totalCost = hState.holdings.fold<double>(
                0,
                (t, h) => t + ((h.avgCost ?? 0) * h.shares),
              );

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

                  HeaderCard(
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

                  ...hState.holdings.map((h) {
                    final holdingIncome =
                        dState.byCompanyByCurrency[h.id]?[currencyCode] ?? 0.0;

                    return Slidable(
                      key: ValueKey(h.id),
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        extentRatio: 0.80,
                        children: [
                          DeleteSlidableAction(
                            confirmTitle: 'Delete Holding',
                            confirmMessage:
                                '${h.companyName} and all its dividends will be deleted.',
                            onConfirm: () => context.read<HoldingBloc>().add(
                              DeleteHolding(h.id),
                            ),
                          ),
                          EditSlidableAction(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.editHolding,
                                arguments: h,
                              );
                            },
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.holdingDetail,
                            arguments: {'holding': h},
                          );
                        },
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
}
