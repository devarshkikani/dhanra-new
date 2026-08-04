import 'package:dhanra_new/core/common_widgets/transaction_tile.dart';
import 'package:dhanra_new/core/di/injection.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/app_gradients.dart';
import 'package:dhanra_new/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:dhanra_new/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:dhanra_new/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:dhanra_new/features/dashboard/presentation/widgets/ai_summary_card.dart';
import 'package:dhanra_new/features/dashboard/presentation/widgets/budget_overview_card.dart';
import 'package:dhanra_new/features/dashboard/presentation/widgets/hero_balance_card.dart';
import 'package:dhanra_new/features/dashboard/presentation/widgets/income_expense_row.dart';
import 'package:dhanra_new/features/dashboard/presentation/widgets/quick_actions_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dhanra_new/core/router/app_router.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DashboardBloc>(
      create: (_) => getIt<DashboardBloc>()..add(const LoadDashboardEvent()),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.backgroundGlow,
        ),
        child: SafeArea(
          bottom: false,
          child: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoadingState ||
                  state is DashboardInitialState) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                );
              }

              if (state is DashboardErrorState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        size: 48,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.errorMessage,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context
                            .read<DashboardBloc>()
                            .add(const LoadDashboardEvent()),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is DashboardLoadedState) {
                final summary = state.summary;

                return RefreshIndicator(
                  color: AppColors.primary,
                  backgroundColor: AppColors.darkCard,
                  onRefresh: () async {
                    context
                        .read<DashboardBloc>()
                        .add(const RefreshDashboardEvent());
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 16,
                      bottom: 110, // Generous padding for floating nav pill bar
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Hero Net Balance Card
                        HeroBalanceCard(
                          userName: summary.userName,
                          totalBalance: summary.totalBalance,
                          savingsRate: summary.savingsRatePercentage,
                        ),
                        const SizedBox(height: 16),

                        // 2. Income vs Expense Side-by-Side Chips
                        IncomeExpenseRow(
                          income: summary.monthlyIncome,
                          expense: summary.monthlyExpense,
                        ),
                        const SizedBox(height: 22),

                        // 3. Quick Action Shortcuts
                        QuickActionsRow(
                          onAddExpense: () {
                            context.push(AppRoutes.transactions);
                          },
                          onAddIncome: () {
                            context.push(AppRoutes.transactions);
                          },
                          onTransfer: () {
                            context.push(AppRoutes.accounts);
                          },
                          onAiAssistant: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('AI Financial Insights triggered'),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // 4. Monthly Budget Progress Card
                        BudgetOverviewCard(
                          spentAmount: summary.budgetSpentAmount,
                          totalLimit: summary.budgetTotalLimit,
                        ),
                        const SizedBox(height: 18),

                        // 5. AI Summary Card
                        AiSummaryCard(
                          insightText: summary.aiInsightSummary,
                        ),
                        const SizedBox(height: 24),

                        // 6. Recent Transactions Feed
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Recent Transactions',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  context.push(AppRoutes.transactions),
                              child: const Text(
                                'See All',
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ...summary.recentTransactions.map(
                          (tx) => TransactionTile(
                            title: tx.title,
                            category: tx.category,
                            amount: tx.amount,
                            date: tx.date,
                            isCredit: tx.isCredit,
                          ),
                        ),
                      ],
                    ),
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
