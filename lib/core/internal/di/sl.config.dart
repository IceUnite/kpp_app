// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../../feature/data/datasource/remote_datasource.dart' as _i907;
import '../../../feature/data/repositories/%D1%81ar_repository_impl.dart'
    as _i237;
import '../../../feature/domain/repositories/car_repository.dart' as _i206;
import '../../../feature/domain/usecases/check_number_usecase.dart' as _i802;
import '../../../feature/presentation/bloc/number_checker_cubit.dart' as _i864;
import 'sl.dart' as _i581;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
  gh.factory<_i907.CarRemoteDataSource>(
    () => _i907.CarRemoteDataSource(gh<_i361.Dio>()),
  );
  gh.lazySingleton<_i206.CarRepository>(
    () => _i237.CarRepositoryImpl(gh<_i907.CarRemoteDataSource>()),
  );
  gh.factory<_i802.GetCarByPlateUseCase>(
    () => _i802.GetCarByPlateUseCase(gh<_i206.CarRepository>()),
  );
  gh.factory<_i864.NumberCheckerCubit>(
    () => _i864.NumberCheckerCubit(gh<_i802.GetCarByPlateUseCase>()),
  );
  return getIt;
}

class _$RegisterModule extends _i581.RegisterModule {}
