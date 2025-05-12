import 'package:kpp_app/feature/domain/entities/person.dart';
import 'package:kpp_app/feature/data/repositories/person_repository_impl.dart';

class CheckNumberUseCase {
  final PersonRepositoryImpl repository;

  CheckNumberUseCase(this.repository);

  Future<Person?> call(String number) async {
    return await repository.getPersonByNumber(number);
  }
}
