import 'package:equatable/equatable.dart';

class GoalEntity extends Equatable {
  const GoalEntity({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.deadline,
    this.currentAmount = 0.0,
    this.iconName = 'savings',
    this.colorHex = '#00F5D4',
    this.isCompleted = false,
    this.createdAt,
  });

  final String id;
  final String title;
  final double targetAmount;
  final double currentAmount;
  final DateTime deadline;
  final String iconName;
  final String colorHex;
  final bool isCompleted;
  final DateTime? createdAt;

  double get remainingAmount =>
      (targetAmount - currentAmount).clamp(0.0, double.infinity);
  double get percentageSaved =>
      targetAmount > 0 ? (currentAmount / targetAmount).clamp(0.0, 1.0) : 0.0;

  double get suggestedMonthlyContribution {
    if (isCompleted || remainingAmount <= 0) return 0.0;
    final now = DateTime.now();
    final monthsLeft =
        ((deadline.year - now.year) * 12 + (deadline.month - now.month))
            .clamp(1, 120);
    return remainingAmount / monthsLeft;
  }

  bool get isOverdue {
    if (isCompleted) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final deadlineDay = DateTime(deadline.year, deadline.month, deadline.day);
    return deadlineDay.isBefore(today);
  }

  GoalEntity copyWith({
    String? id,
    String? title,
    double? targetAmount,
    double? currentAmount,
    DateTime? deadline,
    String? iconName,
    String? colorHex,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return GoalEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      deadline: deadline ?? this.deadline,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        targetAmount,
        currentAmount,
        deadline,
        iconName,
        colorHex,
        isCompleted,
        createdAt,
      ];
}
