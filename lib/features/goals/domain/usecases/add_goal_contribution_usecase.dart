import 'package:dhanra_new/features/goals/domain/entities/goal_contribution_entity.dart';
import 'package:dhanra_new/features/goals/domain/repositories/goal_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AddGoalContributionUseCase {
  const AddGoalContributionUseCase(this._repository);

  final GoalRepository _repository;

  Future<GoalContributionEntity> call(
      GoalContributionEntity contribution) async {
    return _repository.addContribution(contribution);
  }
}
