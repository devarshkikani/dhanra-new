import 'package:dhanra_new/features/goals/domain/entities/goals_summary_entity.dart';
import 'package:dhanra_new/features/goals/domain/repositories/goal_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetGoalsSummaryUseCase {
  const GetGoalsSummaryUseCase(this._repository);

  final GoalRepository _repository;

  Future<GoalsSummaryEntity> call() async {
    return _repository.getGoalsSummary();
  }

  Stream<GoalsSummaryEntity> watch() {
    return _repository.watchGoalsSummary();
  }
}
