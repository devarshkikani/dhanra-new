import 'package:dhanra_new/features/goals/domain/entities/goal_contribution_entity.dart';

class GoalContributionModel extends GoalContributionEntity {
  const GoalContributionModel({
    required super.id,
    required super.goalId,
    required super.amount,
    required super.accountId,
    required super.accountName,
    required super.date,
    super.notes,
    super.createdAt,
  });

  factory GoalContributionModel.fromEntity(GoalContributionEntity entity) {
    return GoalContributionModel(
      id: entity.id,
      goalId: entity.goalId,
      amount: entity.amount,
      accountId: entity.accountId,
      accountName: entity.accountName,
      date: entity.date,
      notes: entity.notes,
      createdAt: entity.createdAt,
    );
  }

  factory GoalContributionModel.fromJson(Map<String, dynamic> json) {
    return GoalContributionModel(
      id: json['id'] as String? ?? '',
      goalId: json['goalId'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      accountId: json['accountId'] as String? ?? '',
      accountName: json['accountName'] as String? ?? '',
      date: json['date'] != null
          ? DateTime.tryParse(json['date'] as String) ?? DateTime.now()
          : DateTime.now(),
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'goalId': goalId,
      'amount': amount,
      'accountId': accountId,
      'accountName': accountName,
      'date': date.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
