import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/report_entitie.dart';
import '../../domain/usecases/check_number_usecase.dart';
import 'historia_state.dart';

@injectable
class HistoriaCubit extends Cubit<HistoriaState> {
  final GetCarByPlateUseCase getCarByPlateUseCase;

  HistoriaCubit(this.getCarByPlateUseCase) : super(HistoriaInitial());

  Future<void> getReport({required String startDate}) async {
    emit(HistoriaLoading());

    try {
      final report = await getCarByPlateUseCase.getReport(startDate: startDate);

      if (report != null) {
        final sortedReportItems = List<ReportItemEntity>.from(report.report);
        final dateFormat = DateFormat('HH:mm:ss dd.MM.yyyy');

        sortedReportItems.sort((a, b) {
          DateTime dateA;
          DateTime dateB;

          try {
            dateA = dateFormat.parse(a.date ?? '');
          } catch (_) {
            dateA = DateTime.fromMillisecondsSinceEpoch(0);
          }

          try {
            dateB = dateFormat.parse(b.date ?? '');
          } catch (_) {
            dateB = DateTime.fromMillisecondsSinceEpoch(0);
          }

          return dateB.compareTo(dateA);
        });

        final sortedReport = ReportEntity(report: sortedReportItems);

        emit(HistoriaLoaded(sortedReport));
      } else {
        emit(HistoriaError('Пустой отчет'));
      }
    } catch (e) {
      emit(HistoriaError(e.toString()));
    }
  }
}
