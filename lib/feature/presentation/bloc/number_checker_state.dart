import 'package:equatable/equatable.dart';

import '../../domain/entities/person.dart';
import '../../domain/entities/report_entitie.dart';

enum CheckerStep { initial, input, result, confirmed }

abstract class NumberCheckerState extends Equatable {
  final Person? person;
  final ReportEntity? report;
  final CheckerStep step;

  const NumberCheckerState({this.person, this.report, required this.step});

  @override
  List<Object?> get props => [person, report, step];
}

class NumberCheckerInitial extends NumberCheckerState {
  const NumberCheckerInitial({Person? person, ReportEntity? report, CheckerStep step = CheckerStep.initial})
      : super(person: person, report: report, step: step);
}

// остальные стейты тоже нужно обновить, чтобы принимать и передавать step

class NumberCheckerLoading extends NumberCheckerState {
  const NumberCheckerLoading({Person? person, ReportEntity? report, required CheckerStep step})
      : super(person: person, report: report, step: step);
}

class NumberExists extends NumberCheckerState {
  const NumberExists(Person person, {ReportEntity? report, required CheckerStep step})
      : super(person: person, report: report, step: step);

  @override
  List<Object?> get props => [person, report, step];
}

class NumberNotExists extends NumberCheckerState {
  const NumberNotExists({Person? person, ReportEntity? report, required CheckerStep step})
      : super(person: person, report: report, step: step);
}

class AdmitCarLoading extends NumberCheckerState {
  const AdmitCarLoading({Person? person, ReportEntity? report, required CheckerStep step})
      : super(person: person, report: report, step: step);
}

class ExitCarLoading extends NumberCheckerState {
  const ExitCarLoading({Person? person, ReportEntity? report, required CheckerStep step})
      : super(person: person, report: report, step: step);
}
