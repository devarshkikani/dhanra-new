import 'package:dhanra_new/features/budgets/domain/entities/budget_entity.dart';
import 'package:dhanra_new/features/budgets/domain/entities/monthly_budget_summary_entity.dart';
import 'package:equatable/equatable.dart';

abstract class BudgetsEvent extends Equatable {
  const BudgetsEvent();

  @override
  List<Object?> get props => [];
}

class LoadBudgetsEvent extends BudgetsEvent {
  const LoadBudgetsEvent();
}

class MonthlyBudgetSummaryUpdatedEvent extends BudgetsEvent {
  const MonthlyBudgetSummaryUpdatedEvent(this.summary);

  final MonthlyBudgetSummaryEntity summary;

  @override
  List<Object?> get props => [summary];
}

class SetTotalMonthlyLimitRequestedEvent extends BudgetsEvent {
  const SetTotalMonthlyLimitRequestedEvent(this.totalLimit);

  final double totalLimit;

  @override
  List<Object?> get props => [totalLimit];
}

class SaveCategoryBudgetRequestedEvent extends BudgetsEvent {
  const SaveCategoryBudgetRequestedEvent(this.budget);

  final BudgetEntity budget;

  @override
  List<Object?> get props => [budget];
}

class DeleteCategoryBudgetRequestedEvent extends BudgetsEvent {
  const DeleteCategoryBudgetRequestedEvent(this.budgetId);

  final String budgetId;

  @override
  List<Object?> get props => [budgetId];
}
