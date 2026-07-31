import 'package:dhanra_new/core/error/failures.dart';
import 'package:dhanra_new/features/auth/domain/entities/user_entity.dart';

abstract class IAuthRepository {
  Future<(Failure?, UserEntity?)> getCurrentUser();

  Future<(Failure?, UserEntity?)> signInWithEmail({
    required String email,
    required String password,
  });

  Future<(Failure?, UserEntity?)> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  });

  Future<(Failure?, String?)> sendPhoneOtp({
    required String phoneNumber,
  });

  Future<(Failure?, UserEntity?)> verifyPhoneOtp({
    required String verificationId,
    required String smsCode,
    String? displayName,
  });

  Future<(Failure?, void)> resetPassword({
    required String email,
  });

  Future<(Failure?, void)> signOut();
}
