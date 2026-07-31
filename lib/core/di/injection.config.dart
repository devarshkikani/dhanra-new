// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/sample_feature/data/datasources/post_local_datasource.dart'
    as _i468;
import '../../features/sample_feature/data/datasources/post_remote_datasource.dart'
    as _i887;
import '../../features/sample_feature/data/repositories/post_repository_impl.dart'
    as _i328;
import '../../features/sample_feature/domain/repositories/post_repository.dart'
    as _i721;
import '../../features/sample_feature/domain/usecases/get_posts_usecase.dart'
    as _i803;
import '../../features/sample_feature/presentation/bloc/post_bloc.dart'
    as _i601;
import '../network/dio_client.dart' as _i667;
import '../network/network_info.dart' as _i932;
import 'injection.dart' as _i464;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final externalModule = _$ExternalModule();
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => externalModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i895.Connectivity>(() => externalModule.connectivity);
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i887.PostRemoteDataSource>(
        () => _i887.PostRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i468.PostLocalDataSource>(
        () => _i468.PostLocalDataSourceImpl(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i932.NetworkInfo>(
        () => _i932.NetworkInfoImpl(gh<_i895.Connectivity>()));
    gh.lazySingleton<_i721.PostRepository>(() => _i328.PostRepositoryImpl(
          remoteDataSource: gh<_i887.PostRemoteDataSource>(),
          localDataSource: gh<_i468.PostLocalDataSource>(),
          networkInfo: gh<_i932.NetworkInfo>(),
        ));
    gh.lazySingleton<_i803.GetPostsUseCase>(
        () => _i803.GetPostsUseCase(gh<_i721.PostRepository>()));
    gh.factory<_i601.PostBloc>(
        () => _i601.PostBloc(gh<_i803.GetPostsUseCase>()));
    return this;
  }
}

class _$ExternalModule extends _i464.ExternalModule {}

class _$RegisterModule extends _i667.RegisterModule {}
