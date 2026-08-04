import 'package:dhanra_new/features/categories/domain/entities/category_entity.dart';
import 'package:dhanra_new/features/categories/domain/repositories/category_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetCategoriesUseCase {
  const GetCategoriesUseCase(this._repository);

  final CategoryRepository _repository;

  Future<List<CategoryEntity>> call() async {
    return _repository.getCategories();
  }

  Stream<List<CategoryEntity>> watch() {
    return _repository.watchCategories();
  }
}
