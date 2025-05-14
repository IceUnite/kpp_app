import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/check_number_usecase.dart';
import '../../domain/entities/person.dart';

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
    } catch (_) {
      emit(NumberNotExists());
    }
  }

  Future<void> admitCar(int carId) async {
    emit(AdmitCarLoading());

    try {
      await getCarByPlateUseCase.admitCar(carId);

      // После успешной отправки сбрасываем состояние
      emit(NumberCheckerInitial());
    } catch (_) {
      // Ошибка — просто сбрасываем, или можешь добавить отдельное состояние
      emit(NumberNotExists());
    }
  }

  Future<void> exitCar(int carId) async {
    emit(ExitCarLoading());

    try {
      await getCarByPlateUseCase.exitCar(carId);
      emit(NumberCheckerInitial());
    } catch (_) {
      emit(NumberNotExists());
    }
  }

  void reset() {
    emit(NumberCheckerInitial());
  }
}
