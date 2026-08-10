import 'package:dhanra_new/core/di/injection.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/app_spacing.dart';
import 'package:dhanra_new/core/widgets/widgets.dart';
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
      backgroundColor: Colors.transparent,
      appBar: const AppAppBar(
        title: 'Financial Analytics',
      ),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
          builder: (context, state) {
            if (state is AnalyticsLoadingState ||
                state is AnalyticsInitialState) {
              return const AppLoading(message: 'Generating analytics...');
            }

            if (state is AnalyticsErrorState) {
              return AppErrorState(
                errorMessage: state.errorMessage,
                onRetry: () => context
                    .read<AnalyticsBloc>()
                    .add(const LoadAnalyticsEvent()),
              );
            }

            if (state is AnalyticsLoadedState) {
              final data = state.data;

              return SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: AppSpacing.md,
                  right: AppSpacing.md,
                  top: AppSpacing.xs,
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
                          AppChip(
                            label: 'This Week',
                            isSelected: data.timeRange == AnalyticsTimeRange.weekly,
                            onTap: () => context.read<AnalyticsBloc>().add(
                                  const TimeRangeChangedEvent(AnalyticsTimeRange.weekly),
                                ),
                          ),
                          AppSpacing.hGapXS,
                          AppChip(
                            label: 'This Month',
                            isSelected: data.timeRange == AnalyticsTimeRange.monthly,
                            onTap: () => context.read<AnalyticsBloc>().add(
                                  const TimeRangeChangedEvent(AnalyticsTimeRange.monthly),
                                ),
                          ),
                          AppSpacing.hGapXS,
                          AppChip(
                            label: 'Custom Range',
                            icon: Icons.calendar_month_rounded,
                            isSelected: data.timeRange == AnalyticsTimeRange.custom,
                            onTap: () => _pickCustomDateRange(context),
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.vGapMD,

                    // 2. Summary Metrics Grid
                    AnalyticsMetricsGrid(data: data),
                    AppSpacing.vGapMD,

                    // 3. Income vs Expense Comparison Chart
                    IncomeVsExpenseChartCard(trends: data.trends),
                    AppSpacing.vGapMD,

                    // 4. Category Breakdown Distribution Chart
                    CategoryBreakdownChartCard(
                        categories: data.categoryBreakdowns),
                    AppSpacing.vGapMD,

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
    );
  }
}
