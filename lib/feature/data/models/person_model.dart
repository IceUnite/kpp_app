import 'dart:convert';
import '../../domain/entities/person.dart';

class PersonModel extends Person {
  PersonModel({
    int? id,
    String? surname,
    String? name,
    String? lastname,
    String? number,
    String? status,
    DateTime? timeIn,
    DateTime? timeOut,
  }) : super(
    id: id,
    surname: surname,
    name: name,
    lastname: lastname,
    number: number,
    status: status,
    timeIn: timeIn,
    timeOut: timeOut,
  );

  factory PersonModel.fromMap(Map<String, dynamic> map) {
    return PersonModel(
      id: map['id'],
      surname: map['last_name'],
      name: map['first_name'],
      lastname: map['middle_name'],
      number: map['plate_number'],
      status: map['status'],
      timeIn: map['time_in'] != null ? DateTime.parse(map['time_in']) : null,
      timeOut: map['time_out'] != null ? DateTime.parse(map['time_out']) : null,
    );
  }

  // Метод для преобразования из JSON (строка или карта)
  factory PersonModel.fromJson(String json) {
    final map = jsonDecode(json);
    return PersonModel.fromMap(map);
  }

  // Метод для преобразования объекта в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'last_name': surname,
      'first_name': name,
      'middle_name': lastname,
      'plate_number': number,
      'status': status,
      'time_in': timeIn?.toIso8601String(),
      'time_out': timeOut?.toIso8601String(),
    };
  }

  // Преобразование модели в сущность
  Person toEntity() {
    return Person(
      id: id ?? 0, // Используем дефолтные значения, если они null
      surname: surname ?? '',
      name: name ?? '',
      lastname: lastname ?? '',
      number: number ?? '',
      status: status ?? '',
      timeIn: timeIn,
      timeOut: timeOut,
    );
  }
}
