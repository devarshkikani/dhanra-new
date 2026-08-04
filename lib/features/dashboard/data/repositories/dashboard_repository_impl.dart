import 'package:dhanra_new/features/dashboard/data/datasources/dashboard_local_data_source.dart';
import 'package:dhanra_new/features/dashboard/domain/entities/dashboard_summary_entity.dart';
import 'package:dhanra_new/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl(this._localDataSource);

  final DashboardLocalDataSource _localDataSource;

  @override
  Future<DashboardSummaryEntity> getDashboardSummary() async {
    return _localDataSource.getSummary();
  }

  @override
  Stream<DashboardSummaryEntity> watchDashboardSummary() {
    return _localDataSource.watchSummary();
  }
}
