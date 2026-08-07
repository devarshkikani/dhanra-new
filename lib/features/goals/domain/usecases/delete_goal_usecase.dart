import 'package:dhanra_new/features/goals/domain/repositories/goal_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeleteGoalUseCase {
  const DeleteGoalUseCase(this._repository);

  final GoalRepository _repository;

  Future<void> call(String goalId) async {
    return _repository.deleteGoal(goalId);
  }
}
