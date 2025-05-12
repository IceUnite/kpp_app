import '../repositories/person_repository.dart';

class CheckNumberUseCase {
  final PersonRepository repository;

  CheckNumberUseCase(this.repository);

  Future<bool> call(String number) {
    return repository.checkNumberExists(number);
  }
}
