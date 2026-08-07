import 'package:dhanra_new/features/goals/domain/entities/goal_entity.dart';

class GoalModel extends GoalEntity {
  const GoalModel({
    required super.id,
    required super.title,
    required super.targetAmount,
    required super.deadline,
    super.currentAmount = 0.0,
    super.iconName = 'savings',
    super.colorHex = '#00F5D4',
    super.isCompleted = false,
    super.createdAt,
  });

  factory GoalModel.fromEntity(GoalEntity entity) {
    return GoalModel(
      id: entity.id,
      title: entity.title,
      targetAmount: entity.targetAmount,
      currentAmount: entity.currentAmount,
      deadline: entity.deadline,
      iconName: entity.iconName,
      colorHex: entity.colorHex,
      isCompleted: entity.isCompleted,
      createdAt: entity.createdAt,
    );
  }

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      targetAmount: (json['targetAmount'] as num?)?.toDouble() ?? 0.0,
      currentAmount: (json['currentAmount'] as num?)?.toDouble() ?? 0.0,
      deadline: json['deadline'] != null
          ? DateTime.tryParse(json['deadline'] as String) ?? DateTime.now()
          : DateTime.now(),
      iconName: json['iconName'] as String? ?? 'savings',
      colorHex: json['colorHex'] as String? ?? '#00F5D4',
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'deadline': deadline.toIso8601String(),
      'iconName': iconName,
      'colorHex': colorHex,
      'isCompleted': isCompleted,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
