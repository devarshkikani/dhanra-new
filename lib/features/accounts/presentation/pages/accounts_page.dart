import 'package:dhanra_new/core/common_widgets/app_button.dart';
import 'package:dhanra_new/core/common_widgets/glass_card.dart';
import 'package:dhanra_new/core/di/injection.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/app_gradients.dart';
import 'package:dhanra_new/features/accounts/domain/entities/account_entity.dart';
import 'package:dhanra_new/features/accounts/presentation/bloc/accounts_bloc.dart';
import 'package:dhanra_new/features/accounts/presentation/bloc/accounts_event.dart';
import 'package:dhanra_new/features/accounts/presentation/bloc/accounts_state.dart';
import 'package:dhanra_new/features/accounts/presentation/widgets/account_card.dart';
import 'package:dhanra_new/features/accounts/presentation/widgets/add_edit_account_dialog.dart';
import 'package:dhanra_new/features/accounts/presentation/widgets/transfer_funds_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountsBloc>(
      create: (_) => getIt<AccountsBloc>()..add(const LoadAccountsEvent()),
      child: const _AccountsView(),
    );
  }
}

class _AccountsView extends StatelessWidget {
  const _AccountsView();

  Future<void> _showAddEditDialog(BuildContext context,
      {AccountEntity? account}) async {
    final bloc = context.read<AccountsBloc>();
    final result = await showModalBottomSheet<AccountEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddEditAccountDialog(account: account),
    );

    if (result != null) {
      if (account == null) {
        bloc.add(CreateAccountRequestedEvent(result));
      } else {
        bloc.add(UpdateAccountRequestedEvent(result));
      }
    }
  }

  Future<void> _showTransferDialog(
      BuildContext context, List<AccountEntity> accounts) async {
    if (accounts.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You need at least 2 accounts to transfer funds.'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    final bloc = context.read<AccountsBloc>();
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TransferFundsDialog(accounts: accounts),
    );

    if (result != null) {
      bloc.add(
        TransferFundsRequestedEvent(
          fromAccountId: result['fromAccountId'] as String,
          toAccountId: result['toAccountId'] as String,
          amount: result['amount'] as double,
        ),
      );
    }
  }

  void _confirmDelete(BuildContext context, AccountEntity account) {
    final bloc = context.read<AccountsBloc>();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        title: const Text('Delete Account',
            style: TextStyle(color: AppColors.textPrimary)),
        content: Text(
          'Are you sure you want to delete "${account.name}"?',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              bloc.add(DeleteAccountRequestedEvent(account.id));
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
        title: const Text('Accounts & Wallets'),
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.backgroundGlow,
        ),
        child: SafeArea(
          bottom: false,
          child: BlocBuilder<AccountsBloc, AccountsState>(
            builder: (context, state) {
              if (state is AccountsLoadingState ||
                  state is AccountsInitialState) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (state is AccountsErrorState) {
                return Center(
                  child: Text(
                    state.errorMessage,
                    style: const TextStyle(color: AppColors.error),
                  ),
                );
              }

              if (state is AccountsLoadedState) {
                final accounts = state.accounts;

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
                      // 1. Net Worth Header Card
                      GlassCard(
                        padding: const EdgeInsets.all(20),
                        borderRadius: 22,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TOTAL NET WORTH',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '₹${state.netWorth.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: AppButton(
                                    text: 'Transfer Funds',
                                    icon: Icons.swap_horiz_rounded,
                                    height: 44,
                                    onPressed: () =>
                                        _showTransferDialog(context, accounts),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: AppButton(
                                    text: 'Add Account',
                                    type: AppButtonType.secondary,
                                    icon: Icons.add_rounded,
                                    height: 44,
                                    onPressed: () =>
                                        _showAddEditDialog(context),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 2. Accounts List Grouped by Type
                      const Text(
                        'Your Accounts',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      if (accounts.isEmpty) ...[
                        const GlassCard(
                          padding: EdgeInsets.all(24),
                          child: Center(
                            child: Text(
                              'No accounts added yet. Tap "Add Account" to get started.',
                              style: TextStyle(color: AppColors.textSecondary),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ] else ...[
                        ...accounts.map(
                          (acc) => AccountCard(
                            account: acc,
                            onEdit: () =>
                                _showAddEditDialog(context, account: acc),
                            onDelete: () => _confirmDelete(context, acc),
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
