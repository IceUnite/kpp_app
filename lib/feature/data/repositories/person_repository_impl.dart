import 'package:kpp_app/feature/domain/entities/person.dart';


import '../datasources/local_db.dart';

class PersonRepositoryImpl {
  final LocalDb db;

  PersonRepositoryImpl(this.db);

  Future<Person?> getPersonByNumber(String number) async {
    final database = await db.database;

    // ЛОГИ ВСЕХ НОМЕРОВ
    final all = await database.query('persons');
    for (final row in all) {
      print('Номер в БД: ${row['number']}');
    }

    final List<Map<String, dynamic>> result = await database.query(
      'persons',
      where: 'number = ?',
      whereArgs: [number],
    );

    if (result.isNotEmpty) {
      final person = result.first;
      return Person(
        id: person['id'],
        surname: person['surname'],
        name: person['name'],
        lastname: person['lastname'],
        number: person['number'],
      );
    }

    print('Номер не найден: $number');
    return null;
  }

}
