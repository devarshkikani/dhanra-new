import 'package:dhanra_new/features/goals/domain/entities/goals_summary_entity.dart';
import 'package:equatable/equatable.dart';

abstract class GoalsState extends Equatable {
  const GoalsState();

  @override
  List<Object?> get props => [];
}

class GoalsInitialState extends GoalsState {
  const GoalsInitialState();
}

class GoalsLoadingState extends GoalsState {
  const GoalsLoadingState();
}

class GoalsLoadedState extends GoalsState {
  const GoalsLoadedState(this.summary);

  final GoalsSummaryEntity summary;

  @override
  List<Object?> get props => [summary];
}

class GoalsErrorState extends GoalsState {
  const GoalsErrorState(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
