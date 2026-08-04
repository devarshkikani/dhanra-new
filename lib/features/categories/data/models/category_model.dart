import 'package:dhanra_new/features/categories/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.type,
    required super.iconName,
    required super.colorHex,
    super.parentId,
    super.isSystemDefault = false,
    super.createdAt,
  });

  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      name: entity.name,
      type: entity.type,
      iconName: entity.iconName,
      colorHex: entity.colorHex,
      parentId: entity.parentId,
      isSystemDefault: entity.isSystemDefault,
      createdAt: entity.createdAt,
    );
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: CategoryType.values.firstWhere(
        (e) => e.name == (json['type'] as String? ?? 'expense'),
        orElse: () => CategoryType.expense,
      ),
      iconName: json['iconName'] as String? ?? 'category',
      colorHex: json['colorHex'] as String? ?? '#9B5DE5',
      parentId: json['parentId'] as String?,
      isSystemDefault: json['isSystemDefault'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'iconName': iconName,
      'colorHex': colorHex,
      'parentId': parentId,
      'isSystemDefault': isSystemDefault,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
