import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/check_number_usecase.dart';
import 'number_checker_state.dart';

@injectable
class NumberCheckerCubit extends Cubit<NumberCheckerState> {
  final GetCarByPlateUseCase getCarByPlateUseCase;

  NumberCheckerCubit(this.getCarByPlateUseCase) : super(const NumberCheckerInitial());

  void setStep(CheckerStep step) {
    final currentPerson = state.person;

    if (state is NumberCheckerInitial) {
      emit(NumberCheckerInitial(person: currentPerson, step: step));
    } else if (state is NumberCheckerLoading) {
      emit(NumberCheckerLoading(person: currentPerson, step: step));
    } else if (state is NumberExists) {
      emit(NumberExists(currentPerson!, step: step));
    } else if (state is NumberNotExists) {
      emit(NumberNotExists(person: currentPerson, step: step));
    } else if (state is AdmitCarLoading) {
      emit(AdmitCarLoading(person: currentPerson, step: step));
    } else if (state is ExitCarLoading) {
      emit(ExitCarLoading(person: currentPerson, step: step));
    } else if (state is NumberCheckerError) {
      emit(NumberCheckerError(person: currentPerson, step: step, message: (state as NumberCheckerError).message));
    } else {
      // fallback
      emit(NumberCheckerInitial(person: currentPerson, step: step));
    }
  }

  Future<void> checkNumber(String number) async {
    emit(NumberCheckerLoading(person: state.person, step: state.step));

    try {
      final person = await getCarByPlateUseCase.execute(number);
      if (person != null) {
        emit(NumberExists(person, step: state.step));
      }
    } catch (e) {
      emit(NumberNotExists(step: state.step));
    }
  }

  Future<void> admitCar(int carId) async {
    emit(AdmitCarLoading(person: state.person, step: state.step));

    try {
      await getCarByPlateUseCase.admitCar(carId);
      emit(NumberCheckerInitial(person: state.person, step: state.step));
    } catch (e) {
      emit(NumberCheckerError(person: state.person, step: state.step, message: e.toString()));
    }
  }

  Future<void> exitCar(int carId) async {
    emit(ExitCarLoading(person: state.person, step: state.step));

    try {
      await getCarByPlateUseCase.exitCar(carId);
      emit(NumberCheckerInitial(person: state.person, step: state.step));
    } catch (e) {
      emit(NumberCheckerError(person: state.person, step: state.step, message: e.toString()));
    }
  }

  void emitInitial() {
    emit(const NumberCheckerInitial());
  }

  void reset() {
    emit(const NumberCheckerInitial());
  }
}
