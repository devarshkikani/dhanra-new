import 'package:dhanra_new/features/categories/domain/entities/category_entity.dart';
import 'package:dhanra_new/features/categories/domain/usecases/create_category_usecase.dart';
import 'package:dhanra_new/features/categories/domain/usecases/delete_category_usecase.dart';
import 'package:dhanra_new/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:dhanra_new/features/categories/domain/usecases/update_category_usecase.dart';
import 'package:dhanra_new/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:dhanra_new/features/categories/presentation/bloc/categories_event.dart';
import 'package:dhanra_new/features/categories/presentation/bloc/categories_state.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetCategoriesUseCase implements GetCategoriesUseCase {
  final List<CategoryEntity> categories = [
    const CategoryEntity(
      id: 'cat_food',
      name: 'Food & Dining',
      type: CategoryType.expense,
      iconName: 'fastfood',
      colorHex: '#9B5DE5',
    ),
    const CategoryEntity(
      id: 'cat_salary',
      name: 'Salary',
      type: CategoryType.income,
      iconName: 'work',
      colorHex: '#00C853',
    ),
  ];

  @override
  Future<List<CategoryEntity>> call() async => categories;

  @override
  Stream<List<CategoryEntity>> watch() async* {
    yield categories;
  }
}

class MockCreateCategoryUseCase implements CreateCategoryUseCase {
  @override
  Future<CategoryEntity> call(CategoryEntity category) async => category;
}

class MockUpdateCategoryUseCase implements UpdateCategoryUseCase {
  @override
  Future<CategoryEntity> call(CategoryEntity category) async => category;
}

class MockDeleteCategoryUseCase implements DeleteCategoryUseCase {
  @override
  Future<void> call(String categoryId) async {}
}

void main() {
  late CategoriesBloc bloc;
  late MockGetCategoriesUseCase mockGetUseCase;

  setUp(() {
    mockGetUseCase = MockGetCategoriesUseCase();
    bloc = CategoriesBloc(
      getCategoriesUseCase: mockGetUseCase,
      createCategoryUseCase: MockCreateCategoryUseCase(),
      updateCategoryUseCase: MockUpdateCategoryUseCase(),
      deleteCategoryUseCase: MockDeleteCategoryUseCase(),
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('CategoriesBloc Unit Tests', () {
    test(
        'initial state transitions to CategoriesLoadedState from live stream listener',
        () async {
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state, isA<CategoriesLoadedState>());
    });

    test('emits CategoriesLoadedState when LoadCategoriesEvent is added',
        () async {
      bloc.add(const LoadCategoriesEvent());

      await expectLater(
        bloc.stream,
        emitsThrough(isA<CategoriesLoadedState>()),
      );

      final state = bloc.state as CategoriesLoadedState;
      expect(state.allCategories.length, 2);
      expect(state.filteredParentCategories.length, 1);
      expect(state.filteredParentCategories.first.name, 'Food & Dining');
    });

    test('switches category type filter correctly', () async {
      bloc.add(const LoadCategoriesEvent());
      await Future<void>.delayed(Duration.zero);

      bloc.add(const CategoryTypeTabChangedEvent(CategoryType.income));
      await Future<void>.delayed(Duration.zero);

      final state = bloc.state as CategoriesLoadedState;
      expect(state.selectedType, CategoryType.income);
      expect(state.filteredParentCategories.first.name, 'Salary');
    });

    test('filters categories by search query', () async {
      bloc.add(const LoadCategoriesEvent());
      await Future<void>.delayed(Duration.zero);

      bloc.add(const CategorySearchQueryChangedEvent('food'));
      await Future<void>.delayed(Duration.zero);

      final state = bloc.state as CategoriesLoadedState;
      expect(state.filteredParentCategories.length, 1);
      expect(state.filteredParentCategories.first.name, 'Food & Dining');
    });
  });
}
