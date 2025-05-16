import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:window_size/window_size.dart';

import 'core/internal/di/sl.dart';
import 'core/router/router.dart';
import 'feature/presentation/bloc/number_checker_cubit.dart';
import 'feature/presentation/bloc/historiya_cubit.dart'; // импортируем второй Cubit

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru', null);
  configureDependencies();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('KPP App');
    final screens = await getScreenList();
    final screen = screens.first;
    setWindowFrame(screen.frame);
  }

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NumberCheckerCubit>(
          create: (context) => getIt<NumberCheckerCubit>(),
        ),
        BlocProvider<HistoriaCubit>(
          create: (context) => getIt<HistoriaCubit>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'KPP App',
        theme: ThemeData(primarySwatch: Colors.blue),
        supportedLocales: const [
          Locale('ru'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: router,
      ),
    );
  }
}
