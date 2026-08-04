import 'package:dhanra_new/features/dashboard/domain/entities/dashboard_summary_entity.dart';
import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitialState extends DashboardState {
  const DashboardInitialState();
}

class DashboardLoadingState extends DashboardState {
  const DashboardLoadingState();
}

class DashboardLoadedState extends DashboardState {
  const DashboardLoadedState(this.summary);

  final DashboardSummaryEntity summary;

  @override
  List<Object?> get props => [summary];
}

class DashboardErrorState extends DashboardState {
  const DashboardErrorState(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
