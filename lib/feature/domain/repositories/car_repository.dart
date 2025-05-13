
import '../../data/models/person_model.dart';

abstract class CarRepository {
  Future<PersonModel> getCarByPlate(String plateNumber);
}