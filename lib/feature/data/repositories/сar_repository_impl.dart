import 'package:injectable/injectable.dart';
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
}
