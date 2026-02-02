import 'package:divfolio/bloc/portfolio_bloc/portfolio_event.dart';
import 'package:divfolio/presentation/dividend/add_dividend/add_dividend_view.dart';
import 'package:divfolio/presentation/add_holding/add_holding_view.dart';
import 'package:divfolio/presentation/dividend/dividend_detail/dividend_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/dividend_bloc/dividend_bloc.dart';
import '../../bloc/portfolio_bloc/portfolio_bloc.dart';
import '../../presentation/dividend/dividend_history_detail/dividend_history_detail_view.dart';
import '../../presentation/home/home_view.dart';
import '../../presentation/portfolio/portfolio_detail/portfolio_detail_view.dart';
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
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<DividendBloc>()),
              BlocProvider.value(value: getIt<PortfolioBloc>()),
            ],
            child: const HomeView(),
          ),
        );

      case AppRoutes.dividendDetail:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<DividendBloc>(),
            child: const DividendDetailView(),
          ),
        );

      case AppRoutes.dividendHistoryDetail:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<DividendBloc>(),
            child: const DividendHistoryDetailView(),
          ),
        );

      case AppRoutes.portfolioDetails:
        final portfolioId = settings.arguments as String;

        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<PortfolioBloc>()),
              BlocProvider.value(value: getIt<DividendBloc>()),
            ],
            child: PortfolioDetailView(portfolioId: portfolioId),
          ),
        );

      case AppRoutes.addDividend:
        return MaterialPageRoute(builder: (_) => const AddDividendView());

      case AppRoutes.addHolding:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: getIt<PortfolioBloc>()..add(LoadPortfolios()),
              ),
            ],
            child: AddHoldingView(),
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
