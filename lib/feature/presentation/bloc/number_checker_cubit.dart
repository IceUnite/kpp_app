import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

import '../../domain/usecases/check_number_usecase.dart';
import 'number_checker_state.dart';


@injectable
class NumberCheckerCubit extends Cubit<NumberCheckerState> {
  final GetCarByPlateUseCase getCarByPlateUseCase;


  NumberCheckerCubit(this.getCarByPlateUseCase) : super(const NumberCheckerInitial());

  void setStep(CheckerStep step) {
    final currentPerson = state.person;
    final currentReport = state.report;

    if (state is NumberCheckerInitial) {
      emit(NumberCheckerInitial(person: currentPerson, report: currentReport, step: step));
    } else if (state is NumberCheckerLoading) {
      emit(NumberCheckerLoading(person: currentPerson, report: currentReport, step: step));
    } else if (state is NumberExists) {
      emit(NumberExists(currentPerson!, report: currentReport, step: step));
    } else if (state is NumberNotExists) {
      emit(NumberNotExists(person: currentPerson, report: currentReport, step: step));
    } else if (state is AdmitCarLoading) {
      emit(AdmitCarLoading(person: currentPerson, report: currentReport, step: step));
    } else if (state is ExitCarLoading) {
      emit(ExitCarLoading(person: currentPerson, report: currentReport, step: step));
    } else {
      // fallback
      emit(NumberCheckerInitial(person: currentPerson, report: currentReport, step: step));
    }
  }

  Future<void> checkNumber(String number) async {
    emit(NumberCheckerLoading(person: state.person, report: state.report, step: state.step));

    try {
      final person = await getCarByPlateUseCase.execute(number);
      final report = await getCarByPlateUseCase.getReport(
        startDate: DateFormat('yyyy-MM-dd').format(
          DateTime.now().subtract(const Duration(days: 1)),
        ),
      );

      if (person != null) {
        emit(NumberExists(person, report: report, step: state.step));
      } else {
        emit(NumberNotExists(person: state.person, report: report, step: state.step));
      }
    } catch (_) {
      emit(NumberNotExists(person: state.person, report: state.report, step: state.step));
    }
  }

  Future<void> admitCar(int carId) async {
    emit(AdmitCarLoading(person: state.person, report: state.report, step: state.step));

    try {
      await getCarByPlateUseCase.admitCar(carId);
      final report = await getCarByPlateUseCase.getReport(
        startDate: DateFormat('yyyy-MM-dd').format(
          DateTime.now().subtract(const Duration(days: 1)),
        ),
      );

      // После успешной операции сбрасываем состояние в начальное, сохраняя отчет
      emit(NumberCheckerInitial(report: report));
    } catch (_) {
    }
  }

  Future<void> exitCar(int carId) async {
    emit(ExitCarLoading(person: state.person, report: state.report, step: state.step));

    try {
      await getCarByPlateUseCase.exitCar(carId);
      final report = await getCarByPlateUseCase.getReport(
        startDate: DateFormat('yyyy-MM-dd').format(
          DateTime.now().subtract(const Duration(days: 1)),
        ),
      );

      emit(NumberCheckerInitial(report: report));
    } catch (_) {
    }
  }

  void emitInitial() {
    emit(NumberCheckerInitial());
  }

  Future<void> getReport({required String startDate}) async {
    emit(NumberCheckerLoading(person: state.person, report: state.report, step: state.step));

    try {
      final report = await getCarByPlateUseCase.getReport(startDate: startDate);
      emit(NumberCheckerInitial(person: state.person, report: report, step: state.step));
    } catch (e) {
    }
  }

  void reset() {
    emit(const NumberCheckerInitial());
  }
}
