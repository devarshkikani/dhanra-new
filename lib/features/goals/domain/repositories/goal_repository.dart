import 'package:dhanra_new/features/goals/domain/entities/goal_contribution_entity.dart';
import 'package:dhanra_new/features/goals/domain/entities/goal_entity.dart';
import 'package:dhanra_new/features/goals/domain/entities/goals_summary_entity.dart';

abstract class GoalRepository {
  Future<GoalsSummaryEntity> getGoalsSummary();
  Stream<GoalsSummaryEntity> watchGoalsSummary();
  Future<GoalEntity> createGoal(GoalEntity goal);
  Future<GoalEntity> updateGoal(GoalEntity goal);
  Future<void> deleteGoal(String goalId);
  Future<GoalContributionEntity> addContribution(
      GoalContributionEntity contribution);
}
