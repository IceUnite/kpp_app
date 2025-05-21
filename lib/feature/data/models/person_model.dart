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
    String? brand,
    String? passportData,
    String? organization,
  }) : super(
    id: id,
    surname: surname,
    name: name,
    lastname: lastname,
    number: number,
    status: status,
    timeIn: timeIn,
    timeOut: timeOut,
    brand: brand,
    passportData: passportData,
    organization: organization,
  );

  /// Создание модели из Map (например, из JSON-ответа)
  factory PersonModel.fromMap(Map<String, dynamic> map) {
    return PersonModel(
      id: map['id'],
      surname: map['last_name'],
      name: map['first_name'],
      lastname: map['middle_name'],
      number: map['plate_number'],
      status: map['status'],
      brand: map['brand'],
      passportData: map['passport_data'],
      organization: map['organization'],
      timeIn: map['time_in'] != null ? DateTime.parse(map['time_in']) : null,
      timeOut: map['time_out'] != null ? DateTime.parse(map['time_out']) : null,
    );
  }

  /// Создание модели из JSON-строки
  factory PersonModel.fromJson(String json) {
    final map = jsonDecode(json);
    return PersonModel.fromMap(map);
  }

  /// Преобразование модели в JSON (например, для отправки на сервер)
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'last_name': surname,
      'first_name': name,
      'middle_name': lastname,
      'plate_number': number,
      'status': status,
      'brand': brand,
      'passport_data': passportData,
      'organization': organization,
      'time_in': timeIn?.toIso8601String(),
      'time_out': timeOut?.toIso8601String(),
    };
  }

  /// Преобразование модели обратно в сущность (если нужно)
  @override
  Person toEntity() {
    return Person(
      id: id,
      surname: surname,
      name: name,
      lastname: lastname,
      number: number,
      status: status,
      timeIn: timeIn,
      timeOut: timeOut,
      brand: brand,
      passportData: passportData,
      organization: organization,
    );
  }
}
