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
    this.selectedFilter = 'ALL',
    this.searchQuery = '',
  });

  final List<TransactionEntity> allTransactions;
  final String selectedFilter; // 'ALL', 'EXPENSE', 'INCOME', 'TRANSFER'
  final String searchQuery;

  List<TransactionEntity> get filteredTransactions {
    final list = allTransactions.where((t) {
      bool matchesFilter = true;
      if (selectedFilter == 'EXPENSE') {
        matchesFilter = t.type == TransactionType.expense;
      }
      if (selectedFilter == 'INCOME') {
        matchesFilter = t.type == TransactionType.income;
      }
      if (selectedFilter == 'TRANSFER') {
        matchesFilter = t.type == TransactionType.transfer;
      }

      final matchesSearch = searchQuery.isEmpty ||
          t.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          (t.notes != null &&
              t.notes!.toLowerCase().contains(searchQuery.toLowerCase()));

      return matchesFilter && matchesSearch;
    }).toList();

    list.sort((a, b) => b.date.compareTo(a.date));
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
    String? selectedFilter,
    String? searchQuery,
  }) {
    return TransactionsLoadedState(
      allTransactions: allTransactions ?? this.allTransactions,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [allTransactions, selectedFilter, searchQuery];
}

class TransactionsErrorState extends TransactionsState {
  const TransactionsErrorState(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
