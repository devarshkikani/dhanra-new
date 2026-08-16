import 'package:dhanra_new/features/analytics/domain/entities/analytics_data_entity.dart';
import 'package:dhanra_new/features/analytics/domain/entities/category_spending_entity.dart';
import 'package:dhanra_new/features/analytics/domain/entities/monthly_trend_entity.dart';
import 'package:dhanra_new/features/analytics/domain/usecases/get_analytics_data_usecase.dart';
import 'package:dhanra_new/features/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:dhanra_new/features/analytics/presentation/bloc/analytics_event.dart';
import 'package:dhanra_new/features/analytics/presentation/bloc/analytics_state.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetAnalyticsDataUseCase implements GetAnalyticsDataUseCase {
  final sampleData = const AnalyticsDataEntity(
    totalIncome: 140000,
    totalExpense: 28550,
    netCashFlow: 111450,
    averageDailySpend: 951.6,
    topExpenseCategory: 'Shopping',
    categoryBreakdowns: [
      CategorySpendingEntity(
        categoryId: 'cat_shopping',
        categoryName: 'Shopping',
        categoryIcon: 'shopping_bag',
        categoryColor: '#FFA500',
        amount: 24900,
        percentage: 87.2,
      ),
    ],
    trends: [
      MonthlyTrendEntity(
        label: 'W1',
        income: 125000,
        expense: 28550,
        cashFlow: 96450,
      ),
    ],
    savingsRate: 79.6,
    peakSpendDay: 'Sun, Aug 10',
    peakSpendAmount: 4500,
  );

  @override
  Future<AnalyticsDataEntity> call({
    AnalyticsTimeRange timeRange = AnalyticsTimeRange.monthly,
    DateTime? startDate,
    DateTime? endDate,
  }) async =>
      sampleData;

  @override
  Stream<AnalyticsDataEntity> watch({
    AnalyticsTimeRange timeRange = AnalyticsTimeRange.monthly,
    DateTime? startDate,
    DateTime? endDate,
  }) async* {
    yield sampleData;
  }
}

void main() {
  late AnalyticsBloc bloc;
  late MockGetAnalyticsDataUseCase mockGetAnalyticsUseCase;

  setUp(() {
    mockGetAnalyticsUseCase = MockGetAnalyticsDataUseCase();
    bloc = AnalyticsBloc(
      getAnalyticsDataUseCase: mockGetAnalyticsUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('AnalyticsBloc Unit Tests', () {
    test(
        'initial state transitions to AnalyticsLoadedState from live stream listener',
        () async {
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state, isA<AnalyticsLoadedState>());
    });

    test('emits AnalyticsLoadedState when LoadAnalyticsEvent is added',
        () async {
      bloc.add(const LoadAnalyticsEvent());
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state, isA<AnalyticsLoadedState>());
      final state = bloc.state as AnalyticsLoadedState;
      expect(state.data.totalIncome, 140000);
      expect(state.data.topExpenseCategory, 'Shopping');
      expect(state.data.savingsRate, 79.6);
    });

    test('switches time range filter to weekly and yearly correctly', () async {
      bloc.add(const TimeRangeChangedEvent(AnalyticsTimeRange.weekly));
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state, isA<AnalyticsLoadedState>());

      bloc.add(const TimeRangeChangedEvent(AnalyticsTimeRange.yearly));
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state, isA<AnalyticsLoadedState>());
    });

    test('handles CustomDateRangeSelectedEvent correctly', () async {
      bloc.add(CustomDateRangeSelectedEvent(
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 6, 30),
      ));
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state, isA<AnalyticsLoadedState>());
    });
  });
}
