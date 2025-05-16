import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../models/person_model.dart';
import '../models/report_model.dart';

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

  Future<ReportModel?> getReport({required String startDate}) async {
    try {
      final response = await _dio.get('/generate_report', queryParameters: {'start_date': startDate});

      if (response.statusCode == 200) {
        final data = response.data;

        if (data == null || data is! Map<String, dynamic>) {
          return null;
        }

        final reportData = data['report'];

        if (reportData == null) return null;

        if (reportData is Map<String, dynamic>) {
          return ReportModel.fromJson({
            'report': [reportData],
          });
        }

        if (reportData is List) {
          return ReportModel.fromJson({'report': reportData});
        }

        throw Exception('Unexpected report data format: ${reportData.runtimeType}');
      } else {
        throw Exception('Failed to fetch report, status code: ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<void> deleteCarByPlate({
    required String plateNumber,
    required String password,
  }) async {
    try {
      final response = await _dio.delete(
        '/delete_car_by_plate/$plateNumber',
        queryParameters: {'password': password},
      );

      if (response.statusCode == 200) {
        // Можно вернуть response.data или просто void, если ответ не важен
        return;
      } else {
        throw Exception('Failed to delete car, status code: ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
  Future<String> addCar({
    required String lastName,
    required String firstName,
    required String middleName,
    required String plateNumber,
    required String password,
    String? brand,
    String? passportData,
    String? organization,
  }) async {
    try {
      final response = await _dio.post(
        '/add_car',
        queryParameters: {
          'last_name': lastName,
          'first_name': firstName,
          'middle_name': middleName,
          'plate_number': plateNumber,
          'password': password,
          if (brand != null) 'brand': brand,
          if (passportData != null) 'passport_data': passportData,
          if (organization != null) 'organization': organization,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final message = data['message'] as String? ?? 'Car added successfully';
        final carData = data['car'] as Map<String, dynamic>?;

        if (carData == null) {
          throw Exception('No car data in response');
        }

        return message;
      } else {
        throw Exception('Failed to add car, status code: ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

}
