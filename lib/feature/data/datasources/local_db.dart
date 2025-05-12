import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class LocalDb {
  static Database? _database;

  Future<void> printAllPersons() async {
    final db = await LocalDb().database;
    final persons = await db.query('persons');

    print('=== Содержимое таблицы persons ===');
    for (var row in persons) {
      print(row);
    }
    print('=== Конец таблицы ===');
  }

  Future<void> deleteOldDb() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'database.db');

    final file = File(path);
    if (await file.exists()) {
      await file.delete();
      print('❌ Старая база данных удалена.');
    }
  }

  // Метод для получения или создания базы данных
  Future<Database> get database async {
    if (_database != null) return _database!;

    // Если база данных еще не существует, создаем новую
    _database = await _initDb();
    return _database!;
  }

  // Метод для инициализации базы данных
  Future<Database> _initDb() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'database.db');

    return await openDatabase(path);
  }

  // Метод для закрытия базы данных
  Future<void> close() async {
    final db = await database;
    db.close();
  }

  Future<void> printDatabaseContent() async {
    final directory = await getApplicationDocumentsDirectory();
    final dbPath = join(directory.path, 'database.db');

    final db = await openDatabase(dbPath);
    final List<Map<String, dynamic>> result = await db.query('persons');
    print('=== Содержимое таблицы persons ===');
    for (var row in result) {
      print(row); // Выводим каждую строку из таблицы
    }
    print('=== Конец таблицы ===');
  }

  Future<void> checkDatabaseTables() async {
    final db = await database;

    // Пример проверки существования таблицы
    final result = await db.rawQuery('SELECT name FROM sqlite_master WHERE type="table"');
    print('Существующие таблицы:');
    for (var table in result) {
      print(table);
    }
  }
}
