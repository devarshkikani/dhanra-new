import 'package:dhanra_new/features/goals/domain/entities/goal_contribution_entity.dart';
import 'package:dhanra_new/features/goals/domain/entities/goal_entity.dart';
import 'package:dhanra_new/features/goals/domain/entities/goals_summary_entity.dart';
import 'package:dhanra_new/features/goals/domain/usecases/add_goal_contribution_usecase.dart';
import 'package:dhanra_new/features/goals/domain/usecases/create_goal_usecase.dart';
import 'package:dhanra_new/features/goals/domain/usecases/delete_goal_usecase.dart';
import 'package:dhanra_new/features/goals/domain/usecases/get_goals_summary_usecase.dart';
import 'package:dhanra_new/features/goals/domain/usecases/update_goal_usecase.dart';
import 'package:dhanra_new/features/goals/presentation/bloc/goals_bloc.dart';
import 'package:dhanra_new/features/goals/presentation/bloc/goals_event.dart';
import 'package:dhanra_new/features/goals/presentation/bloc/goals_state.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetGoalsSummaryUseCase implements GetGoalsSummaryUseCase {
  final summary = GoalsSummaryEntity(
    totalTarget: 600000,
    totalSaved: 435000,
    activeGoalsCount: 2,
    completedGoalsCount: 1,
    goals: [
      GoalEntity(
        id: 'g_1',
        title: 'Emergency Reserve',
        targetAmount: 200000,
        currentAmount: 140000,
        deadline: DateTime.now().add(const Duration(days: 365)),
        iconName: 'shield',
        colorHex: '#00C853',
      ),
    ],
  );

  @override
  Future<GoalsSummaryEntity> call() async => summary;

  @override
  Stream<GoalsSummaryEntity> watch() async* {
    yield summary;
  }
}

class MockCreateGoalUseCase implements CreateGoalUseCase {
  @override
  Future<GoalEntity> call(GoalEntity goal) async => goal;
}

class MockUpdateGoalUseCase implements UpdateGoalUseCase {
  @override
  Future<GoalEntity> call(GoalEntity goal) async => goal;
}

class MockDeleteGoalUseCase implements DeleteGoalUseCase {
  @override
  Future<void> call(String goalId) async {}
}

class MockAddGoalContributionUseCase implements AddGoalContributionUseCase {
  @override
  Future<GoalContributionEntity> call(
          GoalContributionEntity contribution) async =>
      contribution;
}

void main() {
  late GoalsBloc bloc;
  late MockGetGoalsSummaryUseCase mockGetSummaryUseCase;

  setUp(() {
    mockGetSummaryUseCase = MockGetGoalsSummaryUseCase();
    bloc = GoalsBloc(
      getGoalsSummaryUseCase: mockGetSummaryUseCase,
      createGoalUseCase: MockCreateGoalUseCase(),
      updateGoalUseCase: MockUpdateGoalUseCase(),
      deleteGoalUseCase: MockDeleteGoalUseCase(),
      addGoalContributionUseCase: MockAddGoalContributionUseCase(),
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('GoalsBloc Unit Tests', () {
    test(
        'initial state transitions to GoalsLoadedState from live stream listener',
        () async {
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state, isA<GoalsLoadedState>());
    });

    test('emits GoalsLoadedState when LoadGoalsEvent is added', () async {
      bloc.add(const LoadGoalsEvent());
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state, isA<GoalsLoadedState>());
      final state = bloc.state as GoalsLoadedState;
      expect(state.summary.totalTarget, 600000);
      expect(state.summary.totalSaved, 435000);
    });

    test('calculates remaining to save and suggested monthly contribution', () {
      final goal = mockGetSummaryUseCase.summary.goals.first;
      expect(goal.remainingAmount, 60000);
      expect(goal.suggestedMonthlyContribution, greaterThan(0));
      expect(goal.percentageSaved, closeTo(0.7, 0.05));
    });
  });
}
