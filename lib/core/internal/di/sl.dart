import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kpp_app/core/internal/di/sl.config.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../api_constants.dart';


final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
void configureDependencies() => $initGetIt(getIt);
const int successCode = 204;

Completer<bool>? setupCompleter;
// final StreamController<RefreshTokenResult> _refreshTokenStreamController =
// StreamController<RefreshTokenResult>.broadcast();

Completer<bool>? refreshCompleter;

@module
abstract class RegisterModule {

  @lazySingleton


  @lazySingleton
  Dio get dio {
    setupCompleter = Completer<bool>();


    Dio dio = Dio(
      BaseOptions(
        baseUrl: netGatewayServerUrl,
        // baseUrl: localGatewayServerUrl,
        connectTimeout: const Duration(milliseconds: 15000),

      ),
    );

    if (!kReleaseMode) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ));
    }
    return dio;
  }

}

Future<bool?> setupComplete() async {
  return setupCompleter?.future;
}
