import 'package:dhanra_new/core/error/failures.dart';
import 'package:dhanra_new/core/usecases/usecase.dart';
import 'package:dhanra_new/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ResetPasswordUseCase
    implements UseCase<(Failure?, void), ResetPasswordParams> {
  ResetPasswordUseCase(this._repository);

  final IAuthRepository _repository;

  @override
  Future<(Failure?, void)> call(ResetPasswordParams params) {
    return _repository.resetPassword(email: params.email);
  }
}

class ResetPasswordParams extends Equatable {
  const ResetPasswordParams({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}
