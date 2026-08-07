import 'package:dhanra_new/features/budgets/domain/entities/budget_entity.dart';
import 'package:dhanra_new/features/budgets/domain/repositories/budget_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SaveCategoryBudgetUseCase {
  const SaveCategoryBudgetUseCase(this._repository);

  final BudgetRepository _repository;

  Future<BudgetEntity> call(BudgetEntity budget) async {
    return _repository.saveCategoryBudget(budget);
  }
}
