import 'package:dhanra_new/features/categories/domain/repositories/category_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeleteCategoryUseCase {
  const DeleteCategoryUseCase(this._repository);

  final CategoryRepository _repository;

  Future<void> call(String categoryId) async {
    return _repository.deleteCategory(categoryId);
  }
}
