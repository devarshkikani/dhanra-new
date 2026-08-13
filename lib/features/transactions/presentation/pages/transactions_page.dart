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
import 'package:dhanra_new/features/transactions/presentation/widgets/transaction_filter_bottom_sheet.dart';
import 'package:dhanra_new/features/transactions/presentation/widgets/transaction_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  Future<void> _openFilterSheet(
    BuildContext context,
    TransactionsLoadedState state,
  ) async {
    final bloc = context.read<TransactionsBloc>();
    final result = await showModalBottomSheet<TransactionFilterResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TransactionFilterBottomSheet(
        initialFilter: state.selectedFilter,
        initialAccountId: state.selectedAccountId,
        initialCategoryId: state.selectedCategoryId,
        initialSortBy: state.sortBy,
      ),
    );

    if (result != null && context.mounted) {
      bloc.add(
        ApplyAdvancedTransactionFiltersEvent(
          selectedFilter: result.selectedFilter,
          selectedAccountId: result.selectedAccountId,
          selectedCategoryId: result.selectedCategoryId,
          sortBy: result.sortBy,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppAppBar(
        title: 'Transactions',
        actions: [
          BlocBuilder<TransactionsBloc, TransactionsState>(
            builder: (context, state) {
              final hasFilters =
                  state is TransactionsLoadedState && state.hasActiveFilters;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.tune_rounded,
                      color: hasFilters
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                    tooltip: 'Filter Transactions',
                    onPressed: () {
                      if (state is TransactionsLoadedState) {
                        _openFilterSheet(context, state);
                      }
                    },
                  ),
                  if (hasFilters)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              );
            },
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
                  AppSpacing.vGapSM,

                  // 3. Transactions List grouped by date
                  Expanded(
                    child: grouped.isEmpty
                        ? const AppEmptyState(
                            icon: Icons.receipt_long_rounded,
                            title: 'No Transactions Found',
                            message:
                                'Try adjusting your search query or filters.',
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(
                              left: AppSpacing.md,
                              right: AppSpacing.md,
                              bottom: 110,
                            ),
                            itemCount: grouped.keys.length,
                            itemBuilder: (context, index) {
                              final dateHeader =
                                  grouped.keys.elementAt(index);
                              final txs = grouped[dateHeader]!;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: AppSpacing.xs,
                                    ),
                                    child: Text(
                                      dateHeader,
                                      style:
                                          AppTypography.labelMedium.copyWith(
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  ...txs.map(
                                    (tx) => TransactionItemCard(
                                      transaction: tx,
                                      onTap: () => _openAddEditPage(
                                        context,
                                        transaction: tx,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
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
