import 'package:dhanra_new/core/common_widgets/app_button.dart';
import 'package:dhanra_new/core/common_widgets/app_dropdown.dart';
import 'package:dhanra_new/core/common_widgets/app_tab_bar.dart';
import 'package:dhanra_new/core/common_widgets/app_text_field.dart';
import 'package:dhanra_new/core/di/injection.dart';
import 'package:dhanra_new/core/router/app_router.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/currency_extension.dart';
import 'package:dhanra_new/core/widgets/widgets.dart' hide AppButton, AppTextField;
import 'package:dhanra_new/features/accounts/domain/entities/account_entity.dart';
import 'package:dhanra_new/features/accounts/domain/usecases/get_accounts_usecase.dart';
import 'package:dhanra_new/features/categories/domain/entities/category_entity.dart';
import 'package:dhanra_new/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:dhanra_new/features/transactions/domain/entities/transaction_entity.dart';
import 'package:dhanra_new/features/transactions/domain/usecases/create_transaction_usecase.dart';
import 'package:dhanra_new/features/transactions/domain/usecases/delete_transaction_usecase.dart';
import 'package:dhanra_new/features/transactions/domain/usecases/update_transaction_usecase.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddEditTransactionPage extends StatefulWidget {
  const AddEditTransactionPage({
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
  State<AddEditTransactionPage> createState() => _AddEditTransactionPageState();
}

class _AddEditTransactionPageState extends State<AddEditTransactionPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _notesController;
  late TabController _tabController;

  late TransactionType _selectedType;
  late DateTime _selectedDate;
  String? _selectedAccountId;
  String? _selectedCategoryId;

  List<AccountEntity> _accounts = [];
  List<CategoryEntity> _categories = [];
  bool _isLoadingData = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final tx = widget.transaction;
    _titleController = TextEditingController(text: tx?.title ?? '');
    _amountController = TextEditingController(
      text: tx != null ? tx.amount.toStringAsFixed(0) : '',
    );
    _notesController = TextEditingController(text: tx?.notes ?? '');

    _selectedType = tx?.type ?? widget.initialType ?? TransactionType.expense;
    _selectedDate = tx?.date ?? DateTime.now();

    final tabIndex = _selectedType == TransactionType.expense
        ? 0
        : (_selectedType == TransactionType.income ? 1 : 2);
    _tabController = TabController(length: 3, vsync: this, initialIndex: tabIndex);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      final newType = TransactionType.values[_tabController.index];
      if (newType != _selectedType) {
        setState(() {
          _selectedType = newType;
          final cats = _categories
              .where((c) =>
                  c.type ==
                  (newType == TransactionType.income
                      ? CategoryType.income
                      : CategoryType.expense))
              .toList();
          if (cats.isNotEmpty) {
            _selectedCategoryId = cats.first.id;
          }
        });
      }
    });

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
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedAccountId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an account.')),
        );
        return;
      }

      setState(() {
        _isSaving = true;
      });

      final title = _titleController.text.trim();
      final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
      final notes = _notesController.text.trim();

      final matchingAccounts =
          _accounts.where((a) => a.id == _selectedAccountId);
      if (matchingAccounts.isEmpty && _accounts.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please select or create an account first.')),
        );
        setState(() {
          _isSaving = false;
        });
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

      final txToSave = TransactionEntity(
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
        createdAt: widget.transaction?.createdAt ?? DateTime.now(),
      );

      if (widget.transaction != null) {
        await getIt<UpdateTransactionUseCase>().call(txToSave);
      } else {
        await getIt<CreateTransactionUseCase>().call(txToSave);
      }

      if (mounted) {
        Navigator.of(context).pop(txToSave);
      }
    }
  }

  Future<void> _onDelete() async {
    final tx = widget.transaction;
    if (tx == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Delete Transaction',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${tx.title}" (${context.currencySymbol}${tx.amount.toStringAsFixed(0)})?',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await getIt<DeleteTransactionUseCase>().call(tx.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction deleted successfully.')),
        );
        Navigator.of(context).pop('DELETED');
      }
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

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppAppBar(
          title: isEditing ? 'Edit Transaction' : 'Add Transaction',
        ),
        body: SafeArea(
          child: _isLoadingData
              ? const AppLoading(message: 'Loading transaction data...')
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Segmented Type Selector
                        AppSegmentedTabBar(
                          controller: _tabController,
                          tabs: const [
                            Tab(text: 'Expense'),
                            Tab(text: 'Income'),
                            Tab(text: 'Transfer'),
                          ],
                        ),
                        const SizedBox(height: 20),

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
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Enter amount';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // 3. Account Selector
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
                                  color: AppColors.warning
                                      .withValues(alpha: 0.3)),
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
                                        color: AppColors.textPrimary,
                                        fontSize: 13),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      context.push(AppRoutes.accounts),
                                  child: const Text('Create Now',
                                      style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          AppDropdown<String>(
                            value: _selectedAccountId,
                            prefixIcon: Icons.account_balance_wallet_rounded,
                            items: _accounts.map((acc) {
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
                                _selectedAccountId = val;
                              });
                            },
                          ),
                        ],
                        const SizedBox(height: 16),

                        // 4. Category Selector
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
                        AppDropdown<String>(
                          value: _selectedCategoryId,
                          prefixIcon: Icons.category_rounded,
                          items: filteredCategories.map((cat) {
                            return AppDropdownItem<String>(
                              value: cat.id,
                              label: cat.name,
                              icon: Icons.pie_chart_rounded,
                              iconColor: AppColors.secondary,
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

                        // 6. Notes
                        AppTextField(
                          controller: _notesController,
                          label: 'Notes (Optional)',
                          hintText: 'e.g. Coffee with team',
                        ),
                        const SizedBox(height: 32),

                        // 7. Save / Update Button
                        AppButton(
                          text: isEditing
                              ? 'Update Transaction'
                              : 'Create Transaction',
                          isLoading: _isSaving,
                          onPressed: _onSave,
                        ),

                        // 8. Delete Button (when editing)
                        if (isEditing) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.error,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _onDelete,
                              icon: const Icon(Icons.delete_outline_rounded,
                                  color: Colors.white),
                              label: const Text(
                                'Delete Transaction',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
