import 'dart:async';
import 'package:dhanra_new/features/analytics/domain/entities/analytics_data_entity.dart';
import 'package:dhanra_new/features/analytics/domain/usecases/get_analytics_data_usecase.dart';
import 'package:dhanra_new/features/analytics/presentation/bloc/analytics_event.dart';
import 'package:dhanra_new/features/analytics/presentation/bloc/analytics_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  AnalyticsBloc({
    required GetAnalyticsDataUseCase getAnalyticsDataUseCase,
  })  : _getAnalyticsDataUseCase = getAnalyticsDataUseCase,
        super(const AnalyticsInitialState()) {
    on<LoadAnalyticsEvent>(_onLoadAnalytics);
    on<AnalyticsDataUpdatedEvent>(_onDataUpdated);
    on<TimeRangeChangedEvent>(_onTimeRangeChanged);
    on<CustomDateRangeSelectedEvent>(_onCustomDateRangeSelected);

    _listenToStream(_selectedTimeRange, _startDate, _endDate);
  }

  final GetAnalyticsDataUseCase _getAnalyticsDataUseCase;

  StreamSubscription<AnalyticsDataEntity>? _subscription;
  AnalyticsTimeRange _selectedTimeRange = AnalyticsTimeRange.monthly;
  DateTime? _startDate;
  DateTime? _endDate;

  void _listenToStream(
    AnalyticsTimeRange timeRange,
    DateTime? startDate,
    DateTime? endDate,
  ) {
    _subscription?.cancel();
    _subscription = _getAnalyticsDataUseCase
        .watch(
          timeRange: timeRange,
          startDate: startDate,
          endDate: endDate,
        )
        .listen(
          (data) => add(AnalyticsDataUpdatedEvent(data)),
        );
  }

  Future<void> _onLoadAnalytics(
    LoadAnalyticsEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(const AnalyticsLoadingState());
    try {
      final data = await _getAnalyticsDataUseCase(
        timeRange: _selectedTimeRange,
        startDate: _startDate,
        endDate: _endDate,
      );
      emit(AnalyticsLoadedState(data));
    } catch (e) {
      emit(AnalyticsErrorState(e.toString()));
    }
  }

  void _onDataUpdated(
    AnalyticsDataUpdatedEvent event,
    Emitter<AnalyticsState> emit,
  ) {
    emit(AnalyticsLoadedState(event.data));
  }

  void _onTimeRangeChanged(
    TimeRangeChangedEvent event,
    Emitter<AnalyticsState> emit,
  ) {
    _selectedTimeRange = event.timeRange;
    _startDate = null;
    _endDate = null;
    _listenToStream(_selectedTimeRange, null, null);
  }

  void _onCustomDateRangeSelected(
    CustomDateRangeSelectedEvent event,
    Emitter<AnalyticsState> emit,
  ) {
    _selectedTimeRange = AnalyticsTimeRange.custom;
    _startDate = event.startDate;
    _endDate = event.endDate;
    _listenToStream(_selectedTimeRange, _startDate, _endDate);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
