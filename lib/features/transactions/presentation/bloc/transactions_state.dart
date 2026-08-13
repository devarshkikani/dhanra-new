import 'package:dhanra_new/features/categories/domain/entities/category_entity.dart';
import 'package:dhanra_new/features/transactions/domain/entities/transaction_entity.dart';
import 'package:equatable/equatable.dart';

abstract class TransactionsState extends Equatable {
  const TransactionsState();

  @override
  List<Object?> get props => [];
}

class TransactionsInitialState extends TransactionsState {
  const TransactionsInitialState();
}

class TransactionsLoadingState extends TransactionsState {
  const TransactionsLoadingState();
}

class TransactionsLoadedState extends TransactionsState {
  const TransactionsLoadedState({
    required this.allTransactions,
    this.categories = const [],
    this.selectedFilter = 'ALL',
    this.searchQuery = '',
    this.selectedAccountId,
    this.selectedCategoryId,
    this.sortBy = 'NEWEST',
  });

  final List<TransactionEntity> allTransactions;
  final List<CategoryEntity> categories;
  final String selectedFilter; // 'ALL', 'EXPENSE', 'INCOME', 'TRANSFER'
  final String searchQuery;
  final String? selectedAccountId;
  final String? selectedCategoryId;
  final String sortBy; // 'NEWEST', 'OLDEST', 'HIGHEST', 'LOWEST'

  bool get hasActiveFilters =>
      selectedFilter != 'ALL' ||
      selectedAccountId != null ||
      selectedCategoryId != null ||
      sortBy != 'NEWEST';

  List<TransactionEntity> get filteredTransactions {
    final list = allTransactions.where((t) {
      bool matchesType = true;
      if (selectedFilter == 'EXPENSE') {
        matchesType = t.type == TransactionType.expense;
      } else if (selectedFilter == 'INCOME') {
        matchesType = t.type == TransactionType.income;
      } else if (selectedFilter == 'TRANSFER') {
        matchesType = t.type == TransactionType.transfer;
      }

      final matchesAccount =
          selectedAccountId == null || t.accountId == selectedAccountId;

      bool matchesCategory = true;
      if (selectedCategoryId != null && selectedCategoryId!.isNotEmpty) {
        final matchingCategoryIds = <String>{selectedCategoryId!};
        CategoryEntity? selectedCatObj;

        for (final cat in categories) {
          if (cat.id == selectedCategoryId) {
            selectedCatObj = cat;
          }
          if (cat.parentId == selectedCategoryId) {
            matchingCategoryIds.add(cat.id);
          }
        }

        matchesCategory = matchingCategoryIds.contains(t.categoryId) ||
            t.categoryId == selectedCategoryId ||
            (selectedCatObj != null &&
                selectedCatObj.name.isNotEmpty &&
                t.categoryName.toLowerCase() ==
                    selectedCatObj.name.toLowerCase());
      }

      final matchesSearch = searchQuery.isEmpty ||
          t.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          (t.notes != null &&
              t.notes!.toLowerCase().contains(searchQuery.toLowerCase())) ||
          t.categoryName.toLowerCase().contains(searchQuery.toLowerCase());

      return matchesType && matchesAccount && matchesCategory && matchesSearch;
    }).toList();

    if (sortBy == 'OLDEST') {
      list.sort((a, b) => a.date.compareTo(b.date));
    } else if (sortBy == 'HIGHEST') {
      list.sort((a, b) => b.amount.compareTo(a.amount));
    } else if (sortBy == 'LOWEST') {
      list.sort((a, b) => a.amount.compareTo(b.amount));
    } else {
      list.sort((a, b) => b.date.compareTo(a.date));
    }

    return list;
  }

  Map<String, List<TransactionEntity>> get groupedByDate {
    final Map<String, List<TransactionEntity>> map = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (final tx in filteredTransactions) {
      final txDate = DateTime(tx.date.year, tx.date.month, tx.date.day);
      String dateHeader;

      if (txDate.isAtSameMomentAs(today)) {
        dateHeader = 'Today';
      } else if (txDate.isAtSameMomentAs(yesterday)) {
        dateHeader = 'Yesterday';
      } else {
        dateHeader =
            '${tx.date.day.toString().padLeft(2, '0')} ${_monthAbbrev(tx.date.month)} ${tx.date.year}';
      }

      map.putIfAbsent(dateHeader, () => []).add(tx);
    }
    return map;
  }

  String _monthAbbrev(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[(month - 1).clamp(0, 11)];
  }

  TransactionsLoadedState copyWith({
    List<TransactionEntity>? allTransactions,
    List<CategoryEntity>? categories,
    String? selectedFilter,
    String? searchQuery,
    bool clearAccountId = false,
    String? selectedAccountId,
    bool clearCategoryId = false,
    String? selectedCategoryId,
    String? sortBy,
  }) {
    return TransactionsLoadedState(
      allTransactions: allTransactions ?? this.allTransactions,
      categories: categories ?? this.categories,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedAccountId: clearAccountId
          ? null
          : (selectedAccountId ?? this.selectedAccountId),
      selectedCategoryId: clearCategoryId
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
      sortBy: sortBy ?? this.sortBy,
    );
  }

  @override
  List<Object?> get props => [
        allTransactions,
        categories,
        selectedFilter,
        searchQuery,
        selectedAccountId,
        selectedCategoryId,
        sortBy,
      ];
}

class TransactionsErrorState extends TransactionsState {
  const TransactionsErrorState(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
