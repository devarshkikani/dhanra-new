import 'package:dhanra_new/features/analytics/domain/entities/analytics_data_entity.dart';
import 'package:equatable/equatable.dart';

abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

class AnalyticsInitialState extends AnalyticsState {
  const AnalyticsInitialState();
}

class AnalyticsLoadingState extends AnalyticsState {
  const AnalyticsLoadingState();
}

class AnalyticsLoadedState extends AnalyticsState {
  const AnalyticsLoadedState(this.data);

  final AnalyticsDataEntity data;

  @override
  List<Object?> get props => [data];
}

class AnalyticsErrorState extends AnalyticsState {
  const AnalyticsErrorState(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
