import 'package:dhanra_new/core/common_widgets/app_button.dart';
import 'package:dhanra_new/core/common_widgets/app_text_field.dart';
import 'package:dhanra_new/core/common_widgets/glass_card.dart';
import 'package:dhanra_new/core/di/injection.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/app_gradients.dart';
import 'package:dhanra_new/features/accounts/domain/usecases/get_accounts_usecase.dart';
import 'package:dhanra_new/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:dhanra_new/features/transactions/domain/entities/transaction_entity.dart';
import 'package:dhanra_new/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:dhanra_new/features/transactions/presentation/bloc/transactions_event.dart';
import 'package:dhanra_new/features/transactions/presentation/bloc/transactions_state.dart';
import 'package:dhanra_new/features/transactions/presentation/widgets/add_edit_transaction_dialog.dart';
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

  Future<void> _showAddEditDialog(
    BuildContext context, {
    TransactionEntity? transaction,
  }) async {
    final bloc = context.read<TransactionsBloc>();

    final accounts = await getIt<GetAccountsUseCase>().call();
    final categories = await getIt<GetCategoriesUseCase>().call();

    if (!context.mounted) return;

    final result = await showModalBottomSheet<TransactionEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddEditTransactionDialog(
        transaction: transaction,
        accounts: accounts,
        categories: categories,
      ),
    );

    if (result != null) {
      if (transaction == null) {
        bloc.add(CreateTransactionRequestedEvent(result));
      } else {
        bloc.add(UpdateTransactionRequestedEvent(result));
      }
    }
  }

  void _confirmDelete(BuildContext context, TransactionEntity transaction) {
    final bloc = context.read<TransactionsBloc>();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        title: const Text(
          'Delete Transaction',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          'Are you sure you want to delete "${transaction.title}"?',
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
              bloc.add(DeleteTransactionRequestedEvent(transaction.id));
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
        title: const Text('Transactions'),
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        actions: [
          IconButton(
            icon:
                const Icon(Icons.tune_rounded, color: AppColors.textSecondary),
            tooltip: 'Manage Categories',
            onPressed: () => context.push(AppRoutes.categories),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Add Tx',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.backgroundGlow,
        ),
        child: SafeArea(
          bottom: false,
          child: BlocBuilder<TransactionsBloc, TransactionsState>(
            builder: (context, state) {
              if (state is TransactionsLoadingState ||
                  state is TransactionsInitialState) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (state is TransactionsErrorState) {
                return Center(
                  child: Text(
                    state.errorMessage,
                    style: const TextStyle(color: AppColors.error),
                  ),
                );
              }

              if (state is TransactionsLoadedState) {
                final grouped = state.groupedByDate;

                return Column(
                  children: [
                    // 1. Search Bar & Type Filter Chips
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          AppTextField(
                            hintText: 'Search transactions or notes...',
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: AppColors.textSecondary,
                            ),
                            onChanged: (val) {
                              context
                                  .read<TransactionsBloc>()
                                  .add(TransactionSearchQueryChangedEvent(val));
                            },
                          ),
                          const SizedBox(height: 14),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildFilterChip(
                                  context: context,
                                  label: 'All',
                                  filterKey: 'ALL',
                                  isSelected: state.selectedFilter == 'ALL',
                                ),
                                const SizedBox(width: 8),
                                _buildFilterChip(
                                  context: context,
                                  label: 'Expenses',
                                  filterKey: 'EXPENSE',
                                  isSelected: state.selectedFilter == 'EXPENSE',
                                ),
                                const SizedBox(width: 8),
                                _buildFilterChip(
                                  context: context,
                                  label: 'Income',
                                  filterKey: 'INCOME',
                                  isSelected: state.selectedFilter == 'INCOME',
                                ),
                                const SizedBox(width: 8),
                                _buildFilterChip(
                                  context: context,
                                  label: 'Transfers',
                                  filterKey: 'TRANSFER',
                                  isSelected:
                                      state.selectedFilter == 'TRANSFER',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),

                    // 2. Grouped Date Feed List
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 110,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (grouped.isEmpty) ...[
                              const GlassCard(
                                padding: EdgeInsets.all(24),
                                child: Center(
                                  child: Text(
                                    'No transactions found.',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              ...grouped.entries.map((entry) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Text(
                                        entry.key,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textSecondary,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ),
                                    ...entry.value.map(
                                      (tx) => TransactionItemCard(
                                        transaction: tx,
                                        onEdit: () => _showAddEditDialog(
                                          context,
                                          transaction: tx,
                                        ),
                                        onDelete: () => _confirmDelete(
                                          context,
                                          tx,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required String label,
    required String filterKey,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        context
            .read<TransactionsBloc>()
            .add(TransactionTypeFilterChangedEvent(filterKey));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.inputBackground,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 1.5)
              : Border.all(color: AppColors.inputBorder),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
