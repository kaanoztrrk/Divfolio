import 'package:divfolio/bloc/dividend_bloc.dart';
import 'package:divfolio/cubit/currency_cubit.dart';
import 'package:divfolio/cubit/date_format_cubit.dart';
import 'package:divfolio/cubit/decimal_format_cubit.dart';
import 'package:divfolio/cubit/theme_cubit.dart';
import 'package:get_it/get_it.dart';

import '../../data/repository/dividend_repository.dart';
import '../../presentation/add_holding/cubit/add_holding_cubit.dart';
import '../../service/hive_manager.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  //* Repository
  getIt.registerLazySingleton<DividendRepository>(
    () => HiveDividendRepository(),
  );

  //* Blocs
  getIt.registerFactory<DividendBloc>(
    () => DividendBloc(getIt<DividendRepository>()),
  );

  //* Cubits
  getIt.registerLazySingleton<CurrencyCubit>(() => CurrencyCubit());
  getIt.registerLazySingleton<DateFormatCubit>(() => DateFormatCubit());
  getIt.registerLazySingleton<DecimalFormatCubit>(() => DecimalFormatCubit());
  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  getIt.registerFactory<HoldingFormCubit>(
    () => HoldingFormCubit(hive: getIt<HiveManager>()),
  );
}
