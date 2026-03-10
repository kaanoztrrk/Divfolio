import 'package:divfolio/bloc/holding/holding_bloc.dart';
import 'package:divfolio/bloc/portfolio_bloc/portfolio_event.dart';
import 'package:divfolio/presentation/main/dividend/add_dividend/add_dividend_view.dart';
import 'package:divfolio/presentation/main/holding/add_holding/add_holding_view.dart';
import 'package:divfolio/presentation/main/dividend/dividend_detail/dividend_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/dividend_bloc/dividend_bloc.dart';
import '../../bloc/portfolio_bloc/portfolio_bloc.dart';
import '../../data/model/dividend_model.dart';
import '../../data/model/holding_model.dart';
import '../../data/model/portfolio_model.dart';
import '../../presentation/main/holding/holding_detail/holding_detail_view.dart';
import '../../presentation/home/home_view.dart';
import '../../presentation/main/portfolio/portfolio_detail/portfolio_detail_view.dart';
import '../../presentation/splash/splash_view.dart';
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
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<DividendBloc>(),
            child: DividendDetailView(
              dividend: args['dividend'] as DividendModel,
              holding: args['holding'] as HoldingModel?,
            ),
          ),
        );

      case AppRoutes.holdingDetail:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<DividendBloc>()),
              BlocProvider.value(value: getIt<HoldingBloc>()),
            ],
            child: HoldingDetailView(holding: args['holding'] as HoldingModel),
          ),
        );

      case AppRoutes.portfolioDetails:
        final portfolio = settings.arguments as PortfolioModel;

        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<PortfolioBloc>()),
              BlocProvider.value(value: getIt<HoldingBloc>()),
              BlocProvider.value(value: getIt<DividendBloc>()),
            ],
            child: PortfolioDetailView(portfolio: portfolio),
          ),
        );

      case AppRoutes.addDividend:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<PortfolioBloc>()),
              BlocProvider.value(value: getIt<HoldingBloc>()),
              BlocProvider.value(value: getIt<DividendBloc>()),
            ],
            child: const AddDividendView(),
          ),
        );

      case AppRoutes.addHolding:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: getIt<PortfolioBloc>()..add(LoadPortfolios()),
              ),
              BlocProvider.value(value: getIt<HoldingBloc>()),
              BlocProvider.value(value: getIt<DividendBloc>()),
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
