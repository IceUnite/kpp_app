import 'package:injectable/injectable.dart';

import '../entities/person.dart';
import '../entities/report_entitie.dart';
import '../repositories/car_repository.dart';

@injectable
class GetCarByPlateUseCase {
  final CarRepository _carRepository;

  GetCarByPlateUseCase(this._carRepository);

  Future<String> admitCar(int carId) async {
    try {
      return await _carRepository.admitCar(carId);
    } catch (e) {
      throw Exception('Error while admitting car: $e');
    }
  }

  Future<Person> execute(String plateNumber) async {
    try {
      final personModel = await _carRepository.getCarByPlate(plateNumber);

      return personModel.toEntity();
    } catch (e) {
      throw Exception('Error while getting car data: $e');
    }
  }

  Future<String> exitCar(int carId) async {
    try {
      return await _carRepository.exitCar(carId);
    } catch (e) {
      throw Exception('Error while exiting car: $e');
    }
  }

  @override
  Future<ReportEntity?> getReport({
    required String startDate,
  }) async {
    final reportEntity = await _carRepository.getReport(startDate: startDate);
    return reportEntity;
  }

  Future<void> deleteCarByPlate({
    required String plateNumber,
    required String password,
  }) async {
    try {
      await _carRepository.deleteCarByPlate(plateNumber: plateNumber, password: password);
    } catch (e) {
      throw Exception('Error while deleting car: $e');
    }
  }

  Future<String> addCar({
    required String lastName,
    required String firstName,
    required String middleName,
    required String plateNumber,
    required String password,
    String? brand,
    String? passportData,
    String? organization,
  }) async {
    try {
      return await _carRepository.addCar(
        lastName: lastName,
        firstName: firstName,
        middleName: middleName,
        plateNumber: plateNumber,
        password: password,
        brand: brand,
        passportData: passportData,
        organization: organization,
      );
    } catch (e) {
      throw Exception('Error while adding car: $e');
    }
  }
}
