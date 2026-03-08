import 'package:divfolio/bloc/dividend_bloc/dividend_bloc.dart';
import 'package:divfolio/bloc/holding/holding_bloc.dart';
import 'package:divfolio/bloc/portfolio_bloc/portfolio_bloc.dart';
import 'package:divfolio/cubit/date_format_cubit.dart';
import 'package:divfolio/cubit/decimal_format_cubit.dart';
import 'package:divfolio/cubit/theme_cubit.dart';
import 'package:divfolio/data/repository/holding_repository.dart';
import 'package:divfolio/data/repository/portfolio_repository.dart';
import 'package:get_it/get_it.dart';

import '../../data/repository/dividend_repository.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  //* Repository
  getIt.registerLazySingleton<DividendRepository>(
    () => HiveDividendRepository(),
  );
  getIt.registerLazySingleton<PortfolioRepository>(
    () => HivePortfolioRepository(),
  );
  getIt.registerLazySingleton<HoldingRepository>(() => HiveHoldingRepository());

  //* Blocs
  getIt.registerFactory<DividendBloc>(
    () => DividendBloc(getIt<DividendRepository>()),
  );
  getIt.registerFactory<PortfolioBloc>(
    () => PortfolioBloc(
      portfolioRepository: getIt<PortfolioRepository>(),
      holdingRepository: getIt<HoldingRepository>(),
      dividendRepository: getIt<DividendRepository>(),
    ),
  );
  getIt.registerFactory<HoldingBloc>(
    () => HoldingBloc(
      holdingRepository: getIt<HoldingRepository>(),
      dividendRepository: getIt<DividendRepository>(),
    ),
  );

  //* Cubits
  getIt.registerLazySingleton<DateFormatCubit>(() => DateFormatCubit());
  getIt.registerLazySingleton<DecimalFormatCubit>(() => DecimalFormatCubit());
  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
}
