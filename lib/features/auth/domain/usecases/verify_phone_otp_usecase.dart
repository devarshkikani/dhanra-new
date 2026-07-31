import 'package:dhanra_new/core/error/failures.dart';
import 'package:dhanra_new/core/usecases/usecase.dart';
import 'package:dhanra_new/features/auth/domain/entities/user_entity.dart';
import 'package:dhanra_new/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class VerifyPhoneOtpUseCase
    implements UseCase<(Failure?, UserEntity?), VerifyPhoneOtpParams> {
  VerifyPhoneOtpUseCase(this._repository);

  final IAuthRepository _repository;

  @override
  Future<(Failure?, UserEntity?)> call(VerifyPhoneOtpParams params) {
    return _repository.verifyPhoneOtp(
      verificationId: params.verificationId,
      smsCode: params.smsCode,
      displayName: params.displayName,
    );
  }
}

class VerifyPhoneOtpParams extends Equatable {
  const VerifyPhoneOtpParams({
    required this.verificationId,
    required this.smsCode,
    this.displayName,
  });

  final String verificationId;
  final String smsCode;
  final String? displayName;

  @override
  List<Object?> get props => [verificationId, smsCode, displayName];
}
