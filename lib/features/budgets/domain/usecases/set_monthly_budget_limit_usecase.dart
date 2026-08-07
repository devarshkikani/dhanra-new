import 'package:dhanra_new/features/budgets/domain/repositories/budget_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SetMonthlyBudgetLimitUseCase {
  const SetMonthlyBudgetLimitUseCase(this._repository);

  final BudgetRepository _repository;

  Future<void> call(double totalLimit) async {
    return _repository.setTotalMonthlyLimit(totalLimit);
  }
}
