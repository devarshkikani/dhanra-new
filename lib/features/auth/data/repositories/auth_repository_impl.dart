import 'package:dhanra_new/core/error/exceptions.dart';
import 'package:dhanra_new/core/error/failures.dart';
import 'package:dhanra_new/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:dhanra_new/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:dhanra_new/features/auth/domain/entities/user_entity.dart';
import 'package:dhanra_new/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: IAuthRepository)
class AuthRepositoryImpl implements IAuthRepository {
  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  @override
  Future<(Failure?, UserEntity?)> getCurrentUser() async {
    try {
      final cachedUser = await _localDataSource.getCachedUser();
      if (cachedUser != null) {
        return (null, cachedUser.toEntity());
      }

      final remoteUser = await _remoteDataSource.getCurrentUser();
      if (remoteUser != null) {
        await _localDataSource.cacheUser(remoteUser);
        return (null, remoteUser.toEntity());
      }

      return (null, null);
    } catch (e) {
      return (AuthFailure(e.toString()), null);
    }
  }

  @override
  Future<(Failure?, UserEntity?)> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userModel =
          await _remoteDataSource.signInWithEmail(email, password);
      await _localDataSource.cacheUser(userModel);
      return (null, userModel.toEntity());
    } on ServerException catch (e) {
      return (AuthFailure(e.message), null);
    } catch (e) {
      return (AuthFailure(e.toString()), null);
    }
  }

  @override
  Future<(Failure?, UserEntity?)> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final userModel = await _remoteDataSource.signUpWithEmail(
        email,
        password,
        displayName,
      );
      await _localDataSource.cacheUser(userModel);
      return (null, userModel.toEntity());
    } on ServerException catch (e) {
      return (AuthFailure(e.message), null);
    } catch (e) {
      return (AuthFailure(e.toString()), null);
    }
  }

  @override
  Future<(Failure?, String?)> sendPhoneOtp({
    required String phoneNumber,
  }) async {
    try {
      final verificationId = await _remoteDataSource.sendPhoneOtp(phoneNumber);
      return (null, verificationId);
    } on ServerException catch (e) {
      return (AuthFailure(e.message), null);
    } catch (e) {
      return (AuthFailure(e.toString()), null);
    }
  }

  @override
  Future<(Failure?, UserEntity?)> verifyPhoneOtp({
    required String verificationId,
    required String smsCode,
    String? displayName,
  }) async {
    try {
      final userModel = await _remoteDataSource.verifyPhoneOtp(
        verificationId,
        smsCode,
        displayName,
      );
      await _localDataSource.cacheUser(userModel);
      return (null, userModel.toEntity());
    } on ServerException catch (e) {
      return (AuthFailure(e.message), null);
    } catch (e) {
      return (AuthFailure(e.toString()), null);
    }
  }

  @override
  Future<(Failure?, void)> resetPassword({required String email}) async {
    try {
      await _remoteDataSource.resetPassword(email);
      return (null, null);
    } on ServerException catch (e) {
      return (AuthFailure(e.message), null);
    } catch (e) {
      return (AuthFailure(e.toString()), null);
    }
  }

  @override
  Future<(Failure?, void)> signOut() async {
    try {
      await _remoteDataSource.signOut();
      await _localDataSource.clearCache();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      return (null, null);
    } catch (e) {
      return (AuthFailure(e.toString()), null);
    }
  }
}
