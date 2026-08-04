import 'package:dhanra_new/features/categories/domain/entities/category_entity.dart';
import 'package:equatable/equatable.dart';

abstract class CategoriesEvent extends Equatable {
  const CategoriesEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategoriesEvent extends CategoriesEvent {
  const LoadCategoriesEvent();
}

class CategoriesUpdatedEvent extends CategoriesEvent {
  const CategoriesUpdatedEvent(this.categories);

  final List<CategoryEntity> categories;

  @override
  List<Object?> get props => [categories];
}

class CategoryTypeTabChangedEvent extends CategoriesEvent {
  const CategoryTypeTabChangedEvent(this.type);

  final CategoryType type;

  @override
  List<Object?> get props => [type];
}

class CategorySearchQueryChangedEvent extends CategoriesEvent {
  const CategorySearchQueryChangedEvent(this.searchQuery);

  final String searchQuery;

  @override
  List<Object?> get props => [searchQuery];
}

class CreateCategoryRequestedEvent extends CategoriesEvent {
  const CreateCategoryRequestedEvent(this.category);

  final CategoryEntity category;

  @override
  List<Object?> get props => [category];
}

class UpdateCategoryRequestedEvent extends CategoriesEvent {
  const UpdateCategoryRequestedEvent(this.category);

  final CategoryEntity category;

  @override
  List<Object?> get props => [category];
}

class DeleteCategoryRequestedEvent extends CategoriesEvent {
  const DeleteCategoryRequestedEvent(this.categoryId);

  final String categoryId;

  @override
  List<Object?> get props => [categoryId];
}
