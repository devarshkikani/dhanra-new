import 'dart:async';
import 'dart:convert';
import 'package:dhanra_new/features/goals/data/models/goal_contribution_model.dart';
import 'package:dhanra_new/features/goals/data/models/goal_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  GoalLocalDataSourceImpl() {
    _initFromPrefs();
  }

  static const _goalsStorageKey = 'dhanra_goals_v1';
  static const _contributionsStorageKey = 'dhanra_goal_contributions_v1';

  final List<GoalModel> _goals = [];
  final List<GoalContributionModel> _contributions = [];
  final StreamController<List<GoalModel>> _controller =
      StreamController<List<GoalModel>>.broadcast();

  bool _isLoaded = false;
  Completer<void>? _initCompleter;

  Future<void> _initFromPrefs() async {
    if (_isLoaded) return;
    if (_initCompleter != null) return _initCompleter!.future;
    _initCompleter = Completer<void>();

    try {
      final prefs = await SharedPreferences.getInstance();

      // Load Goals
      final rawGoalsJson = prefs.getString(_goalsStorageKey);
      if (rawGoalsJson != null && rawGoalsJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(rawGoalsJson) as List<dynamic>;
        _goals.clear();
        _goals.addAll(
          decoded.map((e) => GoalModel.fromJson(e as Map<String, dynamic>)),
        );
      }

      // Load Contributions
      final rawContribJson = prefs.getString(_contributionsStorageKey);
      if (rawContribJson != null && rawContribJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(rawContribJson) as List<dynamic>;
        _contributions.clear();
        _contributions.addAll(
          decoded.map(
              (e) => GoalContributionModel.fromJson(e as Map<String, dynamic>)),
        );
      }
    } catch (_) {
    } finally {
      _isLoaded = true;
      _initCompleter?.complete();
      _notifyListeners();
    }
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rawGoals = jsonEncode(_goals.map((g) => g.toJson()).toList());
      final rawContribs =
          jsonEncode(_contributions.map((c) => c.toJson()).toList());
      await prefs.setString(_goalsStorageKey, rawGoals);
      await prefs.setString(_contributionsStorageKey, rawContribs);
    } catch (_) {}
  }

  void _notifyListeners() {
    _controller.add(List.unmodifiable(_goals));
  }

  @override
  Future<List<GoalModel>> getGoals() async {
    await _initFromPrefs();
    return List.unmodifiable(_goals);
  }

  @override
  Stream<List<GoalModel>> watchGoals() async* {
    await _initFromPrefs();
    yield List.unmodifiable(_goals);
    yield* _controller.stream;
  }

  @override
  Future<GoalModel> createGoal(GoalModel goal) async {
    await _initFromPrefs();
    _goals.insert(0, goal);
    await _saveToPrefs();
    _notifyListeners();
    return goal;
  }

  @override
  Future<GoalModel> updateGoal(GoalModel goal) async {
    await _initFromPrefs();
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      _goals[index] = goal;
      await _saveToPrefs();
      _notifyListeners();
    }
    return goal;
  }

  @override
  Future<void> deleteGoal(String goalId) async {
    await _initFromPrefs();
    _goals.removeWhere((g) => g.id == goalId);
    _contributions.removeWhere((c) => c.goalId == goalId);
    await _saveToPrefs();
    _notifyListeners();
  }

  @override
  Future<GoalContributionModel> addContribution(
      GoalContributionModel contribution) async {
    await _initFromPrefs();
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
      await _saveToPrefs();
      _notifyListeners();
    }

    return contribution;
  }
}
