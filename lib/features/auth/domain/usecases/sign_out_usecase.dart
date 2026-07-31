import 'package:dhanra_new/core/error/failures.dart';
import 'package:dhanra_new/core/usecases/usecase.dart';
import 'package:dhanra_new/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SignOutUseCase implements UseCase<(Failure?, void), NoParams> {
  SignOutUseCase(this._repository);

  final IAuthRepository _repository;

  @override
  Future<(Failure?, void)> call(NoParams params) {
    return _repository.signOut();
  }
}
