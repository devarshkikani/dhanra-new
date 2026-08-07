import 'package:dhanra_new/features/goals/domain/entities/goal_entity.dart';
import 'package:equatable/equatable.dart';

class GoalsSummaryEntity extends Equatable {
  const GoalsSummaryEntity({
    required this.totalTarget,
    required this.totalSaved,
    required this.activeGoalsCount,
    required this.completedGoalsCount,
    required this.goals,
  });

  final double totalTarget;
  final double totalSaved;
  final int activeGoalsCount;
  final int completedGoalsCount;
  final List<GoalEntity> goals;

  double get overallPercentageSaved =>
      totalTarget > 0 ? (totalSaved / totalTarget).clamp(0.0, 1.0) : 0.0;
  double get remainingToSave =>
      (totalTarget - totalSaved).clamp(0.0, double.infinity);

  @override
  List<Object?> get props => [
        totalTarget,
        totalSaved,
        activeGoalsCount,
        completedGoalsCount,
        goals,
      ];
}
