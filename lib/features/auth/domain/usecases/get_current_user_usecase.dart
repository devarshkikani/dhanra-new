import 'package:dhanra_new/core/error/failures.dart';
import 'package:dhanra_new/core/usecases/usecase.dart';
import 'package:dhanra_new/features/auth/domain/entities/user_entity.dart';
import 'package:dhanra_new/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetCurrentUserUseCase
    implements UseCase<(Failure?, UserEntity?), NoParams> {
  GetCurrentUserUseCase(this._repository);

  final IAuthRepository _repository;

  @override
  Future<(Failure?, UserEntity?)> call(NoParams params) {
    return _repository.getCurrentUser();
  }
}
