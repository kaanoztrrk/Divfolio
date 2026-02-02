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

  String _symbolOf(String currencyCode) {
    switch (currencyCode.toUpperCase()) {
      case 'TRY':
        return '₺';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'USD':
      default:
        return '\$';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioBloc, PortfolioState>(
      builder: (context, pState) {
        final portfolio = _findPortfolio(pState);

        // Portfolio state yüklenmediyse / bulunamadıysa
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

        final currencyCode = portfolio.baseCurrencyCode;
        final symbol = _symbolOf(currencyCode);

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            centerTitle: true,
            title: AppText(text: portfolio.name, type: AppTextType.titleMedium),
            actions: [
              IconButton(
                onPressed: () {
                  // TODO: edit portfolio screen
                },
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.only(bottom: AppSizes.spaceXL),
            children: [
              // -------------------------
              // Header area
              // -------------------------
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceMD,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: AppSizes.spaceXXL),

                    AppChip(label: currencyCode, color: AppColors.textPrimary),

                    const SizedBox(height: AppSizes.spaceSM),

                    // TODO: portfolio value (holdings'ten hesaplanacak)
                    AppText(
                      text: "$symbol—",
                      type: AppTextType.displaySmall,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),

                    const SizedBox(height: AppSizes.spaceSM),

                    // TODO: change % (holdings değer değişimi vs)
                    const AppChip(label: "—", type: AppTextType.titleMedium),

                    const SizedBox(height: AppSizes.spaceXXL),

                    // TODO: gerçek veriler (holdings)
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

              // -------------------------
              // Dividend Summary Card
              // -------------------------
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceMD,
                ),
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
                  child: BlocBuilder<DividendBloc, DividendState>(
                    builder: (context, dState) {
                      final dividends = dState.dividends
                          .where((d) => d.portfolioId == portfolioId)
                          .toList();

                      // TODO: summary hesaplarını sonra netleştiririz
                      // Şimdilik placeholder; ama filtre portfolio bazında.
                      final ytd = '—';
                      final monthlyAvg = '—';
                      final yoc = '—';

                      return Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: AppSizes.spaceSM),
                              AppText(
                                text: "Dividend Summary",
                                type: AppTextType.titleMedium,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSizes.spaceXL),
                          _SummaryRow(
                            label: "Year-to-date",
                            value: "$symbol$ytd",
                          ),
                          const SizedBox(height: AppSizes.spaceXL),
                          _SummaryRow(
                            label: "Monthly Average",
                            value: "$symbol$monthlyAvg",
                          ),
                          const SizedBox(height: AppSizes.spaceXL),
                          _SummaryRow(label: "Yield on Cost", value: yoc),
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

              // -------------------------
              // Recent dividends header
              // -------------------------
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceMD,
                ),
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
                        // TODO: navigate to full history (portfolioId ile)
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
              // Recent dividend tiles
              // -------------------------
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceMD,
                ),
                child: BlocBuilder<DividendBloc, DividendState>(
                  builder: (context, dState) {
                    if (dState.loading && dState.dividends.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSizes.spaceXL,
                        ),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (dState.error != null && dState.dividends.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSizes.spaceXL,
                        ),
                        child: Center(
                          child: AppText(
                            text: dState.error!,
                            type: AppTextType.bodyMedium,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    }

                    final items = dState.dividends
                        .where((d) => d.portfolioId == portfolioId)
                        .toList();

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

                    // en yeni 5 (payDate veya createdAt hangisi varsa)
                    items.sort((a, b) => b.payDate.compareTo(a.payDate));
                    final recent = items.take(5).toList();

                    return Column(
                      children: [
                        for (final dividend in recent)
                          DividendTile(dividend: dividend),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
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
