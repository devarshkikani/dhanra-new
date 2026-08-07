import 'package:dhanra_new/features/goals/domain/entities/goal_contribution_entity.dart';
import 'package:dhanra_new/features/goals/domain/entities/goal_entity.dart';
import 'package:dhanra_new/features/goals/domain/entities/goals_summary_entity.dart';
import 'package:equatable/equatable.dart';

abstract class GoalsEvent extends Equatable {
  const GoalsEvent();

  @override
  List<Object?> get props => [];
}

class LoadGoalsEvent extends GoalsEvent {
  const LoadGoalsEvent();
}

class GoalsSummaryUpdatedEvent extends GoalsEvent {
  const GoalsSummaryUpdatedEvent(this.summary);

  final GoalsSummaryEntity summary;

  @override
  List<Object?> get props => [summary];
}

class CreateGoalRequestedEvent extends GoalsEvent {
  const CreateGoalRequestedEvent(this.goal);

  final GoalEntity goal;

  @override
  List<Object?> get props => [goal];
}

class UpdateGoalRequestedEvent extends GoalsEvent {
  const UpdateGoalRequestedEvent(this.goal);

  final GoalEntity goal;

  @override
  List<Object?> get props => [goal];
}

class DeleteGoalRequestedEvent extends GoalsEvent {
  const DeleteGoalRequestedEvent(this.goalId);

  final String goalId;

  @override
  List<Object?> get props => [goalId];
}

class AddGoalContributionRequestedEvent extends GoalsEvent {
  const AddGoalContributionRequestedEvent(this.contribution);

  final GoalContributionEntity contribution;

  @override
  List<Object?> get props => [contribution];
}
