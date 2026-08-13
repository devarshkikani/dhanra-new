import 'package:dhanra_new/core/common_widgets/app_button.dart';
import 'package:dhanra_new/core/di/injection.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/utils/icon_color_utils.dart';
import 'package:dhanra_new/features/accounts/domain/entities/account_entity.dart';
import 'package:dhanra_new/features/accounts/domain/usecases/get_accounts_usecase.dart';
import 'package:dhanra_new/features/categories/domain/entities/category_entity.dart';
import 'package:dhanra_new/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:flutter/material.dart';

class TransactionFilterResult {
  const TransactionFilterResult({
    required this.selectedFilter,
    required this.sortBy,
    this.selectedAccountId,
    this.selectedCategoryId,
  });

  final String selectedFilter;
  final String? selectedAccountId;
  final String? selectedCategoryId;
  final String sortBy;
}

class TransactionFilterBottomSheet extends StatefulWidget {
  const TransactionFilterBottomSheet({
    required this.initialFilter,
    required this.initialSortBy,
    super.key,
    this.initialAccountId,
    this.initialCategoryId,
  });

  final String initialFilter;
  final String? initialAccountId;
  final String? initialCategoryId;
  final String initialSortBy;

  @override
  State<TransactionFilterBottomSheet> createState() =>
      _TransactionFilterBottomSheetState();
}

class _TransactionFilterBottomSheetState
    extends State<TransactionFilterBottomSheet> {
  late String _selectedFilter;
  late String _selectedSortBy;
  String? _selectedAccountId;
  String? _selectedCategoryId;

  List<AccountEntity> _accounts = [];
  List<CategoryEntity> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialFilter;
    _selectedSortBy = widget.initialSortBy;
    _selectedAccountId = widget.initialAccountId;
    _selectedCategoryId = widget.initialCategoryId;
    _loadMetadata();
  }

  Future<void> _loadMetadata() async {
    try {
      final fetchedAccounts = await getIt<GetAccountsUseCase>().call();
      final fetchedCategories = await getIt<GetCategoriesUseCase>().call();

      if (!mounted) return;
      setState(() {
        _accounts = fetchedAccounts;
        _categories = fetchedCategories;
        _isLoading = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _resetFilters() {
    setState(() {
      _selectedFilter = 'ALL';
      _selectedSortBy = 'NEWEST';
      _selectedAccountId = null;
      _selectedCategoryId = null;
    });
  }

  void _applyFilters() {
    Navigator.of(context).pop(
      TransactionFilterResult(
        selectedFilter: _selectedFilter,
        selectedAccountId: _selectedAccountId,
        selectedCategoryId: _selectedCategoryId,
        sortBy: _selectedSortBy,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.inputBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter Transactions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: _resetFilters,
                child: const Text(
                  'Reset All',
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(AppColors.primary),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Transaction Type Section
                        const Text(
                          'Transaction Type',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildFilterChip('ALL', 'All'),
                            const SizedBox(width: 8),
                            _buildFilterChip('EXPENSE', 'Expense'),
                            const SizedBox(width: 8),
                            _buildFilterChip('INCOME', 'Income'),
                            const SizedBox(width: 8),
                            _buildFilterChip('TRANSFER', 'Transfer'),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // 2. Sort By Section
                        const Text(
                          'Sort By',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildSortChip('NEWEST', 'Latest First'),
                            _buildSortChip('OLDEST', 'Oldest First'),
                            _buildSortChip('HIGHEST', 'Highest Amount'),
                            _buildSortChip('LOWEST', 'Lowest Amount'),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // 3. Filter by Account
                        const Text(
                          'Filter by Account',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 48,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildAccountChip(null, 'All Accounts',
                                  Icons.all_inbox_rounded, AppColors.primary),
                              ..._accounts.map((acc) {
                                final color =
                                    IconColorUtils.parseHexColor(acc.colorHex);
                                final icon = IconColorUtils.getAccountIconData(
                                    acc.iconName, acc.type);
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: _buildAccountChip(
                                      acc.id, acc.name, icon, color),
                                );
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 4. Filter by Category
                        const Text(
                          'Filter by Category',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 48,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildCategoryChip(null, 'All Categories',
                                  Icons.category_rounded, AppColors.secondary),
                              ..._categories
                                  .where((c) => !c.isSubCategory)
                                  .map((cat) {
                                final color =
                                    IconColorUtils.parseHexColor(cat.colorHex);
                                final icon = IconColorUtils.getCategoryIconData(
                                    cat.iconName);
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: _buildCategoryChip(
                                      cat.id, cat.name, icon, color),
                                );
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
          ),

          // Apply Button
          AppButton(
            text: 'Apply Filters',
            onPressed: _applyFilters,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _selectedFilter == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.2)
                : AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.inputBorder,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSortChip(String value, String label) {
    final isSelected = _selectedSortBy == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSortBy = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.secondary.withValues(alpha: 0.2)
              : AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.secondary : AppColors.inputBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? AppColors.secondary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildAccountChip(
      String? id, String name, IconData icon, Color color) {
    final isSelected = _selectedAccountId == id;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAccountId = id;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected ? color.withValues(alpha: 0.18) : AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : AppColors.inputBorder,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? color : AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(
      String? id, String name, IconData icon, Color color) {
    final isSelected = _selectedCategoryId == id;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryId = id;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected ? color.withValues(alpha: 0.18) : AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : AppColors.inputBorder,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? color : AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
