import 'package:divfolio/core/init/app_init.dart';
import 'package:divfolio/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/enum/theme_enum.dart';
import 'core/init/locator.dart';
import 'core/routes/app_router.dart';
import 'core/routes/app_routes.dart';
import 'cubit/currency_cubit.dart';
import 'cubit/date_format_cubit.dart';
import 'cubit/decimal_format_cubit.dart';
import 'cubit/theme_cubit.dart';
import 'service/shared_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInit.initHive();
  await SharedService().init();
  await setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<CurrencyCubit>()..load()),
        BlocProvider(create: (_) => getIt<ThemeCubit>()..load()),
        BlocProvider(create: (_) => getIt<DateFormatCubit>()..load()),
        BlocProvider(create: (_) => getIt<DecimalFormatCubit>()..load()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Divfolio',

            theme: appTheme,
            darkTheme: appThemeDark,
            themeMode: themeState.selected == AppThemeMode.system
                ? ThemeMode.system
                : themeState.selected == AppThemeMode.light
                ? ThemeMode.light
                : ThemeMode.dark,
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}
