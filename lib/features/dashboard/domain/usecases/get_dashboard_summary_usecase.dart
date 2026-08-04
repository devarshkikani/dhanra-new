import 'package:dhanra_new/features/dashboard/domain/entities/dashboard_summary_entity.dart';
import 'package:dhanra_new/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetDashboardSummaryUseCase {
  const GetDashboardSummaryUseCase(this._repository);

  final DashboardRepository _repository;

  Future<DashboardSummaryEntity> call() async {
    return _repository.getDashboardSummary();
  }

  Stream<DashboardSummaryEntity> watch() {
    return _repository.watchDashboardSummary();
  }
}
