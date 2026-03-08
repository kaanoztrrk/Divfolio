import 'package:divfolio/core/utils/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/holding/holding_bloc.dart';
import '../../../bloc/holding/holding_event.dart';
import '../../../bloc/holding/holding_state.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_size.dart';
import '../../../data/model/portfolio_model.dart';
import '../../../widget/chip/app_chip.dart';
import '../../../widget/text/app_text.dart';
import '../../dashboard/widget/portfolio_stats_row.dart';

class PortfolioDetailView extends StatelessWidget {
  const PortfolioDetailView({super.key, required this.portfolio});

  final PortfolioModel portfolio;

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);
    context.read<HoldingBloc>().add(LoadHoldings(portfolio.id));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppText(text: portfolio.name, type: AppTextType.titleMedium),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceXL),

        children: [
          const SizedBox(height: AppSizes.spaceXXL),

          /// HEADER
          Container(
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
                  color: AppColors.overlay,
                ),
                const SizedBox(height: AppSizes.spaceMD),
                AppText(
                  text: "45.000",
                  type: AppTextType.headlineLarge,
                  color: AppColors.textPrimary,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSizes.spaceSM),
                AppChip(
                  label: "12.5%",
                  signedValue: 5000,
                  trailingIcon: Icons.arrow_upward_rounded,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.spaceXXL),

          /// STATS
          BlocBuilder<HoldingBloc, HoldingState>(
            builder: (context, hState) {
              final holdings = hState.holdings;

              final totalShares = holdings.fold<double>(
                0,
                (t, h) => t + h.shares,
              );

              return PortfolioStatsRow(
                color: AppColors.surface,
                firstTitle: 'Holdings',
                firstValue: holdings.length.toString(),
                secondTitle: 'Shares',
                secondValue: totalShares.toStringAsFixed(2),
                thirdTitle: 'Value',
                thirdValue: '—',
              );
            },
          ),

          const SizedBox(height: AppSizes.spaceXXL),

          /// HOLDINGS
          BlocBuilder<HoldingBloc, HoldingState>(
            builder: (context, hState) {
              if (hState.loading && hState.holdings.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(AppSizes.spaceXL),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (hState.holdings.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSizes.spaceXL),
                  child: Center(
                    child: AppText(
                      text: 'No holdings yet.',
                      type: AppTextType.bodyMedium,
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    text: 'Holdings',
                    type: AppTextType.titleMedium,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: AppSizes.spaceMD),
                  ...hState.holdings.map(
                    (h) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: AppText(
                        text: h.companyName,
                        type: AppTextType.bodyMedium,
                      ),
                      subtitle: AppText(
                        text: '',
                        type: AppTextType.labelMedium,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: AppSizes.spaceXXL),

          const SizedBox(height: AppSizes.spaceXL),
        ],
      ),
    );
  }
}
