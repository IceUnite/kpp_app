import '../../data/models/person_model.dart';
import '../entities/report_entitie.dart';

abstract class CarRepository {
  Future<PersonModel> getCarByPlate(String plateNumber);

  Future<String> admitCar(int carId);

  Future<String> exitCar(int carId);

  Future<ReportEntity?> getReport({required String startDate});

  Future<void> deleteCarByPlate({required String plateNumber, required String password});

  Future<String> addCar({
    required String lastName,
    required String firstName,
    required String middleName,
    required String plateNumber,
    required String password,
    String? brand,
    String? passportData,
    String? organization,
  });
}
