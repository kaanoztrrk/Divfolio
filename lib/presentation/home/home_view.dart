import 'package:divfolio/constants/app_colors.dart';
import 'package:divfolio/widget/bottom_sheet/create_dividend_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:divfolio/widget/appbar/home_appbar.dart';

import '../../cubit/home_nav_cubit.dart';
import '../../widget/bottombar/bottombar.dart';
import '../dashboard/dashboard_view.dart';
import '../dividend_history/dividend_history_view.dart';
import '../portfolio/portfolio_view.dart';
import '../settings/settings_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final PageStorageBucket _bucket = PageStorageBucket();

    const List<Widget> _pages = <Widget>[
      DashboardView(key: PageStorageKey('dashboard')),
      PortfoliosView(key: PageStorageKey('portfolios')),
      DividendHistoryView(key: PageStorageKey('history')),
      SettingsView(key: PageStorageKey('settings')),
    ];

    return BlocProvider(
      create: (_) => HomeNavCubit(),
      child: BlocBuilder<HomeNavCubit, int>(
        builder: (context, index) {
          final navCubit = context.read<HomeNavCubit>();

          final showFab = index != 3; // Settings'te FAB kapalı

          return Scaffold(
            appBar: HomeAppBar(),

            body: PageStorage(
              bucket: _bucket,
              child: IndexedStack(index: index, children: _pages),
            ),

            floatingActionButton: showFab
                ? FloatingActionButton(
                    backgroundColor: AppColors.primary,
                    shape: const CircleBorder(),
                    onPressed: () => CreateDividendSheet.openAddSheet(context),
                    child: const Icon(Icons.add),
                  )
                : null,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,

            bottomNavigationBar: HomeBottomBar(
              currentIndex: index,
              showFab: showFab,
              onTap: navCubit.setTab,
            ),
          );
        },
      ),
    );
  }
}
