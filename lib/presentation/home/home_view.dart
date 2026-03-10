import 'package:divfolio/bloc/dividend_bloc/dividend_event.dart';
import 'package:divfolio/bloc/holding/holding_bloc.dart';
import 'package:divfolio/bloc/holding/holding_event.dart';
import 'package:divfolio/core/constants/app_colors.dart';
import 'package:divfolio/widget/bottom_sheet/create_dividend_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:divfolio/widget/appbar/home_appbar.dart';

import '../../bloc/dividend_bloc/dividend_bloc.dart';
import '../../bloc/portfolio_bloc/portfolio_bloc.dart';
import '../../bloc/portfolio_bloc/portfolio_event.dart';
import '../../core/init/locator.dart';
import '../../cubit/home_nav_cubit.dart';
import '../../widget/bottombar/bottombar.dart';
import '../dashboard/dashboard_view.dart';
import '../dividend_history/dividend_history_view.dart';
import '../main/portfolio/portfolio_view/portfolio_view.dart';
import '../settings/settings_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final PageStorageBucket bucket = PageStorageBucket();

    List<Widget> pages = <Widget>[
      DashboardView(key: PageStorageKey('dashboard')),
      PortfolioView(key: PageStorageKey('portfolios')),
      DividendHistoryView(key: PageStorageKey('history')),
      SettingsView(key: PageStorageKey('settings')),
    ];

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<PortfolioBloc>()..add(LoadPortfolios()),
        ),
        BlocProvider(
          create: (_) => getIt<HoldingBloc>()..add(LoadAllHoldings()),
        ),
        BlocProvider(
          create: (_) => getIt<DividendBloc>()..add(LoadAllDividends()),
        ),

        BlocProvider(create: (_) => HomeNavCubit()),
      ],

      child: BlocBuilder<HomeNavCubit, int>(
        builder: (context, index) {
          final navCubit = context.read<HomeNavCubit>();

          final showFab = index != 3; // Settings'te FAB kapalı

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: HomeAppBar(),

            body: PageStorage(
              bucket: bucket,
              child: IndexedStack(index: index, children: pages),
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
