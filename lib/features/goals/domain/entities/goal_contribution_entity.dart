import 'package:equatable/equatable.dart';

class GoalContributionEntity extends Equatable {
  const GoalContributionEntity({
    required this.id,
    required this.goalId,
    required this.amount,
    required this.accountId,
    required this.accountName,
    required this.date,
    this.notes,
    this.createdAt,
  });

  final String id;
  final String goalId;
  final double amount;
  final String accountId;
  final String accountName;
  final DateTime date;
  final String? notes;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [
        id,
        goalId,
        amount,
        accountId,
        accountName,
        date,
        notes,
        createdAt,
      ];
}
