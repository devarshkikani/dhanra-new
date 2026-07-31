import 'package:dhanra_new/core/error/failures.dart';
import 'package:dhanra_new/core/usecases/usecase.dart';
import 'package:dhanra_new/features/auth/domain/entities/user_entity.dart';
import 'package:dhanra_new/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SignInWithEmailUseCase
    implements UseCase<(Failure?, UserEntity?), SignInWithEmailParams> {
  SignInWithEmailUseCase(this._repository);

  final IAuthRepository _repository;

  @override
  Future<(Failure?, UserEntity?)> call(SignInWithEmailParams params) {
    return _repository.signInWithEmail(
      email: params.email,
      password: params.password,
    );
  }
}

class SignInWithEmailParams extends Equatable {
  const SignInWithEmailParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
