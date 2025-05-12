part of 'number_checker_cubit.dart';

abstract class NumberCheckerState extends Equatable {
  const NumberCheckerState();

  @override
  List<Object> get props => [];
}

class NumberCheckerInitial extends NumberCheckerState {}

class NumberCheckerLoading extends NumberCheckerState {}

class NumberExists extends NumberCheckerState {
  final Person person;

  const NumberExists(this.person);

  @override
  List<Object> get props => [person];
}

class NumberNotExists extends NumberCheckerState {}
