import 'dart:async';
import 'dart:convert';
import 'package:dhanra_new/features/budgets/data/models/budget_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BudgetLocalDataSource {
  Future<double> getTotalMonthlyLimit();
  Future<double> getEffectiveTotalMonthlyLimit();
  Future<List<BudgetModel>> getCategoryBudgets();
  Stream<List<BudgetModel>> watchCategoryBudgets();
  Future<void> setTotalMonthlyLimit(double limit);
  Future<BudgetModel> saveCategoryBudget(BudgetModel budget);
  Future<void> deleteCategoryBudget(String budgetId);
  Future<void> updateCategorySpentAmounts(Map<String, double> categorySpentMap);
}

@LazySingleton(as: BudgetLocalDataSource)
class BudgetLocalDataSourceImpl implements BudgetLocalDataSource {
  BudgetLocalDataSourceImpl() {
    _initFromPrefs();
  }

  static const _budgetsStorageKey = 'dhanra_budgets_v1';
  static const _totalLimitStorageKey = 'dhanra_total_budget_limit_v1';

  double _totalMonthlyLimit = 0.0;
  final List<BudgetModel> _budgets = [];
  final StreamController<List<BudgetModel>> _controller =
      StreamController<List<BudgetModel>>.broadcast();

  bool _isLoaded = false;
  Completer<void>? _initCompleter;

  Future<void> _initFromPrefs() async {
    if (_isLoaded) return;
    if (_initCompleter != null) return _initCompleter!.future;
    _initCompleter = Completer<void>();

    try {
      final prefs = await SharedPreferences.getInstance();
      _totalMonthlyLimit = prefs.getDouble(_totalLimitStorageKey) ?? 0.0;

      final rawJson = prefs.getString(_budgetsStorageKey);
      if (rawJson != null && rawJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(rawJson) as List<dynamic>;
        _budgets.clear();
        _budgets.addAll(
          decoded.map((e) => BudgetModel.fromJson(e as Map<String, dynamic>)),
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
      await prefs.setDouble(_totalLimitStorageKey, _totalMonthlyLimit);
      final rawJson = jsonEncode(_budgets.map((b) => b.toJson()).toList());
      await prefs.setString(_budgetsStorageKey, rawJson);
    } catch (_) {}
  }

  void _notifyListeners() {
    _controller.add(List.unmodifiable(_budgets));
  }

  @override
  Future<double> getTotalMonthlyLimit() async {
    await _initFromPrefs();
    return _totalMonthlyLimit;
  }

  @override
  Future<double> getEffectiveTotalMonthlyLimit() async {
    await _initFromPrefs();
    if (_totalMonthlyLimit > 0) {
      return _totalMonthlyLimit;
    }
    if (_budgets.isNotEmpty) {
      return _budgets.fold<double>(0, (sum, item) => sum + item.limitAmount);
    }
    return 0.0;
  }

  @override
  Future<List<BudgetModel>> getCategoryBudgets() async {
    await _initFromPrefs();
    return List.unmodifiable(_budgets);
  }

  @override
  Stream<List<BudgetModel>> watchCategoryBudgets() async* {
    await _initFromPrefs();
    yield List.unmodifiable(_budgets);
    yield* _controller.stream;
  }

  @override
  Future<void> setTotalMonthlyLimit(double limit) async {
    await _initFromPrefs();
    _totalMonthlyLimit = limit;
    await _saveToPrefs();
    _notifyListeners();
  }

  @override
  Future<BudgetModel> saveCategoryBudget(BudgetModel budget) async {
    await _initFromPrefs();
    final index = _budgets.indexWhere(
        (b) => b.id == budget.id || b.categoryId == budget.categoryId);
    if (index != -1) {
      _budgets[index] = budget;
    } else {
      _budgets.add(budget);
    }
    await _saveToPrefs();
    _notifyListeners();
    return budget;
  }

  @override
  Future<void> deleteCategoryBudget(String budgetId) async {
    await _initFromPrefs();
    _budgets.removeWhere((b) => b.id == budgetId);
    await _saveToPrefs();
    _notifyListeners();
  }

  @override
  Future<void> updateCategorySpentAmounts(
      Map<String, double> categorySpentMap) async {
    await _initFromPrefs();
    for (var i = 0; i < _budgets.length; i++) {
      final b = _budgets[i];
      final spent = categorySpentMap[b.categoryId] ?? 0.0;
      _budgets[i] = BudgetModel.fromEntity(b.copyWith(spentAmount: spent));
    }
    await _saveToPrefs();
    _notifyListeners();
  }
}
