
import '../../domain/entities/report_entitie.dart';

abstract class HistoriaState {}

class HistoriaInitial extends HistoriaState {}

class HistoriaLoading extends HistoriaState {}

class HistoriaLoaded extends HistoriaState {
  final ReportEntity report;

  HistoriaLoaded(this.report);
}

class HistoriaError extends HistoriaState {
  final String message;

  HistoriaError(this.message);
}
