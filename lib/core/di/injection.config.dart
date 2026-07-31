// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/auth/data/datasources/auth_local_data_source.dart'
    as _i852;
import '../../features/auth/data/datasources/auth_remote_data_source.dart'
    as _i107;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/i_auth_repository.dart'
    as _i589;
import '../../features/auth/domain/usecases/get_current_user_usecase.dart'
    as _i17;
import '../../features/auth/domain/usecases/reset_password_usecase.dart'
    as _i474;
import '../../features/auth/domain/usecases/send_phone_otp_usecase.dart'
    as _i713;
import '../../features/auth/domain/usecases/sign_in_with_email_usecase.dart'
    as _i744;
import '../../features/auth/domain/usecases/sign_out_usecase.dart' as _i915;
import '../../features/auth/domain/usecases/sign_up_with_email_usecase.dart'
    as _i254;
import '../../features/auth/domain/usecases/verify_phone_otp_usecase.dart'
    as _i1042;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
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
    gh.lazySingleton<_i59.FirebaseAuth>(() => externalModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => externalModule.firestore);
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i887.PostRemoteDataSource>(
        () => _i887.PostRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i107.AuthRemoteDataSource>(
        () => _i107.AuthRemoteDataSourceImpl(
              gh<_i59.FirebaseAuth>(),
              gh<_i974.FirebaseFirestore>(),
            ));
    gh.lazySingleton<_i852.AuthLocalDataSource>(
        () => _i852.AuthLocalDataSourceImpl(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i468.PostLocalDataSource>(
        () => _i468.PostLocalDataSourceImpl(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i932.NetworkInfo>(
        () => _i932.NetworkInfoImpl(gh<_i895.Connectivity>()));
    gh.lazySingleton<_i589.IAuthRepository>(() => _i153.AuthRepositoryImpl(
          gh<_i107.AuthRemoteDataSource>(),
          gh<_i852.AuthLocalDataSource>(),
        ));
    gh.lazySingleton<_i721.PostRepository>(() => _i328.PostRepositoryImpl(
          remoteDataSource: gh<_i887.PostRemoteDataSource>(),
          localDataSource: gh<_i468.PostLocalDataSource>(),
          networkInfo: gh<_i932.NetworkInfo>(),
        ));
    gh.lazySingleton<_i17.GetCurrentUserUseCase>(
        () => _i17.GetCurrentUserUseCase(gh<_i589.IAuthRepository>()));
    gh.lazySingleton<_i474.ResetPasswordUseCase>(
        () => _i474.ResetPasswordUseCase(gh<_i589.IAuthRepository>()));
    gh.lazySingleton<_i713.SendPhoneOtpUseCase>(
        () => _i713.SendPhoneOtpUseCase(gh<_i589.IAuthRepository>()));
    gh.lazySingleton<_i744.SignInWithEmailUseCase>(
        () => _i744.SignInWithEmailUseCase(gh<_i589.IAuthRepository>()));
    gh.lazySingleton<_i915.SignOutUseCase>(
        () => _i915.SignOutUseCase(gh<_i589.IAuthRepository>()));
    gh.lazySingleton<_i254.SignUpWithEmailUseCase>(
        () => _i254.SignUpWithEmailUseCase(gh<_i589.IAuthRepository>()));
    gh.lazySingleton<_i1042.VerifyPhoneOtpUseCase>(
        () => _i1042.VerifyPhoneOtpUseCase(gh<_i589.IAuthRepository>()));
    gh.factory<_i797.AuthBloc>(() => _i797.AuthBloc(
          getCurrentUserUseCase: gh<_i17.GetCurrentUserUseCase>(),
          signInWithEmailUseCase: gh<_i744.SignInWithEmailUseCase>(),
          signUpWithEmailUseCase: gh<_i254.SignUpWithEmailUseCase>(),
          sendPhoneOtpUseCase: gh<_i713.SendPhoneOtpUseCase>(),
          verifyPhoneOtpUseCase: gh<_i1042.VerifyPhoneOtpUseCase>(),
          resetPasswordUseCase: gh<_i474.ResetPasswordUseCase>(),
          signOutUseCase: gh<_i915.SignOutUseCase>(),
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
