import 'package:dhanra_new/core/error/failures.dart';
import 'package:dhanra_new/core/usecases/usecase.dart';
import 'package:dhanra_new/features/auth/domain/entities/user_entity.dart';
import 'package:dhanra_new/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SignUpWithEmailUseCase
    implements UseCase<(Failure?, UserEntity?), SignUpWithEmailParams> {
  SignUpWithEmailUseCase(this._repository);

  final IAuthRepository _repository;

  @override
  Future<(Failure?, UserEntity?)> call(SignUpWithEmailParams params) {
    return _repository.signUpWithEmail(
      email: params.email,
      password: params.password,
      displayName: params.displayName,
    );
  }
}

class SignUpWithEmailParams extends Equatable {
  const SignUpWithEmailParams({
    required this.email,
    required this.password,
    required this.displayName,
  });

  final String email;
  final String password;
  final String displayName;

  @override
  List<Object?> get props => [email, password, displayName];
}
