import '../../data/models/person_model.dart';
import '../../data/models/report_model.dart';
import '../entities/report_entitie.dart';

abstract class CarRepository {
  Future<PersonModel> getCarByPlate(String plateNumber);

  Future<String> admitCar(int carId);

  Future<String> exitCar(int carId);

  Future<ReportEntity?> getReport({required String startDate});

}
