import 'package:dhanra_new/features/categories/domain/entities/category_entity.dart';
import 'package:equatable/equatable.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object?> get props => [];
}

class CategoriesInitialState extends CategoriesState {
  const CategoriesInitialState();
}

class CategoriesLoadingState extends CategoriesState {
  const CategoriesLoadingState();
}

class CategoriesLoadedState extends CategoriesState {
  const CategoriesLoadedState({
    required this.allCategories,
    this.selectedType = CategoryType.expense,
    this.searchQuery = '',
  });

  final List<CategoryEntity> allCategories;
  final CategoryType selectedType;
  final String searchQuery;

  List<CategoryEntity> get parentCategories {
    return allCategories.where((c) => !c.isSubCategory).toList();
  }

  List<CategoryEntity> get filteredParentCategories {
    return parentCategories.where((c) {
      final matchesType = c.type == selectedType;
      final matchesSearch = searchQuery.isEmpty ||
          c.name.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesType && matchesSearch;
    }).toList();
  }

  List<CategoryEntity> getSubCategories(String parentId) {
    return allCategories.where((c) => c.parentId == parentId).toList();
  }

  CategoriesLoadedState copyWith({
    List<CategoryEntity>? allCategories,
    CategoryType? selectedType,
    String? searchQuery,
  }) {
    return CategoriesLoadedState(
      allCategories: allCategories ?? this.allCategories,
      selectedType: selectedType ?? this.selectedType,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [allCategories, selectedType, searchQuery];
}

class CategoriesErrorState extends CategoriesState {
  const CategoriesErrorState(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
