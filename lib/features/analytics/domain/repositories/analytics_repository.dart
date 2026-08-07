import 'package:dhanra_new/features/analytics/domain/entities/analytics_data_entity.dart';

abstract class AnalyticsRepository {
  Future<AnalyticsDataEntity> getAnalyticsData({
    AnalyticsTimeRange timeRange = AnalyticsTimeRange.monthly,
    DateTime? startDate,
    DateTime? endDate,
  });

  Stream<AnalyticsDataEntity> watchAnalyticsData({
    AnalyticsTimeRange timeRange = AnalyticsTimeRange.monthly,
    DateTime? startDate,
    DateTime? endDate,
  });
}
