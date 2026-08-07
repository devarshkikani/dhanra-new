import 'package:dhanra_new/core/common_widgets/app_button.dart';
import 'package:dhanra_new/core/common_widgets/app_text_field.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/features/goals/domain/entities/goal_entity.dart';
import 'package:flutter/material.dart';

class AddEditGoalDialog extends StatefulWidget {
  const AddEditGoalDialog({
    super.key,
    this.goal,
  });

  final GoalEntity? goal;

  @override
  State<AddEditGoalDialog> createState() => _AddEditGoalDialogState();
}

class _AddEditGoalDialogState extends State<AddEditGoalDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _targetAmountController;
  late DateTime _selectedDeadline;
  late String _selectedIcon;
  late String _selectedColor;

  final List<Map<String, dynamic>> _iconOptions = [
    {'name': 'savings', 'icon': Icons.savings_rounded},
    {'name': 'shield', 'icon': Icons.shield_rounded},
    {'name': 'flight_takeoff', 'icon': Icons.flight_takeoff_rounded},
    {'name': 'laptop_mac', 'icon': Icons.laptop_mac_rounded},
    {'name': 'directions_car', 'icon': Icons.directions_car_rounded},
    {'name': 'home', 'icon': Icons.home_rounded},
    {'name': 'school', 'icon': Icons.school_rounded},
  ];

  final List<String> _colorOptions = [
    '#00F5D4',
    '#9B5DE5',
    '#00C853',
    '#FFA500',
    '#E91E63',
    '#2196F3',
  ];

  @override
  void initState() {
    super.initState();
    final g = widget.goal;
    _titleController = TextEditingController(text: g?.title ?? '');
    _targetAmountController = TextEditingController(
      text: g != null ? g.targetAmount.toStringAsFixed(0) : '',
    );
    _selectedDeadline =
        g?.deadline ?? DateTime.now().add(const Duration(days: 365));
    _selectedIcon = g?.iconName ?? 'savings';
    _selectedColor = g?.colorHex ?? '#00F5D4';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _targetAmountController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final title = _titleController.text.trim();
      final target =
          double.tryParse(_targetAmountController.text.trim()) ?? 0.0;

      final goalToReturn = GoalEntity(
        id: widget.goal?.id ?? 'g_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        targetAmount: target,
        currentAmount: widget.goal?.currentAmount ?? 0.0,
        deadline: _selectedDeadline,
        iconName: _selectedIcon,
        colorHex: _selectedColor,
        isCompleted: (widget.goal?.currentAmount ?? 0) >= target,
        createdAt: widget.goal?.createdAt ?? DateTime.now(),
      );

      Navigator.of(context).pop(goalToReturn);
    }
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline,
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.darkCard,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDeadline = picked;
      });
    }
  }

  Color _parseColor(String hex) {
    try {
      final buffer = StringBuffer();
      if (hex.length == 6 || hex.length == 7) buffer.write('ff');
      buffer.write(hex.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.goal != null;

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
                      isEditing
                          ? 'Edit Savings Goal'
                          : 'Create New Savings Goal',
                      style: const TextStyle(
                        fontSize: 18,
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

                AppTextField(
                  controller: _titleController,
                  label: 'Goal Title',
                  hintText: 'e.g. Emergency Reserve',
                  validator: (val) {
                    if (val == null || val.trim().isEmpty)
                      return 'Enter goal title';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                AppTextField(
                  controller: _targetAmountController,
                  label: 'Target Savings Amount (₹)',
                  hintText: 'e.g. 200000',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty)
                      return 'Enter target amount';
                    final numVal = double.tryParse(val.trim());
                    if (numVal == null || numVal <= 0)
                      return 'Enter valid amount';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Target Deadline Date Picker
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Target Deadline',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _pickDeadline,
                      icon: const Icon(Icons.calendar_today_rounded,
                          size: 18, color: AppColors.secondary),
                      label: Text(
                        '${_selectedDeadline.day.toString().padLeft(2, '0')}/${_selectedDeadline.month.toString().padLeft(2, '0')}/${_selectedDeadline.year}',
                        style: const TextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Icon Selection
                const Text(
                  'Icon Badge',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _iconOptions.map((opt) {
                      final name = opt['name'] as String;
                      final iconData = opt['icon'] as IconData;
                      final isSelected = _selectedIcon == name;

                      return GestureDetector(
                        onTap: () => setState(() => _selectedIcon = name),
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.inputBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected
                                ? Border.all(color: AppColors.primary, width: 2)
                                : Border.all(color: AppColors.inputBorder),
                          ),
                          child: Icon(
                            iconData,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary,
                            size: 20,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                // Color Selection
                const Text(
                  'Color Theme',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: _colorOptions.map((hex) {
                    final color = _parseColor(hex);
                    final isSelected = _selectedColor == hex;

                    return GestureDetector(
                      onTap: () => setState(() => _selectedColor = hex),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Colors.white, width: 3)
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                AppButton(
                  text: isEditing ? 'Save Goal' : 'Create Goal',
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
