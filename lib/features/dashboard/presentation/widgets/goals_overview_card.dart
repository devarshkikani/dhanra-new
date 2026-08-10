import 'dart:async';
import 'package:dhanra_new/core/common_widgets/glass_card.dart';
import 'package:dhanra_new/core/di/injection.dart';
import 'package:dhanra_new/core/router/app_router.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/currency_extension.dart';
import 'package:dhanra_new/features/goals/domain/entities/goals_summary_entity.dart';
import 'package:dhanra_new/features/goals/domain/usecases/get_goals_summary_usecase.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GoalsOverviewCard extends StatefulWidget {
  const GoalsOverviewCard({super.key});

  @override
  State<GoalsOverviewCard> createState() => _GoalsOverviewCardState();
}

class _GoalsOverviewCardState extends State<GoalsOverviewCard> {
  StreamSubscription<GoalsSummaryEntity>? _subscription;
  GoalsSummaryEntity? _summary;

  @override
  void initState() {
    super.initState();
    _subscription = getIt<GetGoalsSummaryUseCase>().watch().listen((s) {
      if (mounted) {
        setState(() {
          _summary = s;
        });
      }
    });
    getIt<GetGoalsSummaryUseCase>().call().then((s) {
      if (mounted) {
        setState(() {
          _summary = s;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final summary = _summary;
    final totalSaved = summary?.totalSaved ?? 0.0;
    final totalTarget = summary?.totalTarget ?? 0.0;
    final progress =
        totalTarget > 0 ? (totalSaved / totalTarget).clamp(0.0, 1.0) : 0.0;
    final activeCount = summary?.activeGoalsCount ?? 0;
    final completedCount = summary?.completedGoalsCount ?? 0;

    return GlassCard(
      padding: const EdgeInsets.all(18),
      borderRadius: 20,
      onTap: () => context.push(AppRoutes.goals),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.savings_rounded,
                    color: AppColors.credit,
                    size: 22,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Savings Goals',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  if (completedCount > 0) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.credit.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$completedCount Done 🎉',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.credit,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    '$activeCount Active',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: AppColors.inputBorder,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.credit,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Saved: ${context.currencySymbol}${totalSaved.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.credit,
                ),
              ),
              Text(
                'Target: ${context.currencySymbol}${totalTarget.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          if (summary != null && summary.goals.isNotEmpty) ...[
            const SizedBox(height: 14),
            const Divider(color: AppColors.inputBorder, height: 1),
            const SizedBox(height: 10),
            ...summary.goals.take(2).map((g) {
              final pct =
                  (g.percentageSaved * 100).clamp(0, 100).toStringAsFixed(0);
              return Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      g.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${context.currencySymbol}${g.currentAmount.toStringAsFixed(0)} / ${context.currencySymbol}${g.targetAmount.toStringAsFixed(0)} ($pct%)',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
