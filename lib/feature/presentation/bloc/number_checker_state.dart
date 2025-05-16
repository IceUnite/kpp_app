import 'package:equatable/equatable.dart';

import '../../domain/entities/person.dart';

enum CheckerStep { initial, input, result, confirmed }

abstract class NumberCheckerState extends Equatable {
  final Person? person;
  final CheckerStep step;

  const NumberCheckerState({this.person, required this.step});

  @override
  List<Object?> get props => [person, step];
}

class NumberCheckerInitial extends NumberCheckerState {
  const NumberCheckerInitial({super.person, super.step = CheckerStep.initial});
}

class NumberCheckerLoading extends NumberCheckerState {
  const NumberCheckerLoading({super.person, required super.step});
}

class NumberCheckerError extends NumberCheckerState {
  final String message;

  const NumberCheckerError({Person? person, required CheckerStep step, required this.message})
    : super(person: person, step: step);

  @override
  List<Object?> get props => [person, step, message];
}

class NumberExists extends NumberCheckerState {
  const NumberExists(Person person, {required super.step}) : super(person: person);

  @override
  List<Object?> get props => [person, step];
}

class NumberNotExists extends NumberCheckerState {
  const NumberNotExists({super.person, required super.step});
}

class AdmitCarLoading extends NumberCheckerState {
  const AdmitCarLoading({super.person, required super.step});
}

class ExitCarLoading extends NumberCheckerState {
  const ExitCarLoading({super.person, required super.step});
}
