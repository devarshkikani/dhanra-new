import 'package:dhanra_new/core/common_widgets/app_button.dart';
import 'package:dhanra_new/core/common_widgets/app_text_field.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/features/accounts/domain/entities/account_entity.dart';
import 'package:flutter/material.dart';

class AddEditAccountDialog extends StatefulWidget {
  const AddEditAccountDialog({
    super.key,
    this.account,
  });

  final AccountEntity? account;

  @override
  State<AddEditAccountDialog> createState() => _AddEditAccountDialogState();
}

class _AddEditAccountDialogState extends State<AddEditAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _balanceController;
  late TextEditingController _last4Controller;
  late TextEditingController _creditLimitController;

  late AccountType _selectedType;
  late String _selectedColorHex;

  final List<String> _colorOptions = [
    '#9B5DE5', // Poli Purple
    '#00F5D4', // Mint Cyan
    '#FFA500', // Orange Sunshine
    '#00C853', // Emerald Green
    '#448AFF', // Info Blue
    '#FF5252', // Coral Red
  ];

  @override
  void initState() {
    super.initState();
    final acc = widget.account;
    _nameController = TextEditingController(text: acc?.name ?? '');
    _balanceController = TextEditingController(
      text: acc != null ? acc.balance.toStringAsFixed(0) : '',
    );
    _last4Controller =
        TextEditingController(text: acc?.accountNumberLast4 ?? '');
    _creditLimitController = TextEditingController(
      text: (acc != null && acc.creditLimit != null)
          ? acc.creditLimit!.toStringAsFixed(0)
          : '',
    );

    _selectedType = acc?.type ?? AccountType.bank;
    _selectedColorHex = acc?.colorHex ?? _colorOptions.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _last4Controller.dispose();
    _creditLimitController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final balance = double.tryParse(_balanceController.text.trim()) ?? 0.0;
      final last4 = _last4Controller.text.trim();
      final creditLimit = double.tryParse(_creditLimitController.text.trim());

      final accountToReturn = AccountEntity(
        id: widget.account?.id ??
            'acc_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        type: _selectedType,
        balance: balance,
        currency: 'INR',
        colorHex: _selectedColorHex,
        iconName: _getIconForType(_selectedType),
        accountNumberLast4: last4.isNotEmpty ? last4 : null,
        creditLimit:
            _selectedType == AccountType.creditCard ? creditLimit : null,
        createdAt: widget.account?.createdAt ?? DateTime.now(),
      );

      Navigator.of(context).pop(accountToReturn);
    }
  }

  String _getIconForType(AccountType type) {
    switch (type) {
      case AccountType.bank:
        return 'account_balance';
      case AccountType.wallet:
        return 'account_balance_wallet';
      case AccountType.cash:
        return 'payments';
      case AccountType.creditCard:
        return 'credit_card';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.account != null;

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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEditing ? 'Edit Account' : 'Add New Account',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close,
                          color: AppColors.textSecondary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _nameController,
                  label: 'Account Name',
                  hintText: 'e.g. HDFC Salary Account',
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Enter an account name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Account Type',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: AccountType.values.map((type) {
                    final isSelected = _selectedType == type;
                    return ChoiceChip(
                      label: Text(type.displayName),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedType = type;
                          });
                        }
                      },
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.inputBackground,
                      labelStyle: TextStyle(
                        color:
                            isSelected ? Colors.white : AppColors.textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _balanceController,
                  label: 'Opening / Current Balance',
                  hintText: '25000',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Enter balance';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _last4Controller,
                  label: 'Account Number (Last 4 digits - Optional)',
                  hintText: '4321',
                  keyboardType: TextInputType.number,
                ),
                if (_selectedType == AccountType.creditCard) ...[
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _creditLimitController,
                    label: 'Credit Limit',
                    hintText: '100000',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                ],
                const SizedBox(height: 16),
                const Text(
                  'Account Color Tag',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: _colorOptions.map((hex) {
                    final isSelected = _selectedColorHex == hex;
                    final color = Color(
                        int.parse('ff${hex.replaceFirst('#', '')}', radix: 16));

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColorHex = hex;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Colors.white, width: 2.5)
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                AppButton(
                  text: isEditing ? 'Save Changes' : 'Create Account',
                  onPressed: _onSave,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
