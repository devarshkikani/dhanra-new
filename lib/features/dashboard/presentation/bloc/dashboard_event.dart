import 'package:dhanra_new/features/dashboard/domain/entities/dashboard_summary_entity.dart';
import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboardEvent extends DashboardEvent {
  const LoadDashboardEvent();
}

class RefreshDashboardEvent extends DashboardEvent {
  const RefreshDashboardEvent();
}

class DashboardUpdatedEvent extends DashboardEvent {
  const DashboardUpdatedEvent(this.summary);

  final DashboardSummaryEntity summary;

  @override
  List<Object?> get props => [summary];
}
