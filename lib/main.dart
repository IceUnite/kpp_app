import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'feature/presentation/bloc/number_checker_cubit.dart';
import 'feature/presentation/pages/number_checker_page.dart';
import 'feature/domain/usecases/check_number_usecase.dart';
import 'feature/data/repositories/person_repository_impl.dart';
import 'feature/data/datasources/local_db.dart';
import 'helpers/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localDb = LocalDb();
  final repository = PersonRepositoryImpl(localDb);
  await LocalDb().deleteOldDb(); // Удаляем старую базу данных
  await copyDatabaseFromAssets(); // Копируем новую
  await LocalDb().checkDatabaseTables();  // Проверяем, есть ли таблицы
  await LocalDb().printDatabaseContent();  // Проверяем, есть ли таблицы
  final useCase = CheckNumberUseCase(repository);
  runApp(MyApp(useCase: useCase));
}

class MyApp extends StatelessWidget {
  final CheckNumberUseCase useCase;

  const MyApp({Key? key, required this.useCase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KPP App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (_) => NumberCheckerCubit(useCase),
        child: NumberCheckerPage(),
      ),
    );
  }
}
