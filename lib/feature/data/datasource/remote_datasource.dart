import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../models/person_model.dart';

@injectable
class CarRemoteDataSource {
  final Dio _dio;

  CarRemoteDataSource(this._dio);

  // Метод для получения данных о машине по номеру
  Future<PersonModel> getCarByPlate(String plateNumber) async {
    try {
      final response = await _dio.get('/car/$plateNumber');

      if (response.statusCode == 200) {
        // Преобразуем JSON в модель PersonModel
        return PersonModel.fromJson(jsonEncode(response.data));
      } else {
        throw Exception('Failed to load car data');
      }
    } on DioError catch (e) {
      // Обработка ошибок Dio
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      // Общая ошибка
      throw Exception('Unexpected error: $e');
    }
  }

  Future<String> admitCar(int carId) async {
    try {
      final response = await _dio.post('/admit_car/$carId');

      if (response.statusCode == 200) {
        // Предполагается, что API возвращает строку в JSON
        return response.data.toString();
      } else {
        throw Exception('Failed to admit car');
      }
    } on DioError catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
  Future<String> exitCar(int carId) async {
    try {
      final response = await _dio.post('/exit_car/$carId');

      if (response.statusCode == 200) {
        return response.data.toString();
      } else {
        throw Exception('Failed to exit car');
      }
    } on DioError catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
