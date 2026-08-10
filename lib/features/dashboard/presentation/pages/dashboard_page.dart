import 'package:dhanra_new/core/common_widgets/transaction_tile.dart';
import 'package:dhanra_new/core/di/injection.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/app_spacing.dart';
import 'package:dhanra_new/core/theme/app_typography.dart';
import 'package:dhanra_new/core/widgets/widgets.dart';
import 'package:dhanra_new/features/accounts/domain/entities/account_entity.dart';
import 'package:dhanra_new/features/accounts/domain/usecases/create_account_usecase.dart';
import 'package:dhanra_new/features/accounts/presentation/widgets/add_edit_account_dialog.dart';
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
      appBar: const AppAppBar(
        showLogo: true,
      ),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoadingState ||
                state is DashboardInitialState) {
              return const AppLoading(message: 'Fetching financial overview...');
            }

            if (state is DashboardErrorState) {
              return AppErrorState(
                errorMessage: state.errorMessage,
                onRetry: () => context
                    .read<DashboardBloc>()
                    .add(const LoadDashboardEvent()),
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
                    left: AppSpacing.md,
                    right: AppSpacing.md,
                    top: AppSpacing.xs,
                    bottom: 110,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 0. Setup Account Banner (if balance == 0)
                      if (summary.totalBalance == 0) ...[
                        AppCard(
                          variant: AppCardVariant.hero,
                          backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                          padding: AppSpacing.paddingMD,
                          onTap: () async {
                            final newAccount = await showModalBottomSheet<AccountEntity>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => const AddEditAccountDialog(),
                            );
                            if (newAccount != null && context.mounted) {
                              await getIt<CreateAccountUseCase>().call(newAccount);
                              context.read<DashboardBloc>().add(const RefreshDashboardEvent());
                            }
                          },
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.account_balance_wallet_rounded,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                              AppSpacing.hGapMD,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '👋 Setup Your First Account',
                                      style: AppTypography.titleMedium.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    AppSpacing.vGapXXS,
                                    Text(
                                      'Add your Bank, Cash or Wallet balance to start tracking income & expenses.',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: AppColors.primary,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.vGapMD,
                      ],

                      // 1. Hero Net Balance Card
                      HeroBalanceCard(
                        userName: summary.userName,
                        totalBalance: summary.totalBalance,
                        savingsRate: summary.savingsRatePercentage,
                      ),
                      AppSpacing.vGapMD,

                      // 2. Income vs Expense Side-by-Side Chips
                      IncomeExpenseRow(
                        income: summary.monthlyIncome,
                        expense: summary.monthlyExpense,
                      ),
                      AppSpacing.vGapLG,

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
                      AppSpacing.vGapLG,

                      // 4. Monthly Budget Progress Card
                      GestureDetector(
                        onTap: () => context.push(AppRoutes.budgets),
                        child: BudgetOverviewCard(
                          spentAmount: summary.budgetSpentAmount,
                          totalLimit: summary.budgetTotalLimit,
                        ),
                      ),
                      AppSpacing.vGapMD,

                      // 5. AI Summary Card
                      AiSummaryCard(
                        insightText: summary.aiInsightSummary,
                      ),
                      AppSpacing.vGapLG,

                      // 6. Recent Transactions Feed
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Transactions',
                            style: AppTypography.headlineSmall.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                context.push(AppRoutes.transactions),
                            child: Text(
                              'See All',
                              style: AppTypography.labelLarge.copyWith(
                                color: AppColors.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.vGapXS,

                      if (summary.recentTransactions.isEmpty)
                        const AppEmptyState(
                          title: 'No Recent Transactions',
                          message: 'Your recent transactions will show up here.',
                        )
                      else
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
    );
  }
}
