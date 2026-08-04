import 'package:equatable/equatable.dart';

enum TransactionType {
  expense,
  income,
  transfer,
}

extension TransactionTypeX on TransactionType {
  String get displayName {
    switch (this) {
      case TransactionType.expense:
        return 'Expense';
      case TransactionType.income:
        return 'Income';
      case TransactionType.transfer:
        return 'Transfer';
    }
  }
}

class TransactionEntity extends Equatable {
  const TransactionEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
    required this.accountId,
    required this.accountName,
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
    this.toAccountId,
    this.toAccountName,
    this.notes,
    this.tags = const [],
    this.attachmentPath,
    this.createdAt,
  });

  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final DateTime date;
  final String accountId;
  final String accountName;
  final String categoryId;
  final String categoryName;
  final String categoryIcon;
  final String categoryColor;
  final String? toAccountId;
  final String? toAccountName;
  final String? notes;
  final List<String> tags;
  final String? attachmentPath;
  final DateTime? createdAt;

  TransactionEntity copyWith({
    String? id,
    String? title,
    double? amount,
    TransactionType? type,
    DateTime? date,
    String? accountId,
    String? accountName,
    String? categoryId,
    String? categoryName,
    String? categoryIcon,
    String? categoryColor,
    String? toAccountId,
    String? toAccountName,
    String? notes,
    List<String>? tags,
    String? attachmentPath,
    DateTime? createdAt,
  }) {
    return TransactionEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      date: date ?? this.date,
      accountId: accountId ?? this.accountId,
      accountName: accountName ?? this.accountName,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      categoryIcon: categoryIcon ?? this.categoryIcon,
      categoryColor: categoryColor ?? this.categoryColor,
      toAccountId: toAccountId ?? this.toAccountId,
      toAccountName: toAccountName ?? this.toAccountName,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      attachmentPath: attachmentPath ?? this.attachmentPath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        amount,
        type,
        date,
        accountId,
        accountName,
        categoryId,
        categoryName,
        categoryIcon,
        categoryColor,
        toAccountId,
        toAccountName,
        notes,
        tags,
        attachmentPath,
        createdAt,
      ];
}
