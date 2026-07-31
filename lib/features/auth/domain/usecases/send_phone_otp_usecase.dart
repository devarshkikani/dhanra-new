import 'package:dhanra_new/core/error/failures.dart';
import 'package:dhanra_new/core/usecases/usecase.dart';
import 'package:dhanra_new/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SendPhoneOtpUseCase
    implements UseCase<(Failure?, String?), SendPhoneOtpParams> {
  SendPhoneOtpUseCase(this._repository);

  final IAuthRepository _repository;

  @override
  Future<(Failure?, String?)> call(SendPhoneOtpParams params) {
    return _repository.sendPhoneOtp(phoneNumber: params.phoneNumber);
  }
}

class SendPhoneOtpParams extends Equatable {
  const SendPhoneOtpParams({required this.phoneNumber});

  final String phoneNumber;

  @override
  List<Object?> get props => [phoneNumber];
}
