import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

Future<void> copyDatabaseFromAssets() async {
  // Получаем директорию для хранения базы данных
  final directory = await getApplicationDocumentsDirectory();
  final path = join(directory.path, 'database.db');

  // Проверяем, существует ли уже база данных в локальном хранилище
  final fileExists = await File(path).exists();
  if (fileExists) {
    print('База данных уже существует! Путь: $path');
    return;
  }

  // Получаем данные из ассетов
  final ByteData data = await rootBundle.load('assets/datasource/database.db');
  final List<int> bytes = data.buffer.asUint8List();

  // Копируем данные в локальный файл
  final File file = File(path);
  await file.writeAsBytes(bytes);

  print('База данных скопирована в: $path');
}


// Метод для проверки содержимого базы данных после копирования
