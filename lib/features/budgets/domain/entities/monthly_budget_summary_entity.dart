import 'package:dhanra_new/features/budgets/domain/entities/budget_entity.dart';
import 'package:equatable/equatable.dart';

class MonthlyBudgetSummaryEntity extends Equatable {
  const MonthlyBudgetSummaryEntity({
    required this.totalLimit,
    required this.totalSpent,
    required this.categoryBudgets,
  });

  final double totalLimit;
  final double totalSpent;
  final List<BudgetEntity> categoryBudgets;

  double get remainingBudget =>
      (totalLimit - totalSpent).clamp(0, double.infinity);
  double get overallPercentageSpent =>
      totalLimit > 0 ? (totalSpent / totalLimit).clamp(0.0, 1.5) : 0.0;

  double get dailySafeSpend {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final remainingDays = (daysInMonth - now.day + 1).clamp(1, 31);
    return remainingBudget / remainingDays;
  }

  BudgetStatus get overallStatus {
    final pct = overallPercentageSpent;
    if (pct >= 1.0) return BudgetStatus.exceeded;
    if (pct >= 0.8) return BudgetStatus.warning;
    return BudgetStatus.safe;
  }

  @override
  List<Object?> get props => [totalLimit, totalSpent, categoryBudgets];
}
