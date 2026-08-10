import 'dart:async';
import 'dart:convert';
import 'package:dhanra_new/features/categories/data/models/category_model.dart';
import 'package:dhanra_new/features/categories/domain/entities/category_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CategoryLocalDataSource {
  Future<List<CategoryModel>> getCategories();
  Stream<List<CategoryModel>> watchCategories();
  Future<CategoryModel> createCategory(CategoryModel category);
  Future<CategoryModel> updateCategory(CategoryModel category);
  Future<void> deleteCategory(String categoryId);
}

@LazySingleton(as: CategoryLocalDataSource)
class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  CategoryLocalDataSourceImpl() {
    _initFromPrefs();
  }

  static const _storageKey = 'dhanra_categories_v1';
  final List<CategoryModel> _categories = [];
  final StreamController<List<CategoryModel>> _controller =
      StreamController<List<CategoryModel>>.broadcast();
  bool _isLoaded = false;
  Completer<void>? _initCompleter;

  Future<void> _initFromPrefs() async {
    if (_isLoaded) return;
    if (_initCompleter != null) return _initCompleter!.future;
    _initCompleter = Completer<void>();

    try {
      _initSeedCategories();
      final prefs = await SharedPreferences.getInstance();
      final rawJson = prefs.getString(_storageKey);
      if (rawJson != null && rawJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(rawJson) as List<dynamic>;
        final userCategories = decoded
            .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
            .toList();

        // Merge user custom categories without duplicating defaults
        for (final cat in userCategories) {
          final idx = _categories.indexWhere((c) => c.id == cat.id);
          if (idx != -1) {
            _categories[idx] = cat;
          } else {
            _categories.add(cat);
          }
        }
      }
    } catch (_) {
    } finally {
      _isLoaded = true;
      _initCompleter?.complete();
      _notifyListeners();
    }
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rawJson = jsonEncode(_categories.map((c) => c.toJson()).toList());
      await prefs.setString(_storageKey, rawJson);
    } catch (_) {}
  }

  void _initSeedCategories() {
    _categories.addAll([
      // Expense Categories
      const CategoryModel(
        id: 'cat_food',
        name: 'Food & Dining',
        type: CategoryType.expense,
        iconName: 'fastfood',
        colorHex: '#9B5DE5',
        isSystemDefault: true,
      ),
      const CategoryModel(
        id: 'cat_food_res',
        name: 'Restaurants',
        type: CategoryType.expense,
        iconName: 'restaurant',
        colorHex: '#9B5DE5',
        parentId: 'cat_food',
        isSystemDefault: true,
      ),
      const CategoryModel(
        id: 'cat_food_coffee',
        name: 'Coffee Shops',
        type: CategoryType.expense,
        iconName: 'coffee',
        colorHex: '#9B5DE5',
        parentId: 'cat_food',
        isSystemDefault: true,
      ),
      const CategoryModel(
        id: 'cat_groceries',
        name: 'Groceries',
        type: CategoryType.expense,
        iconName: 'local_grocery_store',
        colorHex: '#00F5D4',
        isSystemDefault: true,
      ),
      const CategoryModel(
        id: 'cat_shopping',
        name: 'Shopping',
        type: CategoryType.expense,
        iconName: 'shopping_bag',
        colorHex: '#FFA500',
        isSystemDefault: true,
      ),
      const CategoryModel(
        id: 'cat_bills',
        name: 'Bills & Utilities',
        type: CategoryType.expense,
        iconName: 'receipt_long',
        colorHex: '#FF5252',
        isSystemDefault: true,
      ),
      const CategoryModel(
        id: 'cat_transport',
        name: 'Transportation',
        type: CategoryType.expense,
        iconName: 'directions_car',
        colorHex: '#448AFF',
        isSystemDefault: true,
      ),
      const CategoryModel(
        id: 'cat_entertainment',
        name: 'Entertainment',
        type: CategoryType.expense,
        iconName: 'movie',
        colorHex: '#E040FB',
        isSystemDefault: true,
      ),
      const CategoryModel(
        id: 'cat_health',
        name: 'Health & Medical',
        type: CategoryType.expense,
        iconName: 'medical_services',
        colorHex: '#00C853',
        isSystemDefault: true,
      ),
      const CategoryModel(
        id: 'cat_travel',
        name: 'Travel',
        type: CategoryType.expense,
        iconName: 'flight',
        colorHex: '#FFAB00',
        isSystemDefault: true,
      ),

      // Income Categories
      const CategoryModel(
        id: 'cat_salary',
        name: 'Salary',
        type: CategoryType.income,
        iconName: 'work',
        colorHex: '#00C853',
        isSystemDefault: true,
      ),
      const CategoryModel(
        id: 'cat_freelance',
        name: 'Freelance & Business',
        type: CategoryType.income,
        iconName: 'laptop_mac',
        colorHex: '#00F5D4',
        isSystemDefault: true,
      ),
      const CategoryModel(
        id: 'cat_investments',
        name: 'Investments & Returns',
        type: CategoryType.income,
        iconName: 'trending_up',
        colorHex: '#9B5DE5',
        isSystemDefault: true,
      ),
      const CategoryModel(
        id: 'cat_gifts',
        name: 'Gifts & Rewards',
        type: CategoryType.income,
        iconName: 'card_giftcard',
        colorHex: '#FFA500',
        isSystemDefault: true,
      ),
    ]);
  }

  void _notifyListeners() {
    _controller.add(List.unmodifiable(_categories));
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    await _initFromPrefs();
    return List.unmodifiable(_categories);
  }

  @override
  Stream<List<CategoryModel>> watchCategories() async* {
    await _initFromPrefs();
    yield List.unmodifiable(_categories);
    yield* _controller.stream;
  }

  @override
  Future<CategoryModel> createCategory(CategoryModel category) async {
    await _initFromPrefs();
    _categories.add(category);
    await _saveToPrefs();
    _notifyListeners();
    return category;
  }

  @override
  Future<CategoryModel> updateCategory(CategoryModel category) async {
    await _initFromPrefs();
    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      _categories[index] = category;
      await _saveToPrefs();
      _notifyListeners();
    }
    return category;
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    await _initFromPrefs();
    _categories.removeWhere(
      (c) =>
          (c.id == categoryId || c.parentId == categoryId) &&
          !c.isSystemDefault,
    );
    await _saveToPrefs();
    _notifyListeners();
  }
}
