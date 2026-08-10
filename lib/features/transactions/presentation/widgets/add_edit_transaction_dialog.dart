import 'package:dhanra_new/core/common_widgets/app_button.dart';
import 'package:dhanra_new/core/common_widgets/app_text_field.dart';
import 'package:dhanra_new/core/di/injection.dart';
import 'package:dhanra_new/core/router/app_router.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/currency_extension.dart';
import 'package:dhanra_new/features/accounts/domain/entities/account_entity.dart';
import 'package:dhanra_new/features/accounts/domain/usecases/get_accounts_usecase.dart';
import 'package:dhanra_new/features/categories/domain/entities/category_entity.dart';
import 'package:dhanra_new/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:dhanra_new/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddEditTransactionDialog extends StatefulWidget {
  const AddEditTransactionDialog({
    super.key,
    this.accounts,
    this.categories,
    this.transaction,
    this.initialType,
  });

  final TransactionEntity? transaction;
  final List<AccountEntity>? accounts;
  final List<CategoryEntity>? categories;
  final TransactionType? initialType;

  @override
  State<AddEditTransactionDialog> createState() =>
      _AddEditTransactionDialogState();
}

class _AddEditTransactionDialogState extends State<AddEditTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _notesController;
  late TextEditingController _attachmentController;

  late TransactionType _selectedType;
  late DateTime _selectedDate;
  String? _selectedAccountId;
  String? _selectedCategoryId;

  List<AccountEntity> _accounts = [];
  List<CategoryEntity> _categories = [];
  bool _isLoadingData = false;

  @override
  void initState() {
    super.initState();
    final tx = widget.transaction;
    _titleController = TextEditingController(text: tx?.title ?? '');
    _amountController = TextEditingController(
      text: tx != null ? tx.amount.toStringAsFixed(0) : '',
    );
    _notesController = TextEditingController(text: tx?.notes ?? '');
    _attachmentController =
        TextEditingController(text: tx?.attachmentPath ?? '');

    _selectedType = tx?.type ?? widget.initialType ?? TransactionType.expense;
    _selectedDate = tx?.date ?? DateTime.now();

    if (widget.accounts != null && widget.categories != null) {
      _accounts = List<AccountEntity>.from(widget.accounts!);
      _categories = List<CategoryEntity>.from(widget.categories!);
      _initSelections();
    } else {
      _accounts = widget.accounts != null
          ? List<AccountEntity>.from(widget.accounts!)
          : [];
      _categories = widget.categories != null
          ? List<CategoryEntity>.from(widget.categories!)
          : [];
      _isLoadingData = true;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    final fetchedAccounts =
        widget.accounts ?? await getIt<GetAccountsUseCase>().call();
    final fetchedCategories =
        widget.categories ?? await getIt<GetCategoriesUseCase>().call();

    if (!mounted) return;

    setState(() {
      _accounts = List<AccountEntity>.from(fetchedAccounts);
      _categories = List<CategoryEntity>.from(fetchedCategories);
      _isLoadingData = false;
      _initSelections();
    });
  }

  void _initSelections() {
    final tx = widget.transaction;
    if (_accounts.isNotEmpty && _selectedAccountId == null) {
      _selectedAccountId = tx?.accountId ?? _accounts.first.id;
    }

    final filteredCats = _categories
        .where((c) =>
            c.type ==
            (_selectedType == TransactionType.income
                ? CategoryType.income
                : CategoryType.expense))
        .toList();

    if (filteredCats.isNotEmpty && _selectedCategoryId == null) {
      _selectedCategoryId = tx?.categoryId ?? filteredCats.first.id;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    _attachmentController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedAccountId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an account.')),
        );
        return;
      }

      final title = _titleController.text.trim();
      final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
      final notes = _notesController.text.trim();
      final attachment = _attachmentController.text.trim();

      final matchingAccounts =
          _accounts.where((a) => a.id == _selectedAccountId);
      if (matchingAccounts.isEmpty && _accounts.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please select or create an account first.')),
        );
        return;
      }
      final account = matchingAccounts.isNotEmpty
          ? matchingAccounts.first
          : _accounts.first;

      CategoryEntity? category;
      if (_selectedCategoryId != null) {
        final matchingCats =
            _categories.where((c) => c.id == _selectedCategoryId);
        if (matchingCats.isNotEmpty) {
          category = matchingCats.first;
        } else if (_categories.isNotEmpty) {
          category = _categories.first;
        }
      } else if (_categories.isNotEmpty) {
        category = _categories.first;
      }

      final txToReturn = TransactionEntity(
        id: widget.transaction?.id ??
            'tx_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        amount: amount,
        type: _selectedType,
        date: _selectedDate,
        accountId: account.id,
        accountName: account.name,
        categoryId: category?.id ?? 'cat_general',
        categoryName: category?.name ?? 'General',
        categoryIcon: category?.iconName ?? 'receipt_long',
        categoryColor: category?.colorHex ?? '#9B5DE5',
        notes: notes.isNotEmpty ? notes : null,
        attachmentPath: attachment.isNotEmpty ? attachment : null,
        createdAt: widget.transaction?.createdAt ?? DateTime.now(),
      );

      Navigator.of(context).pop(txToReturn);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.darkCard,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transaction != null;
    final filteredCategories = _categories
        .where((c) =>
            c.type ==
            (_selectedType == TransactionType.income
                ? CategoryType.income
                : CategoryType.expense))
        .toList();

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
                      isEditing ? 'Edit Transaction' : 'Add New Transaction',
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

                if (_isLoadingData) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    ),
                  ),
                ] else ...[
                  // 1. Transaction Type Toggle
                  Row(
                    children: TransactionType.values.map((type) {
                      final isSelected = _selectedType == type;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedType = type;
                              final cats = _categories
                                  .where((c) =>
                                      c.type ==
                                      (type == TransactionType.income
                                          ? CategoryType.income
                                          : CategoryType.expense))
                                  .toList();
                              if (cats.isNotEmpty) {
                                _selectedCategoryId = cats.first.id;
                              }
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.inputBackground,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                type.displayName,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // 2. Title & Amount
                  AppTextField(
                    controller: _titleController,
                    label: 'Title',
                    hintText: 'e.g. Starbucks Coffee',
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Enter transaction title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _amountController,
                    label: 'Amount (${context.currencySymbol})',
                    hintText: '450',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Enter amount';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // 3. Account Dropdown
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Account',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary),
                      ),
                      GestureDetector(
                        onTap: () => context.push(AppRoutes.accounts),
                        child: const Text(
                          '+ Add Account',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (_accounts.isEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.warning.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline_rounded,
                              color: AppColors.warning, size: 20),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'No accounts available.',
                              style: TextStyle(
                                  color: AppColors.textPrimary, fontSize: 13),
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.push(AppRoutes.accounts),
                            child: const Text('Create Now',
                                style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
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
                      items: _accounts.map((acc) {
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
                  ],
                  const SizedBox(height: 16),

                  // 4. Category Dropdown
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Category',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary),
                      ),
                      GestureDetector(
                        onTap: () => context.push(AppRoutes.categories),
                        child: const Text(
                          '⚙️ Manage',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                    ],
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
                    items: filteredCategories.map((cat) {
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

                  // 5. Date Picker Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Transaction Date',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary),
                      ),
                      TextButton.icon(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.calendar_today_rounded,
                            size: 18, color: AppColors.secondary),
                        label: Text(
                          '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                          style: const TextStyle(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 6. Notes & Optional Attachment
                  AppTextField(
                    controller: _notesController,
                    label: 'Notes (Optional)',
                    hintText: 'e.g. Coffee with team',
                  ),
                  const SizedBox(height: 24),

                  AppButton(
                    text:
                        isEditing ? 'Save Transaction' : 'Create Transaction',
                    onPressed: _onSave,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
