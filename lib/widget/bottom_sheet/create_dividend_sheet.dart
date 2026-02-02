import 'package:divfolio/constants/app_colors.dart';
import 'package:divfolio/constants/app_size.dart';
import 'package:flutter/material.dart';

import 'package:divfolio/core/routes/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/portfolio_bloc/portfolio_bloc.dart';
import '../../core/utils/device_utility.dart';
import '../../widget/text/app_text.dart';
import 'create_portfolio_sheet.dart';

class CreateDividendSheet {
  static void openAddSheet(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);
    final nav = Navigator.of(context);

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.add_chart),
                title: const AppText(
                  text: 'Add Holding',
                  type: AppTextType.bodyLarge,
                ),
                onTap: () {
                  nav.pop();
                  nav.pushNamed(AppRoutes.addHolding);
                },
              ),
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const AppText(
                  text: 'Add Dividend',
                  type: AppTextType.bodyLarge,
                ),
                onTap: () {
                  nav.pop();
                  nav.pushNamed(AppRoutes.addDividend);
                },
              ),
              Divider(
                height: AppSizes.spaceXL,
                color: isDark ? AppColors.dividerDark : AppColors.divider,
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet_outlined),
                title: const AppText(
                  text: 'Add Portfolio',
                  type: AppTextType.bodyLarge,
                ),
                onTap: () {
                  nav.pop();

                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    showDragHandle: true,
                    builder: (_) => BlocProvider.value(
                      value: context.read<PortfolioBloc>(),
                      child: CreatePortfolioSheet(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
