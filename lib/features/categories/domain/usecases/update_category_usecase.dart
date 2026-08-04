import 'package:dhanra_new/features/categories/domain/entities/category_entity.dart';
import 'package:dhanra_new/features/categories/domain/repositories/category_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UpdateCategoryUseCase {
  const UpdateCategoryUseCase(this._repository);

  final CategoryRepository _repository;

  Future<CategoryEntity> call(CategoryEntity category) async {
    return _repository.updateCategory(category);
  }
}
