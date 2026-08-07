import 'package:dhanra_new/features/goals/domain/entities/goal_entity.dart';
import 'package:dhanra_new/features/goals/domain/repositories/goal_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UpdateGoalUseCase {
  const UpdateGoalUseCase(this._repository);

  final GoalRepository _repository;

  Future<GoalEntity> call(GoalEntity goal) async {
    return _repository.updateGoal(goal);
  }
}
