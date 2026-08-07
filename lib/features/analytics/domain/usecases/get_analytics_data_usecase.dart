import 'package:dhanra_new/features/analytics/domain/entities/analytics_data_entity.dart';
import 'package:dhanra_new/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetAnalyticsDataUseCase {
  const GetAnalyticsDataUseCase(this._repository);

  final AnalyticsRepository _repository;

  Future<AnalyticsDataEntity> call({
    AnalyticsTimeRange timeRange = AnalyticsTimeRange.monthly,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return _repository.getAnalyticsData(
      timeRange: timeRange,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Stream<AnalyticsDataEntity> watch({
    AnalyticsTimeRange timeRange = AnalyticsTimeRange.monthly,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _repository.watchAnalyticsData(
      timeRange: timeRange,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
