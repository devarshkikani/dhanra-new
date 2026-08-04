import 'package:dhanra_new/core/common_widgets/app_button.dart';
import 'package:dhanra_new/core/common_widgets/app_text_field.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/features/categories/domain/entities/category_entity.dart';
import 'package:flutter/material.dart';

class AddEditCategoryDialog extends StatefulWidget {
  const AddEditCategoryDialog({
    required this.parentCategories,
    super.key,
    this.category,
    this.initialParentId,
    this.initialType,
  });

  final CategoryEntity? category;
  final List<CategoryEntity> parentCategories;
  final String? initialParentId;
  final CategoryType? initialType;

  @override
  State<AddEditCategoryDialog> createState() => _AddEditCategoryDialogState();
}

class _AddEditCategoryDialogState extends State<AddEditCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  late CategoryType _selectedType;
  late String _selectedIconName;
  late String _selectedColorHex;
  String? _selectedParentId;

  final List<String> _iconOptions = [
    'fastfood',
    'restaurant',
    'coffee',
    'local_grocery_store',
    'shopping_bag',
    'receipt_long',
    'directions_car',
    'movie',
    'medical_services',
    'flight',
    'work',
    'laptop_mac',
    'trending_up',
    'card_giftcard',
    'category',
  ];

  final List<String> _colorOptions = [
    '#9B5DE5', // Poli Purple
    '#00F5D4', // Mint Cyan
    '#FFA500', // Orange Sunshine
    '#00C853', // Emerald Green
    '#448AFF', // Info Blue
    '#FF5252', // Coral Red
    '#E040FB', // Neon Magenta
    '#FFAB00', // Gold Yellow
  ];

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'fastfood':
        return Icons.fastfood_rounded;
      case 'restaurant':
        return Icons.restaurant_rounded;
      case 'coffee':
        return Icons.coffee_rounded;
      case 'local_grocery_store':
        return Icons.local_grocery_store_rounded;
      case 'shopping_bag':
        return Icons.shopping_bag_rounded;
      case 'receipt_long':
        return Icons.receipt_long_rounded;
      case 'directions_car':
        return Icons.directions_car_rounded;
      case 'movie':
        return Icons.movie_rounded;
      case 'medical_services':
        return Icons.medical_services_rounded;
      case 'flight':
        return Icons.flight_rounded;
      case 'work':
        return Icons.work_rounded;
      case 'laptop_mac':
        return Icons.laptop_mac_rounded;
      case 'trending_up':
        return Icons.trending_up_rounded;
      case 'card_giftcard':
        return Icons.card_giftcard_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  @override
  void initState() {
    super.initState();
    final cat = widget.category;
    _nameController = TextEditingController(text: cat?.name ?? '');

    _selectedType = cat?.type ?? widget.initialType ?? CategoryType.expense;
    _selectedIconName = cat?.iconName ?? _iconOptions.first;
    _selectedColorHex = cat?.colorHex ?? _colorOptions.first;
    _selectedParentId = cat?.parentId ?? widget.initialParentId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();

      final categoryToReturn = CategoryEntity(
        id: widget.category?.id ??
            'cat_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        type: _selectedType,
        iconName: _selectedIconName,
        colorHex: _selectedColorHex,
        parentId: _selectedParentId,
        isSystemDefault: widget.category?.isSystemDefault ?? false,
        createdAt: widget.category?.createdAt ?? DateTime.now(),
      );

      Navigator.of(context).pop(categoryToReturn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.category != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEditing ? 'Edit Category' : 'Add New Category',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close,
                          color: AppColors.textSecondary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 1. Category Type Segmented Toggle
                const Text(
                  'Category Type',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: CategoryType.values.map((type) {
                    final isSelected = _selectedType == type;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedType = type;
                            _selectedParentId = null;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.inputBackground,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              type.displayName,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // 2. Category Name
                AppTextField(
                  controller: _nameController,
                  label: 'Category Name',
                  hintText: 'e.g. Coffee & Snacks',
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Enter a category name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 3. Parent Category (Optional)
                const Text(
                  'Parent Category (Optional for Sub-category)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String?>(
                  initialValue: _selectedParentId,
                  dropdownColor: AppColors.darkCard,
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 15),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.inputBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: AppColors.inputBorder),
                    ),
                  ),
                  items: [
                    const DropdownMenuItem<String?>(
                      child: Text('None (Main Parent Category)'),
                    ),
                    ...widget.parentCategories
                        .where((p) => p.type == _selectedType)
                        .map(
                          (p) => DropdownMenuItem<String?>(
                            value: p.id,
                            child: Text(p.name),
                          ),
                        ),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _selectedParentId = val;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // 4. Icon Picker Grid
                const Text(
                  'Category Icon',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _iconOptions.map((iconName) {
                    final isSelected = _selectedIconName == iconName;
                    final icon = _getIconData(iconName);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIconName = iconName;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.25)
                              : AppColors.inputBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? Border.all(color: AppColors.primary, width: 2)
                              : Border.all(),
                        ),
                        child: Icon(
                          icon,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          size: 22,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // 5. Color Palette Picker
                const Text(
                  'Color Palette',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: _colorOptions.map((hex) {
                    final isSelected = _selectedColorHex == hex;
                    final color = Color(
                        int.parse('ff${hex.replaceFirst('#', '')}', radix: 16));

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColorHex = hex;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Colors.white, width: 2.5)
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                AppButton(
                  text: isEditing ? 'Save Category' : 'Create Category',
                  onPressed: _onSave,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
