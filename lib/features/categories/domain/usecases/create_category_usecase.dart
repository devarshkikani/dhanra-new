import 'package:dhanra_new/features/categories/domain/entities/category_entity.dart';
import 'package:dhanra_new/features/categories/domain/repositories/category_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CreateCategoryUseCase {
  const CreateCategoryUseCase(this._repository);

  final CategoryRepository _repository;

  Future<CategoryEntity> call(CategoryEntity category) async {
    return _repository.createCategory(category);
  }
}
