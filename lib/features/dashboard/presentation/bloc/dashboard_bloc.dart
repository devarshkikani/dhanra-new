import 'dart:async';
import 'package:dhanra_new/features/dashboard/domain/entities/dashboard_summary_entity.dart';
import 'package:dhanra_new/features/dashboard/domain/usecases/get_dashboard_summary_usecase.dart';
import 'package:dhanra_new/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:dhanra_new/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(this._getDashboardSummaryUseCase)
      : super(const DashboardInitialState()) {
    on<LoadDashboardEvent>(_onLoadDashboard);
    on<RefreshDashboardEvent>(_onRefreshDashboard);
    on<DashboardUpdatedEvent>(_onDashboardUpdated);

    _summarySubscription = _getDashboardSummaryUseCase.watch().listen(
      (summary) {
        add(DashboardUpdatedEvent(summary));
      },
    );
  }

  final GetDashboardSummaryUseCase _getDashboardSummaryUseCase;
  StreamSubscription<DashboardSummaryEntity>? _summarySubscription;

  Future<void> _onLoadDashboard(
    LoadDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoadingState());
    try {
      final summary = await _getDashboardSummaryUseCase();
      emit(DashboardLoadedState(summary));
    } catch (e) {
      emit(DashboardErrorState(e.toString()));
    }
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final summary = await _getDashboardSummaryUseCase();
      emit(DashboardLoadedState(summary));
    } catch (e) {
      emit(DashboardErrorState(e.toString()));
    }
  }

  void _onDashboardUpdated(
    DashboardUpdatedEvent event,
    Emitter<DashboardState> emit,
  ) {
    emit(DashboardLoadedState(event.summary));
  }

  @override
  Future<void> close() {
    _summarySubscription?.cancel();
    return super.close();
  }
}
