import 'package:dhanra_new/features/budgets/domain/entities/monthly_budget_summary_entity.dart';
import 'package:equatable/equatable.dart';

abstract class BudgetsState extends Equatable {
  const BudgetsState();

  @override
  List<Object?> get props => [];
}

class BudgetsInitialState extends BudgetsState {
  const BudgetsInitialState();
}

class BudgetsLoadingState extends BudgetsState {
  const BudgetsLoadingState();
}

class BudgetsLoadedState extends BudgetsState {
  const BudgetsLoadedState(this.summary);

  final MonthlyBudgetSummaryEntity summary;

  @override
  List<Object?> get props => [summary];
}

class BudgetsErrorState extends BudgetsState {
  const BudgetsErrorState(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
