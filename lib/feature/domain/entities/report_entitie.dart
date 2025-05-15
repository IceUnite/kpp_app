import 'package:equatable/equatable.dart';

class ReportEntity extends Equatable {
  final List<ReportItemEntity> report;

  const ReportEntity({required this.report});

  @override
  List<Object?> get props => [report];
}

class ReportItemEntity extends Equatable {
  final int? carId;
  final String? plateNumber;
  final String? fio;
  final String? status;
  final String? date;
  final String? currentStatus;
  final String? timeIn;
  final String? timeOut;

  const ReportItemEntity({
    required this.carId,
    required this.plateNumber,
    required this.fio,
    required this.status,
    required this.date,
    required this.currentStatus,
    required this.timeIn,
    required this.timeOut,
  });

  @override
  List<Object?> get props => [
    carId,
    plateNumber,
    fio,
    status,
    date,
    currentStatus,
    timeIn,
    timeOut,
  ];
}
