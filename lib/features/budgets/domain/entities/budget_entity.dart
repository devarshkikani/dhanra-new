import 'package:equatable/equatable.dart';

enum BudgetStatus {
  safe,
  warning,
  exceeded,
}

extension BudgetStatusX on BudgetStatus {
  String get displayName {
    switch (this) {
      case BudgetStatus.safe:
        return 'Safe';
      case BudgetStatus.warning:
        return 'Near Limit';
      case BudgetStatus.exceeded:
        return 'Exceeded';
    }
  }
}

class BudgetEntity extends Equatable {
  const BudgetEntity({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
    required this.limitAmount,
    this.spentAmount = 0.0,
    this.createdAt,
  });

  final String id;
  final String categoryId;
  final String categoryName;
  final String categoryIcon;
  final String categoryColor;
  final double limitAmount;
  final double spentAmount;
  final DateTime? createdAt;

  double get remainingAmount =>
      (limitAmount - spentAmount).clamp(0, double.infinity);
  double get percentageSpent =>
      limitAmount > 0 ? (spentAmount / limitAmount).clamp(0.0, 1.5) : 0.0;

  BudgetStatus get status {
    final pct = percentageSpent;
    if (pct >= 1.0) return BudgetStatus.exceeded;
    if (pct >= 0.8) return BudgetStatus.warning;
    return BudgetStatus.safe;
  }

  BudgetEntity copyWith({
    String? id,
    String? categoryId,
    String? categoryName,
    String? categoryIcon,
    String? categoryColor,
    double? limitAmount,
    double? spentAmount,
    DateTime? createdAt,
  }) {
    return BudgetEntity(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      categoryIcon: categoryIcon ?? this.categoryIcon,
      categoryColor: categoryColor ?? this.categoryColor,
      limitAmount: limitAmount ?? this.limitAmount,
      spentAmount: spentAmount ?? this.spentAmount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        categoryId,
        categoryName,
        categoryIcon,
        categoryColor,
        limitAmount,
        spentAmount,
        createdAt,
      ];
}
