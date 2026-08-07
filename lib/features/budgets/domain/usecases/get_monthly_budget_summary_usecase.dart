import 'package:dhanra_new/features/budgets/domain/entities/monthly_budget_summary_entity.dart';
import 'package:dhanra_new/features/budgets/domain/repositories/budget_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetMonthlyBudgetSummaryUseCase {
  const GetMonthlyBudgetSummaryUseCase(this._repository);

  final BudgetRepository _repository;

  Future<MonthlyBudgetSummaryEntity> call() async {
    return _repository.getMonthlySummary();
  }

  Stream<MonthlyBudgetSummaryEntity> watch() {
    return _repository.watchMonthlySummary();
  }
}
