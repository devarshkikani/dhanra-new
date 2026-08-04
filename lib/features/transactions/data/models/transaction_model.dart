import 'package:dhanra_new/features/transactions/domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.type,
    required super.date,
    required super.accountId,
    required super.accountName,
    required super.categoryId,
    required super.categoryName,
    required super.categoryIcon,
    required super.categoryColor,
    super.toAccountId,
    super.toAccountName,
    super.notes,
    super.tags = const [],
    super.attachmentPath,
    super.createdAt,
  });

  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      title: entity.title,
      amount: entity.amount,
      type: entity.type,
      date: entity.date,
      accountId: entity.accountId,
      accountName: entity.accountName,
      categoryId: entity.categoryId,
      categoryName: entity.categoryName,
      categoryIcon: entity.categoryIcon,
      categoryColor: entity.categoryColor,
      toAccountId: entity.toAccountId,
      toAccountName: entity.toAccountName,
      notes: entity.notes,
      tags: entity.tags,
      attachmentPath: entity.attachmentPath,
      createdAt: entity.createdAt,
    );
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      type: TransactionType.values.firstWhere(
        (e) => e.name == (json['type'] as String? ?? 'expense'),
        orElse: () => TransactionType.expense,
      ),
      date: json['date'] != null
          ? DateTime.tryParse(json['date'] as String) ?? DateTime.now()
          : DateTime.now(),
      accountId: json['accountId'] as String? ?? '',
      accountName: json['accountName'] as String? ?? '',
      categoryId: json['categoryId'] as String? ?? '',
      categoryName: json['categoryName'] as String? ?? '',
      categoryIcon: json['categoryIcon'] as String? ?? 'category',
      categoryColor: json['categoryColor'] as String? ?? '#9B5DE5',
      toAccountId: json['toAccountId'] as String?,
      toAccountName: json['toAccountName'] as String?,
      notes: json['notes'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      attachmentPath: json['attachmentPath'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type.name,
      'date': date.toIso8601String(),
      'accountId': accountId,
      'accountName': accountName,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryIcon': categoryIcon,
      'categoryColor': categoryColor,
      'toAccountId': toAccountId,
      'toAccountName': toAccountName,
      'notes': notes,
      'tags': tags,
      'attachmentPath': attachmentPath,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
