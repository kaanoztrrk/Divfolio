import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/holding_bloc/holding_bloc.dart';
import '../../../../bloc/holding_bloc/holding_state.dart';
import '../../../../bloc/portfolio_bloc/portfolio_bloc.dart';
import '../../../../bloc/portfolio_bloc/portfolio_state.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../widget/text/app_text.dart';
import '../../../../widget/tile/portfolio_tile.dart';

class PortfolioView extends StatelessWidget {
  const PortfolioView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioBloc, PortfolioState>(
      builder: (context, pState) {
        return BlocBuilder<HoldingBloc, HoldingState>(
          builder: (context, hState) {
            final portfolios = pState.portfolios;

            if (pState.loading && portfolios.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (pState.error != null && portfolios.isEmpty) {
              return Center(
                child: AppText(
                  text: pState.error!,
                  type: AppTextType.bodyMedium,
                  color: AppColors.error,
                ),
              );
            }

            if (portfolios.isEmpty) {
              return const Center(
                child: AppText(
                  text: "No portfolios yet.",
                  type: AppTextType.bodyMedium,
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceMD,
                vertical: AppSizes.spaceMD,
              ),
              itemCount: portfolios.length,
              itemBuilder: (context, index) {
                final portfolio = portfolios[index];

                final holdings = hState.holdings
                    .where((h) => h.portfolioId == portfolio.id)
                    .toList();

                final assetCount = holdings.length;
                final totalValue = holdings.fold<double>(
                  0,
                  (sum, h) =>
                      sum + (h.avgCost != null ? h.avgCost! * h.shares : 0),
                );

                return PortfolioTile(
                  portfolio: portfolio,
                  assetCount: assetCount,
                  totalValue: totalValue,
                );
              },
            );
          },
        );
      },
    );
  }
}
