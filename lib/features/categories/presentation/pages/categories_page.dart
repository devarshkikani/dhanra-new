import 'package:dhanra_new/core/common_widgets/app_button.dart';
import 'package:dhanra_new/core/common_widgets/app_tab_bar.dart';
import 'package:dhanra_new/core/common_widgets/app_text_field.dart';
import 'package:dhanra_new/core/common_widgets/glass_card.dart';
import 'package:dhanra_new/core/di/injection.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/app_gradients.dart';
import 'package:dhanra_new/core/widgets/widgets.dart' hide AppButton, AppTextField;
import 'package:dhanra_new/features/categories/domain/entities/category_entity.dart';
import 'package:dhanra_new/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:dhanra_new/features/categories/presentation/bloc/categories_event.dart';
import 'package:dhanra_new/features/categories/presentation/bloc/categories_state.dart';
import 'package:dhanra_new/features/categories/presentation/widgets/add_edit_category_dialog.dart';
import 'package:dhanra_new/features/categories/presentation/widgets/category_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoriesBloc>(
      create: (_) => getIt<CategoriesBloc>()..add(const LoadCategoriesEvent()),
      child: const _CategoriesView(),
    );
  }
}

class _CategoriesView extends StatelessWidget {
  const _CategoriesView();

  Future<void> _showAddEditDialog(
    BuildContext context, {
    required List<CategoryEntity> parentCategories,
    CategoryEntity? category,
    String? initialParentId,
    CategoryType? initialType,
  }) async {
    final bloc = context.read<CategoriesBloc>();
    final result = await showModalBottomSheet<CategoryEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddEditCategoryDialog(
        category: category,
        parentCategories: parentCategories,
        initialParentId: initialParentId,
        initialType: initialType,
      ),
    );

    if (result != null) {
      if (category == null) {
        bloc.add(CreateCategoryRequestedEvent(result));
      } else {
        bloc.add(UpdateCategoryRequestedEvent(result));
      }
    }
  }

  void _confirmDelete(BuildContext context, CategoryEntity category) {
    final bloc = context.read<CategoriesBloc>();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        title: const Text('Delete Category',
            style: TextStyle(color: AppColors.textPrimary)),
        content: Text(
          'Are you sure you want to delete "${category.name}"?',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              bloc.add(DeleteCategoryRequestedEvent(category.id));
            },
            child:
                const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const AppAppBar(
          title: 'Categories Management',
        ),
        body: SafeArea(
          bottom: false,
          child: BlocBuilder<CategoriesBloc, CategoriesState>(
            builder: (context, state) {
              if (state is CategoriesLoadingState ||
                  state is CategoriesInitialState) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (state is CategoriesErrorState) {
                return Center(
                  child: Text(
                    state.errorMessage,
                    style: const TextStyle(color: AppColors.error),
                  ),
                );
              }

              if (state is CategoriesLoadedState) {
                final parents = state.filteredParentCategories;

                return Column(
                  children: [
                    // 1. Search Bar & Segmented Toggle Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          AppTextField(
                            hintText: 'Search categories...',
                            prefixIcon: const Icon(Icons.search_rounded,
                                color: AppColors.textSecondary),
                            onChanged: (val) {
                              context
                                  .read<CategoriesBloc>()
                                  .add(CategorySearchQueryChangedEvent(val));
                            },
                          ),
                          const SizedBox(height: 14),
                          DefaultTabController(
                            length: 2,
                            initialIndex: state.selectedType == CategoryType.expense ? 0 : 1,
                            child: AppSegmentedTabBar(
                              onTap: (index) {
                                final type = index == 0
                                    ? CategoryType.expense
                                    : CategoryType.income;
                                context
                                    .read<CategoriesBloc>()
                                    .add(CategoryTypeTabChangedEvent(type));
                              },
                              tabs: const [
                                Tab(text: 'Expense'),
                                Tab(text: 'Income'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),

                    // 2. Categories List
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 110,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${state.selectedType.displayName} Categories (${parents.length})',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: AppButton(
                                    text: 'New Category',
                                    icon: Icons.add_rounded,
                                    height: 38,
                                    type: AppButtonType.secondary,
                                    onPressed: () => _showAddEditDialog(
                                      context,
                                      parentCategories: state.parentCategories,
                                      initialType: state.selectedType,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (parents.isEmpty) ...[
                              const GlassCard(
                                padding: EdgeInsets.all(24),
                                child: Center(
                                  child: Text(
                                    'No categories found.',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              ...parents.map((parentCat) {
                                final subs =
                                    state.getSubCategories(parentCat.id);
                                return CategoryTile(
                                  category: parentCat,
                                  subCategories: subs,
                                  onEdit: () => _showAddEditDialog(
                                    context,
                                    parentCategories: state.parentCategories,
                                    category: parentCat,
                                  ),
                                  onDelete: () =>
                                      _confirmDelete(context, parentCat),
                                  onAddSubCategory: () => _showAddEditDialog(
                                    context,
                                    parentCategories: state.parentCategories,
                                    initialParentId: parentCat.id,
                                    initialType: parentCat.type,
                                  ),
                                );
                              }),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentedTab({
    required BuildContext context,
    required String label,
    required CategoryType type,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<CategoriesBloc>().add(CategoryTypeTabChangedEvent(type));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.inputBackground,
            borderRadius: BorderRadius.circular(14),
            border: isSelected
                ? Border.all(color: AppColors.primary, width: 1.5)
                : Border.all(color: AppColors.inputBorder),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
