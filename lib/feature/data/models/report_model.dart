import 'package:intl/intl.dart';
import '../../domain/entities/report_entitie.dart';

class ReportModel {
  final List<ReportItemModel> report;

  const ReportModel({required this.report});

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['report'];
    final list = (rawList is List)
        ? rawList.map((e) => ReportItemModel.fromJson(e)).toList()
        : <ReportItemModel>[];
    return ReportModel(report: list);
  }

  Map<String, dynamic> toJson() {
    return {
      'report': report.map((e) => e.toJson()).toList(),
    };
  }

  ReportEntity toEntity() {
    return ReportEntity(
      report: report.map((item) => item.toEntity()).toList(),
    );
  }
}

class ReportItemModel {
  static final DateFormat _dateFormat = DateFormat("HH:mm:ss dd.MM.yyyy");

  final int? carId;
  final String? plateNumber;
  final String? fio;
  final String? status;
  final DateTime? date;
  final String? currentStatus;
  final DateTime? timeIn;
  final DateTime? timeOut;

  const ReportItemModel({
    required this.carId,
    required this.plateNumber,
    required this.fio,
    required this.status,
    required this.date,
    required this.currentStatus,
    required this.timeIn,
    required this.timeOut,
  });

  factory ReportItemModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? dateStr) {
      if (dateStr == null) return null;
      try {
        return _dateFormat.parse(dateStr);
      } catch (_) {
        return null;
      }
    }

    return ReportItemModel(
      carId: json['car_id'] != null ? json['car_id'] as int : null,
      plateNumber: json['plate_number'] as String?,
      fio: json['fio'] as String?,
      status: json['status'] as String?,
      date: parseDate(json['date'] as String?),
      currentStatus: json['current_status'] as String?,
      timeIn: parseDate(json['time_in'] as String?),
      timeOut: parseDate(json['time_out'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    String? formatDate(DateTime? date) {
      return date != null ? _dateFormat.format(date) : null;
    }

    return {
      'car_id': carId,
      'plate_number': plateNumber,
      'fio': fio,
      'status': status,
      'date': formatDate(date),
      'current_status': currentStatus,
      'time_in': formatDate(timeIn),
      'time_out': formatDate(timeOut),
    };
  }

  /// Конвертация в доменную сущность с преобразованием DateTime в String
  ReportItemEntity toEntity() {
    String? formatDate(DateTime? date) =>
        date != null ? _dateFormat.format(date) : null;

    return ReportItemEntity(
      carId: carId,
      plateNumber: plateNumber,
      fio: fio,
      status: status,
      date: formatDate(date),
      currentStatus: currentStatus,
      timeIn: formatDate(timeIn),
      timeOut: formatDate(timeOut),
    );
  }
}
