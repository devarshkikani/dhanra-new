import 'package:dhanra_new/core/common_widgets/app_button.dart';
import 'package:dhanra_new/core/common_widgets/app_text_field.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/features/accounts/domain/entities/account_entity.dart';
import 'package:dhanra_new/features/goals/domain/entities/goal_contribution_entity.dart';
import 'package:dhanra_new/features/goals/domain/entities/goal_entity.dart';
import 'package:flutter/material.dart';

class AddContributionDialog extends StatefulWidget {
  const AddContributionDialog({
    required this.goal,
    required this.accounts,
    super.key,
  });

  final GoalEntity goal;
  final List<AccountEntity> accounts;

  @override
  State<AddContributionDialog> createState() => _AddContributionDialogState();
}

class _AddContributionDialogState extends State<AddContributionDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _notesController;
  String? _selectedAccountId;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _notesController = TextEditingController();

    if (widget.accounts.isNotEmpty) {
      _selectedAccountId = widget.accounts.first.id;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedAccountId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a funding account.')),
        );
        return;
      }

      final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
      final notes = _notesController.text.trim();
      final account =
          widget.accounts.firstWhere((a) => a.id == _selectedAccountId);

      final contribution = GoalContributionEntity(
        id: 'gc_${DateTime.now().millisecondsSinceEpoch}',
        goalId: widget.goal.id,
        amount: amount,
        accountId: account.id,
        accountName: account.name,
        date: DateTime.now(),
        notes: notes.isNotEmpty ? notes : null,
        createdAt: DateTime.now(),
      );

      Navigator.of(context).pop(contribution);
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Deposit Savings Contribution',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'For "${widget.goal.title}" (Remaining: ₹${widget.goal.remainingAmount.toStringAsFixed(0)})',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
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
                  controller: _amountController,
                  label: 'Deposit Amount (₹)',
                  hintText: 'e.g. 10000',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty)
                      return 'Enter deposit amount';
                    final numVal = double.tryParse(val.trim());
                    if (numVal == null || numVal <= 0)
                      return 'Enter valid amount';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Source Funding Account',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _selectedAccountId,
                  dropdownColor: AppColors.darkCard,
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 15),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.inputBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: AppColors.inputBorder),
                    ),
                  ),
                  items: widget.accounts.map((acc) {
                    return DropdownMenuItem(
                      value: acc.id,
                      child: Text(
                          '${acc.name} (₹${acc.balance.toStringAsFixed(0)})'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedAccountId = val;
                    });
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _notesController,
                  label: 'Notes (Optional)',
                  hintText: 'e.g. August savings deposit',
                ),
                const SizedBox(height: 24),
                AppButton(
                  text: 'Deposit Funds',
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
