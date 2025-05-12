import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'feature/data/repositories/person_repository_impl.dart';
import 'feature/domain/usecases/check_number_usecase.dart';
import 'feature/presentation/bloc/number_checker_cubit.dart';
import 'feature/presentation/pages/number_checker_page.dart';


void main() {
  final repository = PersonRepositoryImpl();
  final useCase = CheckNumberUseCase(repository);

  runApp(MyApp(useCase));
}

class MyApp extends StatelessWidget {
  final CheckNumberUseCase useCase;

  MyApp(this.useCase);

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Проверка номера',
      theme: AppTheme.lightTheme,
      home: BlocProvider(
        create: (_) => NumberCheckerCubit(useCase),
        child: NumberCheckerPage(),
      ),
    );
  }
}
