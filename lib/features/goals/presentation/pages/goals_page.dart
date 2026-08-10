import 'package:dhanra_new/core/common_widgets/glass_card.dart';
import 'package:dhanra_new/core/di/injection.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/app_gradients.dart';
import 'package:dhanra_new/features/accounts/domain/usecases/get_accounts_usecase.dart';
import 'package:dhanra_new/features/goals/domain/entities/goal_contribution_entity.dart';
import 'package:dhanra_new/features/goals/domain/entities/goal_entity.dart';
import 'package:dhanra_new/features/goals/presentation/bloc/goals_bloc.dart';
import 'package:dhanra_new/features/goals/presentation/bloc/goals_event.dart';
import 'package:dhanra_new/features/goals/presentation/bloc/goals_state.dart';
import 'package:dhanra_new/features/goals/presentation/widgets/add_contribution_dialog.dart';
import 'package:dhanra_new/features/goals/presentation/widgets/add_edit_goal_dialog.dart';
import 'package:dhanra_new/features/goals/presentation/widgets/goal_card.dart';
import 'package:dhanra_new/features/goals/presentation/widgets/goals_summary_hero_card.dart';
import 'package:dhanra_new/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GoalsBloc>(
      create: (_) => getIt<GoalsBloc>()..add(const LoadGoalsEvent()),
      child: const _GoalsView(),
    );
  }
}

class _GoalsView extends StatelessWidget {
  const _GoalsView();

  Future<void> _showAddEditGoalDialog(
    BuildContext context, {
    GoalEntity? goal,
  }) async {
    final bloc = context.read<GoalsBloc>();

    final result = await showModalBottomSheet<GoalEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddEditGoalDialog(goal: goal),
    );

    if (result != null) {
      if (goal == null) {
        bloc.add(CreateGoalRequestedEvent(result));
      } else {
        bloc.add(UpdateGoalRequestedEvent(result));
      }
    }
  }

  Future<void> _showAddContributionDialog(
    BuildContext context,
    GoalEntity goal,
  ) async {
    final bloc = context.read<GoalsBloc>();
    final accounts = await getIt<GetAccountsUseCase>().call();

    if (!context.mounted) return;

    final result = await showModalBottomSheet<GoalContributionEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddContributionDialog(
        goal: goal,
        accounts: accounts,
      ),
    );

    if (result != null) {
      bloc.add(AddGoalContributionRequestedEvent(result));
    }
  }

  void _confirmDelete(BuildContext context, GoalEntity goal) {
    final bloc = context.read<GoalsBloc>();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        title: const Text(
          'Delete Savings Goal',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          'Are you sure you want to delete "${goal.title}"?',
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
              bloc.add(DeleteGoalRequestedEvent(goal.id));
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
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const AppAppBar(
          title: 'Savings Goals & Milestones',
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddEditGoalDialog(context),
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: const Text('New Goal',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        body: SafeArea(
          bottom: false,
          child: BlocBuilder<GoalsBloc, GoalsState>(
            builder: (context, state) {
              if (state is GoalsLoadingState || state is GoalsInitialState) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (state is GoalsErrorState) {
                return Center(
                  child: Text(
                    state.errorMessage,
                    style: const TextStyle(color: AppColors.error),
                  ),
                );
              }

              if (state is GoalsLoadedState) {
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
                      // 1. Overall Goals Summary Hero Card
                      GoalsSummaryHeroCard(summary: summary),
                      const SizedBox(height: 24),

                      // 2. Active Goals List Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Your Savings Milestones',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${summary.goals.length} Total Goals',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // 3. Goals List
                      if (summary.goals.isEmpty) ...[
                        const GlassCard(
                          padding: EdgeInsets.all(24),
                          child: Center(
                            child: Text(
                              'No savings goals created yet.\nTap "+ New Goal" to start saving.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ),
                        ),
                      ] else ...[
                        ...summary.goals.map(
                          (goal) => GoalCard(
                            goal: goal,
                            onAddContribution: () => _showAddContributionDialog(
                              context,
                              goal,
                            ),
                            onEdit: () => _showAddEditGoalDialog(
                              context,
                              goal: goal,
                            ),
                            onDelete: () => _confirmDelete(
                              context,
                              goal,
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
