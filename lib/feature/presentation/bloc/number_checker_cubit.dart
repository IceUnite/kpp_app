import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/check_number_usecase.dart';
import '../../domain/entities/person.dart';

part 'number_checker_state.dart';

class NumberCheckerCubit extends Cubit<NumberCheckerState> {
  final CheckNumberUseCase checkNumberUseCase;

  NumberCheckerCubit(this.checkNumberUseCase) : super(NumberCheckerInitial());

  Future<void> checkNumber(String number) async {
    emit(NumberCheckerLoading());

    final person = await checkNumberUseCase(number);

    if (person != null) {
      emit(NumberExists(person));
    } else {
      emit(NumberNotExists());
    }
  }

  void reset() {
    emit(NumberCheckerInitial());
  }
}
