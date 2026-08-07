import 'package:dhanra_new/features/analytics/domain/entities/analytics_data_entity.dart';
import 'package:equatable/equatable.dart';

abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAnalyticsEvent extends AnalyticsEvent {
  const LoadAnalyticsEvent();
}

class AnalyticsDataUpdatedEvent extends AnalyticsEvent {
  const AnalyticsDataUpdatedEvent(this.data);

  final AnalyticsDataEntity data;

  @override
  List<Object?> get props => [data];
}

class TimeRangeChangedEvent extends AnalyticsEvent {
  const TimeRangeChangedEvent(this.timeRange);

  final AnalyticsTimeRange timeRange;

  @override
  List<Object?> get props => [timeRange];
}

class CustomDateRangeSelectedEvent extends AnalyticsEvent {
  const CustomDateRangeSelectedEvent({
    required this.startDate,
    required this.endDate,
  });

  final DateTime startDate;
  final DateTime endDate;

  @override
  List<Object?> get props => [startDate, endDate];
}
