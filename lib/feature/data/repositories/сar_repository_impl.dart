import 'package:injectable/injectable.dart';
import '../../domain/entities/report_entitie.dart';
import '../../domain/repositories/car_repository.dart';
import '../datasource/remote_datasource.dart';
import '../models/person_model.dart';

@LazySingleton(as: CarRepository)
class CarRepositoryImpl implements CarRepository {
  final CarRemoteDataSource _carRemoteDataSource;

  CarRepositoryImpl(this._carRemoteDataSource);

  @override
  Future<PersonModel> getCarByPlate(String plateNumber) async {
    return await _carRemoteDataSource.getCarByPlate(plateNumber);
  }

  @override
  Future<String> admitCar(int carId) async {
    return await _carRemoteDataSource.admitCar(carId);
  }

  @override
  Future<String> exitCar(int carId) async {
    return await _carRemoteDataSource.exitCar(carId);
  }

  @override
  Future<ReportEntity?> getReport({required String startDate}) async {
    final model = await _carRemoteDataSource.getReport(startDate: startDate);
    return model?.toEntity();
  }

  @override
  Future<void> deleteCarByPlate({required String plateNumber, required String password}) async {
    await _carRemoteDataSource.deleteCarByPlate(plateNumber: plateNumber, password: password);
  }

  @override
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
    return await _carRemoteDataSource.addCar(
      lastName: lastName,
      firstName: firstName,
      middleName: middleName,
      plateNumber: plateNumber,
      password: password,
      brand: brand,
      passportData: passportData,
      organization: organization,
    );
  }
}
