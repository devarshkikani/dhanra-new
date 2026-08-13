import 'package:dhanra_new/core/router/app_router.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/utils/icon_color_utils.dart';
import 'package:dhanra_new/features/categories/domain/entities/category_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Ultra-fast 1-Tap Inline Category Quick-Picker for Dhanra.
/// Displays vibrant category icon chips and sub-category pills directly inside forms.
class InlineCategoryQuickPicker extends StatelessWidget {
  const InlineCategoryQuickPicker({
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    super.key,
    this.label = 'Category',
    this.showMoreButton = true,
  });

  final List<CategoryEntity> categories;
  final String? selectedCategoryId;
  final ValueChanged<String> onCategorySelected;
  final String label;
  final bool showMoreButton;

  void _showAllCategoriesSheet(
    BuildContext context,
    List<CategoryEntity> parentCategories,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.60,
          ),
          decoration: const BoxDecoration(
            color: AppColors.darkSurface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.inputBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Category',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      context.push(AppRoutes.categories);
                    },
                    child: const Text(
                      '⚙️ Manage',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: parentCategories.length,
                  itemBuilder: (_, index) {
                    final cat = parentCategories[index];
                    final isSelected = cat.id == selectedCategoryId;
                    final catColor = IconColorUtils.parseHexColor(cat.colorHex);
                    final icon =
                        IconColorUtils.getCategoryIconData(cat.iconName);

                    return GestureDetector(
                      onTap: () {
                        onCategorySelected(cat.id);
                        Navigator.pop(ctx);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? catColor.withValues(alpha: 0.18)
                              : AppColors.card,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color:
                                isSelected ? catColor : AppColors.inputBorder,
                            width: isSelected ? 1.8 : 1.0,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: catColor.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(icon, color: catColor, size: 20),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              cat.name,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    // Separate main categories (parents)
    final parentCategories = categories.where((c) => !c.isSubCategory).toList();
    final currentSelectedCat = categories.firstWhere(
      (c) => c.id == selectedCategoryId,
      orElse: () => parentCategories.isNotEmpty
          ? parentCategories.first
          : categories.first,
    );

    // Find parent ID if a subcategory is currently selected
    final activeParentId = currentSelectedCat.isSubCategory
        ? currentSelectedCat.parentId
        : currentSelectedCat.id;

    // Get subcategories for currently active parent
    final subCategories = categories
        .where((c) => c.isSubCategory && c.parentId == activeParentId)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty ||
            (showMoreButton && parentCategories.length > 4)) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label.isNotEmpty)
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                )
              else
                const SizedBox.shrink(),
              if (showMoreButton && parentCategories.length > 4)
                GestureDetector(
                  onTap: () =>
                      _showAllCategoriesSheet(context, parentCategories),
                  child: const Text(
                    'More',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],

        // Parent Category Icon Chips
        SizedBox(
          height: 64,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: parentCategories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = parentCategories[index];
              final isSelected = cat.id == activeParentId;
              final catColor = IconColorUtils.parseHexColor(cat.colorHex);
              final icon = IconColorUtils.getCategoryIconData(cat.iconName);

              return GestureDetector(
                onTap: () => onCategorySelected(cat.id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 72,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? catColor.withValues(alpha: 0.18)
                        : AppColors.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? catColor : AppColors.inputBorder,
                      width: isSelected ? 1.8 : 1.0,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: catColor.withValues(alpha: 0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            )
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: isSelected ? catColor : AppColors.textSecondary,
                        size: 20,
                      ),
                      // const SizedBox(height: 4),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 4),
                      //   child: Text(
                      //     cat.name,
                      //     style: TextStyle(
                      //       fontSize: 11,
                      //       fontWeight: isSelected
                      //           ? FontWeight.bold
                      //           : FontWeight.w500,
                      //       color: isSelected
                      //           ? AppColors.textPrimary
                      //           : AppColors.textSecondary,
                      //     ),
                      //     maxLines: 1,
                      //     overflow: TextOverflow.ellipsis,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Sub-categories Pill Row
        if (subCategories.isNotEmpty) ...[
          const SizedBox(height: 8),
          SizedBox(
            height: 32,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: subCategories.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                if (index == 0) {
                  // "All" parent pill
                  final isParentSelected = selectedCategoryId == activeParentId;
                  final parentCatObj = parentCategories.firstWhere(
                    (p) => p.id == activeParentId,
                    orElse: () => currentSelectedCat,
                  );
                  final activeCatColor =
                      IconColorUtils.parseHexColor(parentCatObj.colorHex);

                  return GestureDetector(
                    onTap: () => onCategorySelected(activeParentId!),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: isParentSelected
                            ? activeCatColor.withValues(alpha: 0.2)
                            : AppColors.card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isParentSelected
                              ? activeCatColor
                              : AppColors.inputBorder,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'All ${parentCatObj.name}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isParentSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isParentSelected
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                final subCat = subCategories[index - 1];
                final isSubSelected = subCat.id == selectedCategoryId;
                final subColor = IconColorUtils.parseHexColor(subCat.colorHex);

                return GestureDetector(
                  onTap: () => onCategorySelected(subCat.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSubSelected
                          ? subColor.withValues(alpha: 0.2)
                          : AppColors.card,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSubSelected ? subColor : AppColors.inputBorder,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        subCat.name,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSubSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSubSelected
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
