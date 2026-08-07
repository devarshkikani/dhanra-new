import 'dart:async';
import 'package:dhanra_new/features/budgets/domain/entities/monthly_budget_summary_entity.dart';
import 'package:dhanra_new/features/budgets/domain/usecases/delete_category_budget_usecase.dart';
import 'package:dhanra_new/features/budgets/domain/usecases/get_monthly_budget_summary_usecase.dart';
import 'package:dhanra_new/features/budgets/domain/usecases/save_category_budget_usecase.dart';
import 'package:dhanra_new/features/budgets/domain/usecases/set_monthly_budget_limit_usecase.dart';
import 'package:dhanra_new/features/budgets/presentation/bloc/budgets_event.dart';
import 'package:dhanra_new/features/budgets/presentation/bloc/budgets_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class BudgetsBloc extends Bloc<BudgetsEvent, BudgetsState> {
  BudgetsBloc({
    required GetMonthlyBudgetSummaryUseCase getMonthlyBudgetSummaryUseCase,
    required SetMonthlyBudgetLimitUseCase setMonthlyBudgetLimitUseCase,
    required SaveCategoryBudgetUseCase saveCategoryBudgetUseCase,
    required DeleteCategoryBudgetUseCase deleteCategoryBudgetUseCase,
  })  : _getMonthlyBudgetSummaryUseCase = getMonthlyBudgetSummaryUseCase,
        _setMonthlyBudgetLimitUseCase = setMonthlyBudgetLimitUseCase,
        _saveCategoryBudgetUseCase = saveCategoryBudgetUseCase,
        _deleteCategoryBudgetUseCase = deleteCategoryBudgetUseCase,
        super(const BudgetsInitialState()) {
    on<LoadBudgetsEvent>(_onLoadBudgets);
    on<MonthlyBudgetSummaryUpdatedEvent>(_onSummaryUpdated);
    on<SetTotalMonthlyLimitRequestedEvent>(_onSetTotalLimit);
    on<SaveCategoryBudgetRequestedEvent>(_onSaveCategoryBudget);
    on<DeleteCategoryBudgetRequestedEvent>(_onDeleteCategoryBudget);

    _subscription = _getMonthlyBudgetSummaryUseCase.watch().listen(
      (summary) {
        add(MonthlyBudgetSummaryUpdatedEvent(summary));
      },
    );
  }

  final GetMonthlyBudgetSummaryUseCase _getMonthlyBudgetSummaryUseCase;
  final SetMonthlyBudgetLimitUseCase _setMonthlyBudgetLimitUseCase;
  final SaveCategoryBudgetUseCase _saveCategoryBudgetUseCase;
  final DeleteCategoryBudgetUseCase _deleteCategoryBudgetUseCase;

  StreamSubscription<MonthlyBudgetSummaryEntity>? _subscription;

  Future<void> _onLoadBudgets(
    LoadBudgetsEvent event,
    Emitter<BudgetsState> emit,
  ) async {
    emit(const BudgetsLoadingState());
    try {
      final summary = await _getMonthlyBudgetSummaryUseCase();
      emit(BudgetsLoadedState(summary));
    } catch (e) {
      emit(BudgetsErrorState(e.toString()));
    }
  }

  void _onSummaryUpdated(
    MonthlyBudgetSummaryUpdatedEvent event,
    Emitter<BudgetsState> emit,
  ) {
    emit(BudgetsLoadedState(event.summary));
  }

  Future<void> _onSetTotalLimit(
    SetTotalMonthlyLimitRequestedEvent event,
    Emitter<BudgetsState> emit,
  ) async {
    try {
      await _setMonthlyBudgetLimitUseCase(event.totalLimit);
    } catch (e) {
      emit(BudgetsErrorState(e.toString()));
    }
  }

  Future<void> _onSaveCategoryBudget(
    SaveCategoryBudgetRequestedEvent event,
    Emitter<BudgetsState> emit,
  ) async {
    try {
      await _saveCategoryBudgetUseCase(event.budget);
    } catch (e) {
      emit(BudgetsErrorState(e.toString()));
    }
  }

  Future<void> _onDeleteCategoryBudget(
    DeleteCategoryBudgetRequestedEvent event,
    Emitter<BudgetsState> emit,
  ) async {
    try {
      await _deleteCategoryBudgetUseCase(event.budgetId);
    } catch (e) {
      emit(BudgetsErrorState(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
