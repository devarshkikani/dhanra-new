import 'package:dhanra_new/core/di/injection.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/app_gradients.dart';
import 'package:dhanra_new/features/analytics/domain/entities/analytics_data_entity.dart';
import 'package:dhanra_new/features/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:dhanra_new/features/analytics/presentation/bloc/analytics_event.dart';
import 'package:dhanra_new/features/analytics/presentation/bloc/analytics_state.dart';
import 'package:dhanra_new/features/analytics/presentation/widgets/analytics_metrics_grid.dart';
import 'package:dhanra_new/features/analytics/presentation/widgets/cash_flow_trend_card.dart';
import 'package:dhanra_new/features/analytics/presentation/widgets/category_breakdown_chart_card.dart';
import 'package:dhanra_new/features/analytics/presentation/widgets/income_vs_expense_chart_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AnalyticsBloc>(
      create: (_) => getIt<AnalyticsBloc>()..add(const LoadAnalyticsEvent()),
      child: const _AnalyticsView(),
    );
  }
}

class _AnalyticsView extends StatelessWidget {
  const _AnalyticsView();

  Future<void> _pickCustomDateRange(BuildContext context) async {
    final bloc = context.read<AnalyticsBloc>();

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
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
      bloc.add(
        CustomDateRangeSelectedEvent(
          startDate: picked.start,
          endDate: picked.end,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Financial Analytics'),
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.backgroundGlow,
        ),
        child: SafeArea(
          bottom: false,
          child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
            builder: (context, state) {
              if (state is AnalyticsLoadingState ||
                  state is AnalyticsInitialState) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (state is AnalyticsErrorState) {
                return Center(
                  child: Text(
                    state.errorMessage,
                    style: const TextStyle(color: AppColors.error),
                  ),
                );
              }

              if (state is AnalyticsLoadedState) {
                final data = state.data;

                return SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 10,
                    bottom: 110,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Time Range Selector Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildRangeChip(
                              context: context,
                              label: 'This Week',
                              range: AnalyticsTimeRange.weekly,
                              isSelected:
                                  data.timeRange == AnalyticsTimeRange.weekly,
                            ),
                            const SizedBox(width: 8),
                            _buildRangeChip(
                              context: context,
                              label: 'This Month',
                              range: AnalyticsTimeRange.monthly,
                              isSelected:
                                  data.timeRange == AnalyticsTimeRange.monthly,
                            ),
                            const SizedBox(width: 8),
                            _buildCustomRangeChip(
                              context: context,
                              isSelected:
                                  data.timeRange == AnalyticsTimeRange.custom,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 2. Summary Metrics Grid
                      AnalyticsMetricsGrid(data: data),
                      const SizedBox(height: 20),

                      // 3. Income vs Expense Comparison Chart
                      IncomeVsExpenseChartCard(trends: data.trends),
                      const SizedBox(height: 20),

                      // 4. Category Breakdown Distribution Chart
                      CategoryBreakdownChartCard(
                          categories: data.categoryBreakdowns),
                      const SizedBox(height: 20),

                      // 5. Net Cash Flow Trajectory
                      CashFlowTrendCard(trends: data.trends),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRangeChip({
    required BuildContext context,
    required String label,
    required AnalyticsTimeRange range,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        context.read<AnalyticsBloc>().add(TimeRangeChangedEvent(range));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.inputBackground,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 1.5)
              : Border.all(color: AppColors.inputBorder),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomRangeChip({
    required BuildContext context,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => _pickCustomDateRange(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.inputBackground,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 1.5)
              : Border.all(color: AppColors.inputBorder),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_month_rounded,
              size: 16,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              'Custom Range',
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
