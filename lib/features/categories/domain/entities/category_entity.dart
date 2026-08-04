import 'package:equatable/equatable.dart';

enum CategoryType {
  expense,
  income,
}

extension CategoryTypeX on CategoryType {
  String get displayName {
    switch (this) {
      case CategoryType.expense:
        return 'Expense';
      case CategoryType.income:
        return 'Income';
    }
  }
}

class CategoryEntity extends Equatable {
  const CategoryEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.iconName,
    required this.colorHex,
    this.parentId,
    this.isSystemDefault = false,
    this.createdAt,
  });

  final String id;
  final String name;
  final CategoryType type;
  final String iconName;
  final String colorHex;
  final String? parentId;
  final bool isSystemDefault;
  final DateTime? createdAt;

  bool get isSubCategory => parentId != null && parentId!.isNotEmpty;

  CategoryEntity copyWith({
    String? id,
    String? name,
    CategoryType? type,
    String? iconName,
    String? colorHex,
    String? parentId,
    bool? isSystemDefault,
    DateTime? createdAt,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      parentId: parentId ?? this.parentId,
      isSystemDefault: isSystemDefault ?? this.isSystemDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        iconName,
        colorHex,
        parentId,
        isSystemDefault,
        createdAt,
      ];
}
