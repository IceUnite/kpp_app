import '../datasources/local_db.dart';
import '../../domain/repositories/person_repository.dart';

class PersonRepositoryImpl implements PersonRepository {
  @override
  Future<bool> checkNumberExists(String number) async {
    final db = await LocalDb.database;
    final result = await db.query(
      'table_name',
      where: 'number = ?',
      whereArgs: [number],
    );
    return result.isNotEmpty;
  }
}
