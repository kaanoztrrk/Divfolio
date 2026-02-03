import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:divfolio/constants/app_size.dart';
import 'package:divfolio/widget/chip/app_chip.dart';
import 'package:divfolio/widget/text/app_text.dart';

import '../../../bloc/dividend_bloc/dividend_bloc.dart';
import '../../../bloc/dividend_bloc/dividend_state.dart';
import '../../../bloc/portfolio_bloc/portfolio_bloc.dart';
import '../../../bloc/portfolio_bloc/portfolio_state.dart';
import '../../../constants/app_colors.dart';
import '../../../cubit/currency_cubit.dart';
import '../../../data/model/portfolio_model.dart';
import '../../../widget/tile/dividend_tile.dart';
import '../../dashboard/widget/portfolio_stats_row.dart';

class PortfolioDetailView extends StatelessWidget {
  const PortfolioDetailView({super.key, required this.portfolioId});

  final String portfolioId;

  PortfolioModel? _findPortfolio(PortfolioState state) {
    try {
      return state.portfolios.firstWhere((p) => p.id == portfolioId);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioBloc, PortfolioState>(
      builder: (context, pState) {
        final portfolio = _findPortfolio(pState);

        if (portfolio == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              centerTitle: true,
              title: const AppText(
                text: 'Portfolio',
                type: AppTextType.titleMedium,
              ),
            ),
            body: const Center(
              child: AppText(
                text: "Portfolio not found.",
                type: AppTextType.bodyMedium,
                color: AppColors.textSecondary,
              ),
            ),
          );
        }

        return BlocBuilder<CurrencyCubit, CurrencyState>(
          builder: (context, currencyState) {
            final currency = currencyState.selected;

            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                backgroundColor: AppColors.background,
                elevation: 0,
                centerTitle: true,
                title: AppText(
                  text: portfolio.name,
                  type: AppTextType.titleMedium,
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      // TODO: edit portfolio
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
              body: ListView(
                padding: const EdgeInsets.only(bottom: AppSizes.spaceXL),
                children: [
                  // HEADER
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spaceMD,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: AppSizes.spaceXXL),

                        AppChip(
                          label: currency.code,
                          color: AppColors.textPrimary,
                        ),

                        const SizedBox(height: AppSizes.spaceSM),

                        AppText(
                          text: "${currency.symbol}—",
                          type: AppTextType.displaySmall,
                          fontWeight: FontWeight.w700,
                        ),

                        const SizedBox(height: AppSizes.spaceSM),

                        const AppChip(
                          label: "—",
                          type: AppTextType.titleMedium,
                        ),

                        const SizedBox(height: AppSizes.spaceXXL),

                        const PortfolioStatsRow(
                          color: AppColors.surface,
                          firstTitle: 'Shares',
                          firstValue: '—',
                          secondTitle: 'Value',
                          secondValue: '—',
                          thirdTitle: 'DIV. Yield',
                          thirdValue: '—',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSizes.spaceXXL),

                  // DIVIDEND SUMMARY
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spaceMD,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(AppSizes.spaceXL),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(AppSizes.radiusMD),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: BlocBuilder<DividendBloc, DividendState>(
                        builder: (context, dState) {
                          final dividends = dState.dividends
                              .where((d) => d.portfolioId == portfolioId)
                              .toList();

                          return Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: AppSizes.spaceSM),
                                  const AppText(
                                    text: "Dividend Summary",
                                    type: AppTextType.titleMedium,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSizes.spaceXL),
                              _SummaryRow(
                                label: "Year-to-date",
                                value: "${currency.symbol}—",
                              ),
                              const SizedBox(height: AppSizes.spaceXL),
                              _SummaryRow(
                                label: "Monthly Average",
                                value: "${currency.symbol}—",
                              ),
                              const SizedBox(height: AppSizes.spaceXL),
                              const _SummaryRow(
                                label: "Yield on Cost",
                                value: "—",
                              ),
                              const SizedBox(height: AppSizes.spaceSM),
                              AppText(
                                text: "Records: ${dividends.length}",
                                type: AppTextType.labelMedium,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSizes.spaceXL),

                  // RECENT DIVIDENDS
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spaceMD,
                    ),
                    child: BlocBuilder<DividendBloc, DividendState>(
                      builder: (context, dState) {
                        final items =
                            dState.dividends
                                .where((d) => d.portfolioId == portfolioId)
                                .toList()
                              ..sort((a, b) => b.payDate.compareTo(a.payDate));

                        if (items.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: AppSizes.spaceXL,
                            ),
                            child: Center(
                              child: AppText(
                                text: "No dividends yet.",
                                type: AppTextType.bodyMedium,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: items
                              .take(5)
                              .map((d) => DividendTile(dividend: d))
                              .toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
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
