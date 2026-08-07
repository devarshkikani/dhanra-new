import 'dart:async';
import 'package:dhanra_new/features/goals/data/models/goal_contribution_model.dart';
import 'package:dhanra_new/features/goals/data/models/goal_model.dart';
import 'package:injectable/injectable.dart';

abstract class GoalLocalDataSource {
  Future<List<GoalModel>> getGoals();
  Stream<List<GoalModel>> watchGoals();
  Future<GoalModel> createGoal(GoalModel goal);
  Future<GoalModel> updateGoal(GoalModel goal);
  Future<void> deleteGoal(String goalId);
  Future<GoalContributionModel> addContribution(
      GoalContributionModel contribution);
}

@LazySingleton(as: GoalLocalDataSource)
class GoalLocalDataSourceImpl implements GoalLocalDataSource {
  GoalLocalDataSourceImpl();

  final List<GoalModel> _goals = [];
  final List<GoalContributionModel> _contributions = [];
  final StreamController<List<GoalModel>> _controller =
      StreamController<List<GoalModel>>.broadcast();

  void _notifyListeners() {
    _controller.add(List.unmodifiable(_goals));
  }

  @override
  Future<List<GoalModel>> getGoals() async {
    return List.unmodifiable(_goals);
  }

  @override
  Stream<List<GoalModel>> watchGoals() async* {
    yield List.unmodifiable(_goals);
    yield* _controller.stream;
  }

  @override
  Future<GoalModel> createGoal(GoalModel goal) async {
    _goals.insert(0, goal);
    _notifyListeners();
    return goal;
  }

  @override
  Future<GoalModel> updateGoal(GoalModel goal) async {
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      _goals[index] = goal;
      _notifyListeners();
    }
    return goal;
  }

  @override
  Future<void> deleteGoal(String goalId) async {
    _goals.removeWhere((g) => g.id == goalId);
    _contributions.removeWhere((c) => c.goalId == goalId);
    _notifyListeners();
  }

  @override
  Future<GoalContributionModel> addContribution(
      GoalContributionModel contribution) async {
    _contributions.insert(0, contribution);

    final index = _goals.indexWhere((g) => g.id == contribution.goalId);
    if (index != -1) {
      final goal = _goals[index];
      final newSaved = goal.currentAmount + contribution.amount;
      final isNowCompleted = newSaved >= goal.targetAmount;

      _goals[index] = GoalModel.fromEntity(
        goal.copyWith(
          currentAmount: newSaved,
          isCompleted: isNowCompleted,
        ),
      );
      _notifyListeners();
    }

    return contribution;
  }
}
