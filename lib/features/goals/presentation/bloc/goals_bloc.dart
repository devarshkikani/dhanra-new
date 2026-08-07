import 'dart:async';
import 'package:dhanra_new/features/goals/domain/entities/goals_summary_entity.dart';
import 'package:dhanra_new/features/goals/domain/usecases/add_goal_contribution_usecase.dart';
import 'package:dhanra_new/features/goals/domain/usecases/create_goal_usecase.dart';
import 'package:dhanra_new/features/goals/domain/usecases/delete_goal_usecase.dart';
import 'package:dhanra_new/features/goals/domain/usecases/get_goals_summary_usecase.dart';
import 'package:dhanra_new/features/goals/domain/usecases/update_goal_usecase.dart';
import 'package:dhanra_new/features/goals/presentation/bloc/goals_event.dart';
import 'package:dhanra_new/features/goals/presentation/bloc/goals_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class GoalsBloc extends Bloc<GoalsEvent, GoalsState> {
  GoalsBloc({
    required GetGoalsSummaryUseCase getGoalsSummaryUseCase,
    required CreateGoalUseCase createGoalUseCase,
    required UpdateGoalUseCase updateGoalUseCase,
    required DeleteGoalUseCase deleteGoalUseCase,
    required AddGoalContributionUseCase addGoalContributionUseCase,
  })  : _getGoalsSummaryUseCase = getGoalsSummaryUseCase,
        _createGoalUseCase = createGoalUseCase,
        _updateGoalUseCase = updateGoalUseCase,
        _deleteGoalUseCase = deleteGoalUseCase,
        _addGoalContributionUseCase = addGoalContributionUseCase,
        super(const GoalsInitialState()) {
    on<LoadGoalsEvent>(_onLoadGoals);
    on<GoalsSummaryUpdatedEvent>(_onSummaryUpdated);
    on<CreateGoalRequestedEvent>(_onCreateGoal);
    on<UpdateGoalRequestedEvent>(_onUpdateGoal);
    on<DeleteGoalRequestedEvent>(_onDeleteGoal);
    on<AddGoalContributionRequestedEvent>(_onAddContribution);

    _subscription = _getGoalsSummaryUseCase.watch().listen(
      (summary) {
        add(GoalsSummaryUpdatedEvent(summary));
      },
    );
  }

  final GetGoalsSummaryUseCase _getGoalsSummaryUseCase;
  final CreateGoalUseCase _createGoalUseCase;
  final UpdateGoalUseCase _updateGoalUseCase;
  final DeleteGoalUseCase _deleteGoalUseCase;
  final AddGoalContributionUseCase _addGoalContributionUseCase;

  StreamSubscription<GoalsSummaryEntity>? _subscription;

  Future<void> _onLoadGoals(
    LoadGoalsEvent event,
    Emitter<GoalsState> emit,
  ) async {
    emit(const GoalsLoadingState());
    try {
      final summary = await _getGoalsSummaryUseCase();
      emit(GoalsLoadedState(summary));
    } catch (e) {
      emit(GoalsErrorState(e.toString()));
    }
  }

  void _onSummaryUpdated(
    GoalsSummaryUpdatedEvent event,
    Emitter<GoalsState> emit,
  ) {
    emit(GoalsLoadedState(event.summary));
  }

  Future<void> _onCreateGoal(
    CreateGoalRequestedEvent event,
    Emitter<GoalsState> emit,
  ) async {
    try {
      await _createGoalUseCase(event.goal);
    } catch (e) {
      emit(GoalsErrorState(e.toString()));
    }
  }

  Future<void> _onUpdateGoal(
    UpdateGoalRequestedEvent event,
    Emitter<GoalsState> emit,
  ) async {
    try {
      await _updateGoalUseCase(event.goal);
    } catch (e) {
      emit(GoalsErrorState(e.toString()));
    }
  }

  Future<void> _onDeleteGoal(
    DeleteGoalRequestedEvent event,
    Emitter<GoalsState> emit,
  ) async {
    try {
      await _deleteGoalUseCase(event.goalId);
    } catch (e) {
      emit(GoalsErrorState(e.toString()));
    }
  }

  Future<void> _onAddContribution(
    AddGoalContributionRequestedEvent event,
    Emitter<GoalsState> emit,
  ) async {
    try {
      await _addGoalContributionUseCase(event.contribution);
    } catch (e) {
      emit(GoalsErrorState(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
