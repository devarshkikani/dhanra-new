import 'package:dhanra_new/features/budgets/domain/repositories/budget_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeleteCategoryBudgetUseCase {
  const DeleteCategoryBudgetUseCase(this._repository);

  final BudgetRepository _repository;

  Future<void> call(String budgetId) async {
    return _repository.deleteCategoryBudget(budgetId);
  }
}
