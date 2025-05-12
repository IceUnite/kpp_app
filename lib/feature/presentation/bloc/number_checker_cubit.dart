
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/check_number_usecase.dart';

part 'number_checker_state.dart';

class NumberCheckerCubit extends Cubit<NumberCheckerState> {
  final CheckNumberUseCase checkNumberUseCase;

  NumberCheckerCubit(this.checkNumberUseCase) : super(NumberCheckerInitial());

  Future<void> checkNumber(String number) async {
    emit(NumberCheckerLoading());

    final exists = await checkNumberUseCase(number);

    if (exists) {
      emit(NumberExists());
    } else {
      emit(NumberNotExists());
    }
  }

  void reset() {
    emit(NumberCheckerInitial());
  }
}
