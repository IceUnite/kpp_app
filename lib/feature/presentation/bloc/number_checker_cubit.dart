import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/check_number_usecase.dart';
import '../../domain/entities/person.dart';  // Путь к сущности Person

part 'number_checker_state.dart';
@injectable
class NumberCheckerCubit extends Cubit<NumberCheckerState> {
  final GetCarByPlateUseCase getCarByPlateUseCase;

  NumberCheckerCubit(this.getCarByPlateUseCase) : super(NumberCheckerInitial());

  Future<void> checkNumber(String number) async {
    emit(NumberCheckerLoading());

    try {
      final person = await getCarByPlateUseCase.execute(number);

      if (person != null) {
        emit(NumberExists(person));
      } else {
        emit(NumberNotExists());
      }
    } catch (e) {
      emit(NumberNotExists());
    }
  }

  void reset() {
    emit(NumberCheckerInitial());
  }
}
