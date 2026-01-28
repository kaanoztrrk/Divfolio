import 'package:divfolio/presentation/add_dividend/add_dividend_view.dart';
import 'package:divfolio/presentation/add_holding/add_holding_view.dart';
import 'package:divfolio/presentation/dividend_detail/dividend_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/dividend_bloc.dart';
import '../../presentation/add_holding/cubit/add_holding_cubit.dart';
import '../../presentation/dividend_history_detail/dividend_history_detail_view.dart';
import '../../presentation/home/home_view.dart';
import '../../presentation/portfolio_detail/portfolio_detail_view.dart';
import '../../presentation/splash/splash_view.dart';
import '../../service/hive_manager.dart';
import '../init/locator.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashView());

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeView());

      case AppRoutes.dividendDetail:
        return MaterialPageRoute(builder: (_) => const DividendDetailView());

      case AppRoutes.dividendHistoryDetail:
        return MaterialPageRoute(
          builder: (_) => const DividendHistoryDetailView(),
        );

      case AppRoutes.portfolioDetails:
        return MaterialPageRoute(builder: (_) => const PortfolioDetailView());

      case AppRoutes.addDividend:
        return MaterialPageRoute(builder: (_) => const AddDividendView());

      case AppRoutes.addHolding:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (ctx) {
              final selectedPid = ctx
                  .read<DividendBloc>()
                  .state
                  .selectedPortfolioId;

              final cubit = getIt<HoldingFormCubit>();
              cubit.loadPortfolios(initialSelectedId: selectedPid);
              return cubit;
            },
            child: const AddHoldingView(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
