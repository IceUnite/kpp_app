import 'package:injectable/injectable.dart';

import '../entities/person.dart';
import '../repositories/car_repository.dart';

@injectable
class GetCarByPlateUseCase {
  final CarRepository _carRepository;

  GetCarByPlateUseCase(this._carRepository);

  Future<Person> execute(String plateNumber) async {
    try {
      final personModel = await _carRepository.getCarByPlate(plateNumber);

      return personModel.toEntity();
    } catch (e) {
      throw Exception('Error while getting car data: $e');
    }
  }
}
