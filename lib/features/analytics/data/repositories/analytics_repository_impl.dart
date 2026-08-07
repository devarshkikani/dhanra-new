import 'package:dhanra_new/features/analytics/data/datasources/analytics_local_data_source.dart';
import 'package:dhanra_new/features/analytics/domain/entities/analytics_data_entity.dart';
import 'package:dhanra_new/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:dhanra_new/features/transactions/data/datasources/transaction_local_data_source.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AnalyticsRepository)
class AnalyticsRepositoryImpl implements AnalyticsRepository {
  AnalyticsRepositoryImpl(
    this._localDataSource,
    this._transactionLocalDataSource,
  );

  final AnalyticsLocalDataSource _localDataSource;
  final TransactionLocalDataSource _transactionLocalDataSource;

  @override
  Future<AnalyticsDataEntity> getAnalyticsData({
    AnalyticsTimeRange timeRange = AnalyticsTimeRange.monthly,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final transactions = await _transactionLocalDataSource.getTransactions();
    return _localDataSource.calculateAnalytics(
      transactions: transactions,
      timeRange: timeRange,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Stream<AnalyticsDataEntity> watchAnalyticsData({
    AnalyticsTimeRange timeRange = AnalyticsTimeRange.monthly,
    DateTime? startDate,
    DateTime? endDate,
  }) async* {
    yield await getAnalyticsData(
      timeRange: timeRange,
      startDate: startDate,
      endDate: endDate,
    );

    await for (final txs in _transactionLocalDataSource.watchTransactions()) {
      yield _localDataSource.calculateAnalytics(
        transactions: txs,
        timeRange: timeRange,
        startDate: startDate,
        endDate: endDate,
      );
    }
  }
}
