import 'package:dhanra_new/core/common_widgets/glass_card.dart';
import 'package:dhanra_new/core/di/injection.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/app_gradients.dart';
import 'package:dhanra_new/features/budgets/domain/entities/budget_entity.dart';
import 'package:dhanra_new/features/budgets/presentation/bloc/budgets_bloc.dart';
import 'package:dhanra_new/features/budgets/presentation/bloc/budgets_event.dart';
import 'package:dhanra_new/features/budgets/presentation/bloc/budgets_state.dart';
import 'package:dhanra_new/features/budgets/presentation/widgets/add_edit_budget_dialog.dart';
import 'package:dhanra_new/features/budgets/presentation/widgets/budget_summary_hero_card.dart';
import 'package:dhanra_new/features/budgets/presentation/widgets/category_budget_card.dart';
import 'package:dhanra_new/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetsPage extends StatelessWidget {
  const BudgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BudgetsBloc>(
      create: (_) => getIt<BudgetsBloc>()..add(const LoadBudgetsEvent()),
      child: const _BudgetsView(),
    );
  }
}

class _BudgetsView extends StatelessWidget {
  const _BudgetsView();

  Future<void> _showAddEditBudgetDialog(
    BuildContext context, {
    BudgetEntity? budget,
    BudgetDialogMode mode = BudgetDialogMode.categoryBudget,
    double currentTotalLimit = 60000.0,
  }) async {
    final bloc = context.read<BudgetsBloc>();
    final categories = await getIt<GetCategoriesUseCase>().call();

    if (!context.mounted) return;

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddEditBudgetDialog(
        budget: budget,
        categories: categories,
        mode: mode,
        currentTotalLimit: currentTotalLimit,
      ),
    );

    if (result != null) {
      if (result.containsKey('totalLimit')) {
        bloc.add(
            SetTotalMonthlyLimitRequestedEvent(result['totalLimit'] as double));
      } else if (result.containsKey('categoryBudget')) {
        bloc.add(SaveCategoryBudgetRequestedEvent(
            result['categoryBudget'] as BudgetEntity));
      }
    }
  }

  void _confirmDelete(BuildContext context, BudgetEntity budget) {
    final bloc = context.read<BudgetsBloc>();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        title: const Text(
          'Delete Budget Cap',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          'Are you sure you want to remove the budget cap for "${budget.categoryName}"?',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              bloc.add(DeleteCategoryBudgetRequestedEvent(budget.id));
            },
            child:
                const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Budget Management'),
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 75.0),
        child: FloatingActionButton.extended(
          onPressed: () => _showAddEditBudgetDialog(context),
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: const Text('Add Cap',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.darkBackground,
        ),
        child: SafeArea(
          bottom: false,
          child: BlocBuilder<BudgetsBloc, BudgetsState>(
            builder: (context, state) {
              if (state is BudgetsLoadingState ||
                  state is BudgetsInitialState) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (state is BudgetsErrorState) {
                return Center(
                  child: Text(
                    state.errorMessage,
                    style: const TextStyle(color: AppColors.error),
                  ),
                );
              }

              if (state is BudgetsLoadedState) {
                final summary = state.summary;

                return SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 10,
                    bottom: 110,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Monthly Budget Summary Hero Card
                      BudgetSummaryHeroCard(
                        summary: summary,
                        onEditTotalLimit: () => _showAddEditBudgetDialog(
                          context,
                          mode: BudgetDialogMode.totalMonthlyLimit,
                          currentTotalLimit: summary.totalLimit,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 2. Category Budget Caps Section Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Category Budget Caps',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${summary.categoryBudgets.length} Categories',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // 3. Category Budget Caps List
                      if (summary.categoryBudgets.isEmpty) ...[
                        const GlassCard(
                          padding: EdgeInsets.all(24),
                          child: Center(
                            child: Text(
                              'No category budget caps configured.\nTap "+ Add Cap" to set limits.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ),
                        ),
                      ] else ...[
                        ...summary.categoryBudgets.map(
                          (budget) => CategoryBudgetCard(
                            budget: budget,
                            onEdit: () => _showAddEditBudgetDialog(
                              context,
                              budget: budget,
                            ),
                            onDelete: () => _confirmDelete(
                              context,
                              budget,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
