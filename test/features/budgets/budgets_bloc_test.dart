import 'package:dhanra_new/features/budgets/domain/entities/budget_entity.dart';
import 'package:dhanra_new/features/budgets/domain/entities/monthly_budget_summary_entity.dart';
import 'package:dhanra_new/features/budgets/domain/usecases/delete_category_budget_usecase.dart';
import 'package:dhanra_new/features/budgets/domain/usecases/get_monthly_budget_summary_usecase.dart';
import 'package:dhanra_new/features/budgets/domain/usecases/save_category_budget_usecase.dart';
import 'package:dhanra_new/features/budgets/domain/usecases/set_monthly_budget_limit_usecase.dart';
import 'package:dhanra_new/features/budgets/presentation/bloc/budgets_bloc.dart';
import 'package:dhanra_new/features/budgets/presentation/bloc/budgets_event.dart';
import 'package:dhanra_new/features/budgets/presentation/bloc/budgets_state.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetMonthlyBudgetSummaryUseCase
    implements GetMonthlyBudgetSummaryUseCase {
  final summary = const MonthlyBudgetSummaryEntity(
    totalLimit: 60000,
    totalSpent: 40450,
    categoryBudgets: [
      BudgetEntity(
        id: 'b_1',
        categoryId: 'cat_food',
        categoryName: 'Food & Dining',
        categoryIcon: 'coffee',
        categoryColor: '#9B5DE5',
        limitAmount: 10000,
        spentAmount: 450,
      ),
    ],
  );

  @override
  Future<MonthlyBudgetSummaryEntity> call() async => summary;

  @override
  Stream<MonthlyBudgetSummaryEntity> watch() async* {
    yield summary;
  }
}

class MockSetMonthlyBudgetLimitUseCase implements SetMonthlyBudgetLimitUseCase {
  @override
  Future<void> call(double totalLimit) async {}
}

class MockSaveCategoryBudgetUseCase implements SaveCategoryBudgetUseCase {
  @override
  Future<BudgetEntity> call(BudgetEntity budget) async => budget;
}

class MockDeleteCategoryBudgetUseCase implements DeleteCategoryBudgetUseCase {
  @override
  Future<void> call(String budgetId) async {}
}

void main() {
  late BudgetsBloc bloc;
  late MockGetMonthlyBudgetSummaryUseCase mockGetSummaryUseCase;

  setUp(() {
    mockGetSummaryUseCase = MockGetMonthlyBudgetSummaryUseCase();
    bloc = BudgetsBloc(
      getMonthlyBudgetSummaryUseCase: mockGetSummaryUseCase,
      setMonthlyBudgetLimitUseCase: MockSetMonthlyBudgetLimitUseCase(),
      saveCategoryBudgetUseCase: MockSaveCategoryBudgetUseCase(),
      deleteCategoryBudgetUseCase: MockDeleteCategoryBudgetUseCase(),
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('BudgetsBloc Unit Tests', () {
    test(
        'initial state transitions to BudgetsLoadedState from live stream listener',
        () async {
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state, isA<BudgetsLoadedState>());
    });

    test('emits BudgetsLoadedState when LoadBudgetsEvent is added', () async {
      bloc.add(const LoadBudgetsEvent());
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state, isA<BudgetsLoadedState>());
      final state = bloc.state as BudgetsLoadedState;
      expect(state.summary.totalLimit, 60000);
      expect(state.summary.categoryBudgets.length, 1);
    });

    test('calculates daily safe spend and status correctly', () {
      final summary = mockGetSummaryUseCase.summary;
      expect(summary.remainingBudget, 19550);
      expect(summary.dailySafeSpend, greaterThan(0));
      expect(summary.categoryBudgets.first.status, BudgetStatus.safe);
    });
  });
}
