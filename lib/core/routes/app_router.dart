import 'package:divfolio/presentation/dividend_detail/dividend_detail_view.dart';
import 'package:flutter/material.dart';
import '../../presentation/dividend_history_detail/dividend_history_detail_view.dart';
import '../../presentation/home/home_view.dart';
import '../../presentation/splash/splash_view.dart';
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
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
