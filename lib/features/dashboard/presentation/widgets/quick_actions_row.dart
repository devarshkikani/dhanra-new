import 'package:dhanra_new/core/common_widgets/glass_card.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/app_gradients.dart';
import 'package:flutter/material.dart';

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({
    this.onAddExpense,
    this.onAddIncome,
    this.onTransfer,
    this.onAiAssistant,
    super.key,
  });

  final VoidCallback? onAddExpense;
  final VoidCallback? onAddIncome;
  final VoidCallback? onTransfer;
  final VoidCallback? onAiAssistant;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionItem(
          icon: Icons.add_circle_outline_rounded,
          label: 'Add Expense',
          color: AppColors.debit,
          onTap: onAddExpense,
        ),
        _buildActionItem(
          icon: Icons.arrow_downward_rounded,
          label: 'Add Income',
          color: AppColors.credit,
          onTap: onAddIncome,
        ),
        _buildActionItem(
          icon: Icons.swap_horiz_rounded,
          label: 'Transfer',
          color: AppColors.primary,
          onTap: onTransfer,
        ),
        _buildActionItem(
          icon: Icons.auto_awesome_rounded,
          label: 'AI Insights',
          color: AppColors.secondary,
          onTap: onAiAssistant,
          isSpecial: true,
        ),
      ],
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
    bool isSpecial = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          GlassCard(
            borderRadius: 18,
            padding: const EdgeInsets.all(14),
            backgroundColor: isSpecial ? null : color.withValues(alpha: 0.12),
            borderColor: isSpecial ? AppColors.secondary : null,
            child: ShaderMask(
              shaderCallback: (bounds) => isSpecial
                  ? AppGradients.primary.createShader(bounds)
                  : LinearGradient(colors: [color, color]).createShader(bounds),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
