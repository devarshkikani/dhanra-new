import 'package:dhanra_new/core/common_widgets/glass_card.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/utils/icon_color_utils.dart';
import 'package:dhanra_new/features/categories/domain/entities/category_entity.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    required this.category,
    this.subCategories = const [],
    super.key,
    this.onEdit,
    this.onDelete,
    this.onAddSubCategory,
    this.onEditSubCategory,
    this.onDeleteSubCategory,
  });

  final CategoryEntity category;
  final List<CategoryEntity> subCategories;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onAddSubCategory;
  final ValueChanged<CategoryEntity>? onEditSubCategory;
  final ValueChanged<CategoryEntity>? onDeleteSubCategory;

  @override
  Widget build(BuildContext context) {
    final themeColor = IconColorUtils.parseHexColor(category.colorHex);
    final icon = IconColorUtils.getCategoryIconData(category.iconName);

    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      borderRadius: 18,
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: themeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: themeColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            category.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (category.isSystemDefault) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.inputBorder,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Default',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subCategories.isNotEmpty
                          ? '${subCategories.length} sub-categories'
                          : category.type.displayName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.add_circle_outline_rounded,
                  color: AppColors.secondary,
                  size: 22,
                ),
                tooltip: 'Add sub-category',
                onPressed: onAddSubCategory,
              ),
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                color: AppColors.darkSurface,
                onSelected: (val) {
                  if (val == 'edit') onEdit?.call();
                  if (val == 'delete') onDelete?.call();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined,
                            size: 18, color: AppColors.textPrimary),
                        SizedBox(width: 8),
                        Text('Edit Category',
                            style: TextStyle(color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                  if (!category.isSystemDefault)
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_rounded,
                              size: 18, color: AppColors.error),
                          SizedBox(width: 8),
                          Text('Delete Category',
                              style: TextStyle(color: AppColors.error)),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
          if (subCategories.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Divider(color: AppColors.inputBorder, height: 1),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 6,
                children: subCategories.map((sub) {
                  final subColor =
                      IconColorUtils.parseHexColor(sub.colorHex, fallback: themeColor);
                  return InkWell(
                    onTap: () => onEditSubCategory?.call(sub),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: subColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: subColor.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            IconColorUtils.getCategoryIconData(sub.iconName),
                            size: 14,
                            color: subColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            sub.name,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: subColor,
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () => onEditSubCategory?.call(sub),
                            child: Icon(
                              Icons.edit_rounded,
                              size: 12,
                              color: subColor.withValues(alpha: 0.7),
                            ),
                          ),
                          if (!sub.isSystemDefault) ...[
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => onDeleteSubCategory?.call(sub),
                              child: const Icon(
                                Icons.close_rounded,
                                size: 12,
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
