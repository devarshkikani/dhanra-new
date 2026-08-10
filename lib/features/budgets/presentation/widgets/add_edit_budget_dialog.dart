import 'package:dhanra_new/core/common_widgets/app_button.dart';
import 'package:dhanra_new/core/common_widgets/app_text_field.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/currency_extension.dart';
import 'package:dhanra_new/features/budgets/domain/entities/budget_entity.dart';
import 'package:dhanra_new/features/categories/domain/entities/category_entity.dart';
import 'package:flutter/material.dart';

enum BudgetDialogMode {
  categoryBudget,
  totalMonthlyLimit,
}

class AddEditBudgetDialog extends StatefulWidget {
  const AddEditBudgetDialog({
    required this.categories,
    super.key,
    this.budget,
    this.mode = BudgetDialogMode.categoryBudget,
    this.currentTotalLimit = 60000.0,
  });

  final BudgetEntity? budget;
  final List<CategoryEntity> categories;
  final BudgetDialogMode mode;
  final double currentTotalLimit;

  @override
  State<AddEditBudgetDialog> createState() => _AddEditBudgetDialogState();
}

class _AddEditBudgetDialogState extends State<AddEditBudgetDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _limitController;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    final isTotal = widget.mode == BudgetDialogMode.totalMonthlyLimit;
    _limitController = TextEditingController(
      text: isTotal
          ? widget.currentTotalLimit.toStringAsFixed(0)
          : (widget.budget != null
              ? widget.budget!.limitAmount.toStringAsFixed(0)
              : ''),
    );

    if (widget.categories.isNotEmpty) {
      _selectedCategoryId =
          widget.budget?.categoryId ?? widget.categories.first.id;
    }
  }

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final amount = double.tryParse(_limitController.text.trim()) ?? 0.0;

      if (widget.mode == BudgetDialogMode.totalMonthlyLimit) {
        Navigator.of(context).pop({'totalLimit': amount});
        return;
      }

      if (_selectedCategoryId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a category.')),
        );
        return;
      }

      final matchingCats =
          widget.categories.where((c) => c.id == _selectedCategoryId);
      if (matchingCats.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a valid category.')),
        );
        return;
      }
      final category = matchingCats.first;

      final budgetToReturn = BudgetEntity(
        id: widget.budget?.id ?? 'b_${DateTime.now().millisecondsSinceEpoch}',
        categoryId: category.id,
        categoryName: category.name,
        categoryIcon: category.iconName,
        categoryColor: category.colorHex,
        limitAmount: amount,
        spentAmount: widget.budget?.spentAmount ?? 0.0,
        createdAt: widget.budget?.createdAt ?? DateTime.now(),
      );

      Navigator.of(context).pop({'categoryBudget': budgetToReturn});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTotalMode = widget.mode == BudgetDialogMode.totalMonthlyLimit;
    final isEditing = widget.budget != null;

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
                      isTotalMode
                          ? 'Edit Monthly Budget Limit'
                          : (isEditing
                              ? 'Edit Category Budget'
                              : 'Set Category Budget Cap'),
                      style: const TextStyle(
                        fontSize: 18,
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
                if (!isTotalMode) ...[
                  const Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategoryId,
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
                    items: widget.categories.map((cat) {
                      return DropdownMenuItem(
                        value: cat.id,
                        child: Text(cat.name),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedCategoryId = val;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                AppTextField(
                  controller: _limitController,
                  label: isTotalMode
                      ? 'Total Monthly Budget Limit (${context.currencySymbol})'
                      : 'Category Budget Cap (${context.currencySymbol})',
                  hintText: 'e.g. 15000',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty)
                      return 'Enter budget amount';
                    final numVal = double.tryParse(val.trim());
                    if (numVal == null || numVal <= 0)
                      return 'Enter valid positive amount';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                AppButton(
                  text: 'Save Budget',
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
