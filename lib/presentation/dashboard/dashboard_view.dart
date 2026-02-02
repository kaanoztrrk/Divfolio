import 'package:divfolio/constants/app_colors.dart';
import 'package:divfolio/constants/app_images.dart';
import 'package:divfolio/constants/app_size.dart';
import 'package:divfolio/core/utils/money_extension.dart';
import 'package:divfolio/cubit/currency_cubit.dart';
import 'package:divfolio/widget/text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/dividend_bloc/dividend_bloc.dart';
import '../../bloc/dividend_bloc/dividend_state.dart';
import '../../core/theme/custom/text_theme.dart';
import '../../core/utils/device_utility.dart';
import '../../core/utils/empty_state.dart';
import '../../cubit/decimal_format_cubit.dart';
import '../../widget/tile/dividend_tile.dart';
import 'widget/portfolio_stats_row.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMD),
          child: BlocBuilder<DividendBloc, DividendState>(
            builder: (context, state) {
              final items = state.dividends;
              final recent = items.take(5).toList();

              return Column(
                children: [
                  // ---- HEADER her zaman ----
                  BlocBuilder<CurrencyCubit, CurrencyState>(
                    builder: (context, _) {
                      return BlocBuilder<
                        DecimalFormatCubit,
                        DecimalFormatState
                      >(
                        builder: (context, __) {
                          return Column(
                            children: [
                              SizedBox(height: AppSizes.spaceXL),
                              AppText(
                                text: "TOTAL NET DIVIDENDS",
                                type: AppTextType.labelMedium,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(height: AppSizes.spaceMD),
                              AppText(
                                text: 12345.67.money(context),
                                type: AppTextType.displayMedium,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                              const SizedBox(height: AppSizes.spaceSM),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "+5.67%",
                                      style: AppTextTheme.textTheme.labelMedium!
                                          .copyWith(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                    TextSpan(
                                      text: " this year",
                                      style: AppTextTheme.textTheme.labelMedium!
                                          .copyWith(
                                            color: isDark
                                                ? AppColors.textSecondaryDark
                                                : AppColors.textSecondary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: AppSizes.spaceXXL),
                              PortfolioStatsRow(
                                color: isDark
                                    ? AppColors.surfaceDark
                                    : AppColors.surface,
                                firstTitle: 'Annual',
                                firstValue: 1200.money(context),
                                secondTitle: 'Yield',
                                secondValue: '5.6%',
                                thirdTitle: 'Holdings',
                                thirdValue: '24',
                              ),
                              const SizedBox(height: AppSizes.spaceXL),
                              Divider(
                                color: isDark
                                    ? AppColors.dividerDark
                                    : AppColors.divider,
                              ),
                              const SizedBox(height: AppSizes.spaceMD),
                            ],
                          );
                        },
                      );
                    },
                  ),

                  // ---- BODY: PortfoliosView mantığı ----
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        // loading sadece ilk yüklemede empty ise göster
                        if (state.loading && items.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        // error + empty
                        if (state.error != null && items.isEmpty) {
                          return Center(
                            child: AppText(
                              text: state.error!,
                              type: AppTextType.bodyMedium,
                              color: AppColors.error,
                            ),
                          );
                        }

                        // empty ama header kalsın: compact empty
                        if (items.isEmpty) {
                          return Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 340),
                              child: const EmptyState(
                                imagePath: AppImages.emptyReport,
                                title: "Your portfolio is empty",
                                subtitle:
                                    "Add your holdings to see dividend reports.",
                              ),
                            ),
                          );
                        }

                        // doluysa: recent list
                        return ListView.builder(
                          itemCount: recent.length,
                          itemBuilder: (context, index) {
                            final dividend = recent[index];
                            return DividendTile(dividend: dividend);
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
