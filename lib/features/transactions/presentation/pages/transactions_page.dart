import 'package:dhanra_new/core/di/injection.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/app_spacing.dart';
import 'package:dhanra_new/core/theme/app_typography.dart';
import 'package:dhanra_new/core/widgets/widgets.dart';
import 'package:dhanra_new/features/transactions/domain/entities/transaction_entity.dart';
import 'package:dhanra_new/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:dhanra_new/features/transactions/presentation/bloc/transactions_event.dart';
import 'package:dhanra_new/features/transactions/presentation/bloc/transactions_state.dart';
import 'package:dhanra_new/features/transactions/presentation/pages/add_edit_transaction_page.dart';
import 'package:dhanra_new/features/transactions/presentation/widgets/transaction_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dhanra_new/core/router/app_router.dart';
import 'package:go_router/go_router.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionsBloc>(
      create: (_) =>
          getIt<TransactionsBloc>()..add(const LoadTransactionsEvent()),
      child: const _TransactionsView(),
    );
  }
}

class _TransactionsView extends StatelessWidget {
  const _TransactionsView();

  void _openAddEditPage(
    BuildContext context, {
    TransactionEntity? transaction,
  }) {
    final bloc = context.read<TransactionsBloc>();

    Navigator.of(context)
        .push<dynamic>(
      MaterialPageRoute(
        builder: (_) => AddEditTransactionPage(
          transaction: transaction,
        ),
      ),
    )
        .then((result) {
      if (result != null && context.mounted) {
        bloc.add(const LoadTransactionsEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppAppBar(
        title: 'Transactions',
        actions: [
          IconButton(
            icon:
                const Icon(Icons.tune_rounded, color: AppColors.textSecondary),
            tooltip: 'Manage Categories',
            onPressed: () => context.push(AppRoutes.categories),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: FloatingActionButton.extended(
          onPressed: () => _openAddEditPage(context),
          backgroundColor: AppColors.primary,
          extendedPadding: const EdgeInsets.all(16),
          label: const Icon(
            Icons.add_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<TransactionsBloc, TransactionsState>(
          builder: (context, state) {
            if (state is TransactionsLoadingState ||
                state is TransactionsInitialState) {
              return const AppLoading(message: 'Loading transactions...');
            }

            if (state is TransactionsErrorState) {
              return AppErrorState(
                errorMessage: state.errorMessage,
                onRetry: () => context
                    .read<TransactionsBloc>()
                    .add(const LoadTransactionsEvent()),
              );
            }

            if (state is TransactionsLoadedState) {
              final grouped = state.groupedByDate;

              return Column(
                children: [
                  // 1. Search Bar
                  Padding(
                    padding: AppSpacing.paddingMD,
                    child: AppSearchBar(
                      hint: 'Search title, category or notes...',
                      onChanged: (query) {
                        context.read<TransactionsBloc>().add(
                              TransactionSearchQueryChangedEvent(query),
                            );
                      },
                    ),
                  ),

                  // 2. Type Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: Row(
                      children: [
                        AppChip(
                          label: 'All',
                          isSelected: state.selectedFilter == 'ALL',
                          onTap: () => context.read<TransactionsBloc>().add(
                                const TransactionTypeFilterChangedEvent('ALL'),
                              ),
                        ),
                        AppSpacing.hGapXS,
                        AppChip(
                          label: 'Expense',
                          isSelected: state.selectedFilter == 'EXPENSE',
                          onTap: () => context.read<TransactionsBloc>().add(
                                const TransactionTypeFilterChangedEvent(
                                    'EXPENSE'),
                              ),
                        ),
                        AppSpacing.hGapXS,
                        AppChip(
                          label: 'Income',
                          isSelected: state.selectedFilter == 'INCOME',
                          onTap: () => context.read<TransactionsBloc>().add(
                                const TransactionTypeFilterChangedEvent(
                                    'INCOME'),
                              ),
                        ),
                        AppSpacing.hGapXS,
                        AppChip(
                          label: 'Transfer',
                          isSelected: state.selectedFilter == 'TRANSFER',
                          onTap: () => context.read<TransactionsBloc>().add(
                                const TransactionTypeFilterChangedEvent(
                                    'TRANSFER'),
                              ),
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.vGapMD,

                  // 3. Transactions Grouped List
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(
                        left: AppSpacing.md,
                        right: AppSpacing.md,
                        bottom: 120,
                      ),
                      children: [
                        if (grouped.isEmpty) ...[
                          const AppEmptyState(
                            title: 'No Transactions',
                            message:
                                'No transactions found matching your search.',
                          ),
                        ] else ...[
                          ...grouped.entries.map((entry) {
                            final dateHeader = entry.key;
                            final list = entry.value;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AppSpacing.xs,
                                  ),
                                  child: Text(
                                    dateHeader,
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                ...list.map(
                                  (tx) => TransactionItemCard(
                                    transaction: tx,
                                    onTap: () => _openAddEditPage(
                                      context,
                                      transaction: tx,
                                    ),
                                  ),
                                ),
                                AppSpacing.vGapSM,
                              ],
                            );
                          }),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
