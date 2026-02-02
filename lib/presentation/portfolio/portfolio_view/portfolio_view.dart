import 'package:divfolio/core/init/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/portfolio_bloc/portfolio_bloc.dart';
import '../../../bloc/portfolio_bloc/portfolio_event.dart';
import '../../../bloc/portfolio_bloc/portfolio_state.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_size.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/device_utility.dart';
import '../../../data/model/portfolio_model.dart';
import '../../../widget/text/app_text.dart';
import '../../../widget/tile/portfolio_tile.dart';

class PortfolioView extends StatelessWidget {
  const PortfolioView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMD),
        child: BlocBuilder<PortfolioBloc, PortfolioState>(
          builder: (context, state) {
            return Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSizes.spaceXL),
                    AppText(
                      text: "TOTAL NET DIVIDENDS",
                      type: AppTextType.labelMedium,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: AppSizes.spaceSM),

                    // placeholder
                    AppText(
                      text: "—",
                      type: AppTextType.displayMedium,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),

                    const SizedBox(height: AppSizes.space3XL),
                    Divider(
                      color: isDark ? AppColors.dividerDark : AppColors.divider,
                    ),
                    const SizedBox(height: AppSizes.spaceXL),
                  ],
                ),

                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spaceMD,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: "Active Portfolios",
                          type: AppTextType.titleMedium,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),

                        const SizedBox(height: AppSizes.spaceMD),

                        if (state.loading && state.portfolios.isEmpty)
                          const Expanded(
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (state.error != null &&
                            state.portfolios.isEmpty)
                          Expanded(
                            child: Center(
                              child: AppText(
                                text: state.error!,
                                type: AppTextType.bodyMedium,
                                color: AppColors.error,
                              ),
                            ),
                          )
                        else if (state.portfolios.isEmpty)
                          const Expanded(
                            child: Center(
                              child: AppText(
                                text: "No portfolios yet.",
                                type: AppTextType.bodyMedium,
                              ),
                            ),
                          )
                        else
                          Expanded(
                            child: ListView.builder(
                              itemCount: state.portfolios.length,
                              itemBuilder: (context, index) {
                                final PortfolioModel portfolio =
                                    state.portfolios[index];

                                return GestureDetector(
                                  onTap: () {
                                    context.read<PortfolioBloc>().add(
                                      SelectPortfolio(portfolio.id),
                                    );
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.portfolioDetails,
                                      arguments: portfolio.id,
                                    );
                                  },
                                  child: PortfolioTile(portfolio: portfolio),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
