import 'package:dhanra_new/core/common_widgets/app_button.dart';
import 'package:dhanra_new/core/common_widgets/app_dropdown.dart';
import 'package:dhanra_new/core/common_widgets/app_text_field.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/currency_extension.dart';
import 'package:dhanra_new/features/accounts/domain/entities/account_entity.dart';
import 'package:flutter/material.dart';

class TransferFundsDialog extends StatefulWidget {
  const TransferFundsDialog({
    required this.accounts,
    super.key,
  });

  final List<AccountEntity> accounts;

  @override
  State<TransferFundsDialog> createState() => _TransferFundsDialogState();
}

class _TransferFundsDialogState extends State<TransferFundsDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  String? _fromAccountId;
  String? _toAccountId;

  @override
  void initState() {
    super.initState();
    if (widget.accounts.length >= 2) {
      _fromAccountId = widget.accounts[0].id;
      _toAccountId = widget.accounts[1].id;
    } else if (widget.accounts.isNotEmpty) {
      _fromAccountId = widget.accounts[0].id;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onTransfer() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_fromAccountId == null || _toAccountId == null) return;
      if (_fromAccountId == _toAccountId) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Source and Destination accounts must be different'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
      if (amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Enter a valid transfer amount'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      Navigator.of(context).pop({
        'fromAccountId': _fromAccountId,
        'toAccountId': _toAccountId,
        'amount': amount,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Transfer Between Accounts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.close, color: AppColors.textSecondary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'From Account',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              AppDropdown<String>(
                value: _fromAccountId,
                prefixIcon: Icons.account_balance_wallet_rounded,
                items: widget.accounts.map((acc) {
                  return AppDropdownItem<String>(
                    value: acc.id,
                    label: acc.name,
                    subtitle:
                        'Balance: ${context.currencySymbol}${acc.balance.toStringAsFixed(0)}',
                    icon: Icons.account_balance_wallet_rounded,
                    iconColor: AppColors.primary,
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _fromAccountId = val;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'To Account',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              AppDropdown<String>(
                value: _toAccountId,
                prefixIcon: Icons.account_balance_wallet_rounded,
                items: widget.accounts.map((acc) {
                  return AppDropdownItem<String>(
                    value: acc.id,
                    label: acc.name,
                    subtitle:
                        'Balance: ${context.currencySymbol}${acc.balance.toStringAsFixed(0)}',
                    icon: Icons.account_balance_wallet_rounded,
                    iconColor: AppColors.secondary,
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _toAccountId = val;
                  });
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _amountController,
                label: 'Transfer Amount',
                hintText: '5000',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Enter transfer amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              AppButton(
                text: 'Confirm Transfer',
                onPressed: _onTransfer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
