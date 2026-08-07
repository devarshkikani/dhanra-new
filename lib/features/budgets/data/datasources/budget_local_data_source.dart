import 'dart:async';
import 'package:dhanra_new/features/budgets/data/models/budget_model.dart';
import 'package:injectable/injectable.dart';

abstract class BudgetLocalDataSource {
  Future<double> getTotalMonthlyLimit();
  Future<List<BudgetModel>> getCategoryBudgets();
  Stream<List<BudgetModel>> watchCategoryBudgets();
  Future<void> setTotalMonthlyLimit(double limit);
  Future<BudgetModel> saveCategoryBudget(BudgetModel budget);
  Future<void> deleteCategoryBudget(String budgetId);
  Future<void> updateCategorySpentAmounts(Map<String, double> categorySpentMap);
}

@LazySingleton(as: BudgetLocalDataSource)
class BudgetLocalDataSourceImpl implements BudgetLocalDataSource {
  BudgetLocalDataSourceImpl();

  double _totalMonthlyLimit = 0.0;
  final List<BudgetModel> _budgets = [];
  final StreamController<List<BudgetModel>> _controller =
      StreamController<List<BudgetModel>>.broadcast();

  void _notifyListeners() {
    _controller.add(List.unmodifiable(_budgets));
  }

  @override
  Future<double> getTotalMonthlyLimit() async {
    return _totalMonthlyLimit;
  }

  @override
  Future<List<BudgetModel>> getCategoryBudgets() async {
    return List.unmodifiable(_budgets);
  }

  @override
  Stream<List<BudgetModel>> watchCategoryBudgets() async* {
    yield List.unmodifiable(_budgets);
    yield* _controller.stream;
  }

  @override
  Future<void> setTotalMonthlyLimit(double limit) async {
    _totalMonthlyLimit = limit;
    _notifyListeners();
  }

  @override
  Future<BudgetModel> saveCategoryBudget(BudgetModel budget) async {
    final index = _budgets.indexWhere(
        (b) => b.id == budget.id || b.categoryId == budget.categoryId);
    if (index != -1) {
      _budgets[index] = budget;
    } else {
      _budgets.add(budget);
    }
    _notifyListeners();
    return budget;
  }

  @override
  Future<void> deleteCategoryBudget(String budgetId) async {
    _budgets.removeWhere((b) => b.id == budgetId);
    _notifyListeners();
  }

  @override
  Future<void> updateCategorySpentAmounts(
      Map<String, double> categorySpentMap) async {
    for (var i = 0; i < _budgets.length; i++) {
      final b = _budgets[i];
      final spent = categorySpentMap[b.categoryId] ?? 0.0;
      _budgets[i] = BudgetModel.fromEntity(b.copyWith(spentAmount: spent));
    }
    _notifyListeners();
  }
}
