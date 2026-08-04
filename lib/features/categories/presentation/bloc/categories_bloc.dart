import 'dart:async';
import 'package:dhanra_new/features/categories/domain/entities/category_entity.dart';
import 'package:dhanra_new/features/categories/domain/usecases/create_category_usecase.dart';
import 'package:dhanra_new/features/categories/domain/usecases/delete_category_usecase.dart';
import 'package:dhanra_new/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:dhanra_new/features/categories/domain/usecases/update_category_usecase.dart';
import 'package:dhanra_new/features/categories/presentation/bloc/categories_event.dart';
import 'package:dhanra_new/features/categories/presentation/bloc/categories_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc({
    required GetCategoriesUseCase getCategoriesUseCase,
    required CreateCategoryUseCase createCategoryUseCase,
    required UpdateCategoryUseCase updateCategoryUseCase,
    required DeleteCategoryUseCase deleteCategoryUseCase,
  })  : _getCategoriesUseCase = getCategoriesUseCase,
        _createCategoryUseCase = createCategoryUseCase,
        _updateCategoryUseCase = updateCategoryUseCase,
        _deleteCategoryUseCase = deleteCategoryUseCase,
        super(const CategoriesInitialState()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<CategoriesUpdatedEvent>(_onCategoriesUpdated);
    on<CategoryTypeTabChangedEvent>(_onTypeTabChanged);
    on<CategorySearchQueryChangedEvent>(_onSearchQueryChanged);
    on<CreateCategoryRequestedEvent>(_onCreateCategory);
    on<UpdateCategoryRequestedEvent>(_onUpdateCategory);
    on<DeleteCategoryRequestedEvent>(_onDeleteCategory);

    _subscription = _getCategoriesUseCase.watch().listen(
      (categories) {
        add(CategoriesUpdatedEvent(categories));
      },
    );
  }

  final GetCategoriesUseCase _getCategoriesUseCase;
  final CreateCategoryUseCase _createCategoryUseCase;
  final UpdateCategoryUseCase _updateCategoryUseCase;
  final DeleteCategoryUseCase _deleteCategoryUseCase;

  StreamSubscription<List<CategoryEntity>>? _subscription;

  Future<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(const CategoriesLoadingState());
    try {
      final categories = await _getCategoriesUseCase();
      emit(CategoriesLoadedState(allCategories: categories));
    } catch (e) {
      emit(CategoriesErrorState(e.toString()));
    }
  }

  void _onCategoriesUpdated(
    CategoriesUpdatedEvent event,
    Emitter<CategoriesState> emit,
  ) {
    if (state is CategoriesLoadedState) {
      final current = state as CategoriesLoadedState;
      emit(current.copyWith(allCategories: event.categories));
    } else {
      emit(CategoriesLoadedState(allCategories: event.categories));
    }
  }

  void _onTypeTabChanged(
    CategoryTypeTabChangedEvent event,
    Emitter<CategoriesState> emit,
  ) {
    if (state is CategoriesLoadedState) {
      final current = state as CategoriesLoadedState;
      emit(current.copyWith(selectedType: event.type));
    }
  }

  void _onSearchQueryChanged(
    CategorySearchQueryChangedEvent event,
    Emitter<CategoriesState> emit,
  ) {
    if (state is CategoriesLoadedState) {
      final current = state as CategoriesLoadedState;
      emit(current.copyWith(searchQuery: event.searchQuery));
    }
  }

  Future<void> _onCreateCategory(
    CreateCategoryRequestedEvent event,
    Emitter<CategoriesState> emit,
  ) async {
    try {
      await _createCategoryUseCase(event.category);
    } catch (e) {
      emit(CategoriesErrorState(e.toString()));
    }
  }

  Future<void> _onUpdateCategory(
    UpdateCategoryRequestedEvent event,
    Emitter<CategoriesState> emit,
  ) async {
    try {
      await _updateCategoryUseCase(event.category);
    } catch (e) {
      emit(CategoriesErrorState(e.toString()));
    }
  }

  Future<void> _onDeleteCategory(
    DeleteCategoryRequestedEvent event,
    Emitter<CategoriesState> emit,
  ) async {
    try {
      await _deleteCategoryUseCase(event.categoryId);
    } catch (e) {
      emit(CategoriesErrorState(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
