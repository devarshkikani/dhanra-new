import 'package:dhanra_new/features/budgets/domain/entities/budget_entity.dart';
import 'package:dhanra_new/features/budgets/domain/entities/monthly_budget_summary_entity.dart';

abstract class BudgetRepository {
  Future<MonthlyBudgetSummaryEntity> getMonthlySummary();
  Stream<MonthlyBudgetSummaryEntity> watchMonthlySummary();
  Future<void> setTotalMonthlyLimit(double totalLimit);
  Future<BudgetEntity> saveCategoryBudget(BudgetEntity budget);
  Future<void> deleteCategoryBudget(String budgetId);
}
