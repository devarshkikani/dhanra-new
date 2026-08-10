import 'package:dhanra_new/core/di/injection.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/app_spacing.dart';
import 'package:dhanra_new/core/theme/app_typography.dart';
import 'package:dhanra_new/core/widgets/widgets.dart';
import 'package:dhanra_new/features/accounts/domain/entities/account_entity.dart';
import 'package:dhanra_new/features/accounts/domain/usecases/create_account_usecase.dart';
import 'package:dhanra_new/features/accounts/domain/usecases/get_accounts_usecase.dart';
import 'package:dhanra_new/features/accounts/presentation/widgets/add_edit_account_dialog.dart';
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

    // Guardrail: If user has zero accounts, prompt Add Account first!
    if (accounts.isEmpty) {
      final shouldCreate = await showDialog<bool>(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          backgroundColor: AppColors.darkCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Account Required',
            style: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimary),
          ),
          content: Text(
            'You need to create at least one account (e.g. Bank Account, Cash, or Credit Card) before logging transactions.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(false),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
            ),
            AppButton(
              title: '+ Add Account Now',
              height: 40,
              width: 160,
              onPressed: () => Navigator.of(dialogCtx).pop(true),
            ),
          ],
        ),
      );

      if (shouldCreate == true && context.mounted) {
        final newAccount = await showModalBottomSheet<AccountEntity>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const AddEditAccountDialog(),
        );

        if (newAccount != null && context.mounted) {
          await getIt<CreateAccountUseCase>().call(newAccount);
          final updatedAccounts = await getIt<GetAccountsUseCase>().call();
          if (!context.mounted || updatedAccounts.isEmpty) return;

          final result = await showModalBottomSheet<TransactionEntity>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => AddEditTransactionDialog(
              transaction: transaction,
              accounts: updatedAccounts,
              categories: categories,
            ),
          );

          if (result != null && context.mounted) {
            bloc.add(CreateTransactionRequestedEvent(result));
          }
        }
      }
      return;
    }

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

    if (result != null && context.mounted) {
      if (transaction == null) {
        bloc.add(CreateTransactionRequestedEvent(result));
      } else {
        bloc.add(UpdateTransactionRequestedEvent(result));
      }
    }
  }

  void _confirmDelete(BuildContext context, TransactionEntity transaction) {
    final bloc = context.read<TransactionsBloc>();
    AppDialog.show(
      context: context,
      title: 'Delete Transaction',
      message: 'Are you sure you want to delete "${transaction.title}"?',
      primaryButtonText: 'Delete',
      secondaryButtonText: 'Cancel',
      icon: Icons.delete_outline_rounded,
      onPrimaryPressed: () {
        bloc.add(DeleteTransactionRequestedEvent(transaction.id));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
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
          onPressed: () => _showAddEditDialog(context),
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: Text(
            'Add Tx',
            style: AppTypography.labelLarge.copyWith(color: Colors.white),
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
                                    onEdit: () => _showAddEditDialog(
                                      context,
                                      transaction: tx,
                                    ),
                                    onDelete: () =>
                                        _confirmDelete(context, tx),
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
