import 'package:dhanra_new/features/dashboard/domain/entities/dashboard_summary_entity.dart';

abstract class DashboardRepository {
  Future<DashboardSummaryEntity> getDashboardSummary();
  Stream<DashboardSummaryEntity> watchDashboardSummary();
}
