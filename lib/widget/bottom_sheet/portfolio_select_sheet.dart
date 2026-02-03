import 'package:divfolio/core/utils/device_utility.dart';
import 'package:divfolio/widget/button/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/portfolio_bloc/portfolio_bloc.dart';
import '../../bloc/portfolio_bloc/portfolio_event.dart';
import '../../bloc/portfolio_bloc/portfolio_state.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../core/init/locator.dart';
import '../../widget/text/app_text.dart';
import 'create_portfolio_sheet.dart';

class PortfolioBottomSheet extends StatelessWidget {
  const PortfolioBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceMD),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              children: [
                const Expanded(
                  child: AppText(
                    text: "Select Portfolio",
                    type: AppTextType.titleMedium,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceMD),

            /// List
            BlocBuilder<PortfolioBloc, PortfolioState>(
              builder: (context, state) {
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.portfolios.length,
                  separatorBuilder: (_, __) => Divider(
                    color: isDark ? AppColors.dividerDark : AppColors.divider,
                  ),
                  itemBuilder: (context, index) {
                    final item = state.portfolios[index];
                    final isSelected = item.id == state.selectedPortfolioId;

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        context.read<PortfolioBloc>().add(
                          SelectPortfolio(item.id),
                        );
                        Navigator.pop(context);
                      },
                      leading: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusMD,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: AppText(
                          text: item.name.characters.first.toUpperCase(),
                          type: AppTextType.titleMedium,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      title: AppText(
                        text: item.name,
                        type: AppTextType.titleMedium,
                        fontWeight: FontWeight.w700,
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.primary,
                            )
                          : Icon(
                              Icons.circle_outlined,
                              color: isDark
                                  ? AppColors.borderDark
                                  : AppColors.border,
                            ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: AppSizes.spaceMD),

            /// Create button
            PrimaryButton(
              label: "Create Portfolio",
              onPressed: () async {
                await showModalBottomSheet<String>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => BlocProvider.value(
                    value: getIt<PortfolioBloc>(),
                    child: CreatePortfolioSheet(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
