import 'package:dhanra_new/core/di/injection.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/app_spacing.dart';
import 'package:dhanra_new/core/theme/app_typography.dart';
import 'package:dhanra_new/core/widgets/widgets.dart';
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
    AppDialog.show(
      context: context,
      title: 'Delete Account',
      message: 'Are you sure you want to delete "${account.name}"?',
      primaryButtonText: 'Delete',
      secondaryButtonText: 'Cancel',
      icon: Icons.delete_outline_rounded,
      onPrimaryPressed: () {
        bloc.add(DeleteAccountRequestedEvent(account.id));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const AppAppBar(
        title: 'Accounts & Wallets',
      ),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<AccountsBloc, AccountsState>(
          builder: (context, state) {
            if (state is AccountsLoadingState ||
                state is AccountsInitialState) {
              return const AppLoading(message: 'Loading accounts...');
            }

            if (state is AccountsErrorState) {
              return AppErrorState(
                errorMessage: state.errorMessage,
                onRetry: () => context
                    .read<AccountsBloc>()
                    .add(const LoadAccountsEvent()),
              );
            }

            if (state is AccountsLoadedState) {
              final accounts = state.accounts;

              return SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: AppSpacing.md,
                  right: AppSpacing.md,
                  top: AppSpacing.xs,
                  bottom: 110,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Net Worth Header Card
                    AppCard(
                      variant: AppCardVariant.hero,
                      padding: AppSpacing.paddingMD,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TOTAL NET WORTH',
                            style: AppTypography.labelSmall.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          AppSpacing.vGapXS,
                          Text(
                            '₹${state.netWorth.toStringAsFixed(2)}',
                            style: AppTypography.displayMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          AppSpacing.vGapMD,
                          Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  title: 'Transfer',
                                  icon: Icons.swap_horiz_rounded,
                                  height: 44,
                                  onPressed: () =>
                                      _showTransferDialog(context, accounts),
                                ),
                              ),
                              AppSpacing.hGapSM,
                              Expanded(
                                child: AppButton(
                                  title: 'Add Account',
                                  variant: AppButtonVariant.secondary,
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
                    AppSpacing.vGapLG,

                    // 2. Accounts List Grouped by Type
                    Text(
                      'Your Accounts',
                      style: AppTypography.headlineSmall.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    AppSpacing.vGapSM,

                    if (accounts.isEmpty) ...[
                      AppEmptyState(
                        title: 'No Accounts Added',
                        message: 'Tap "Add Account" to manage your bank accounts & wallets.',
                        buttonText: 'Add Account',
                        onAction: () => _showAddEditDialog(context),
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
    );
  }
}
