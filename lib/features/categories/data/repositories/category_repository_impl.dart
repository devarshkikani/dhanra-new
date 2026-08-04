import 'package:dhanra_new/features/categories/data/datasources/category_local_data_source.dart';
import 'package:dhanra_new/features/categories/data/models/category_model.dart';
import 'package:dhanra_new/features/categories/domain/entities/category_entity.dart';
import 'package:dhanra_new/features/categories/domain/repositories/category_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this._localDataSource);

  final CategoryLocalDataSource _localDataSource;

  @override
  Future<List<CategoryEntity>> getCategories() async {
    return _localDataSource.getCategories();
  }

  @override
  Stream<List<CategoryEntity>> watchCategories() {
    return _localDataSource.watchCategories();
  }

  @override
  Future<CategoryEntity> createCategory(CategoryEntity category) async {
    final model = CategoryModel.fromEntity(category);
    return _localDataSource.createCategory(model);
  }

  @override
  Future<CategoryEntity> updateCategory(CategoryEntity category) async {
    final model = CategoryModel.fromEntity(category);
    return _localDataSource.updateCategory(model);
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    return _localDataSource.deleteCategory(categoryId);
  }
}
