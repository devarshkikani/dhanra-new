import 'package:dhanra_new/features/accounts/data/datasources/account_local_data_source.dart';
import 'package:dhanra_new/features/accounts/data/models/account_model.dart';
import 'package:dhanra_new/features/dashboard/data/datasources/dashboard_local_data_source.dart';
import 'package:dhanra_new/features/dashboard/data/models/dashboard_summary_model.dart';
import 'package:dhanra_new/features/goals/data/datasources/goal_local_data_source.dart';
import 'package:dhanra_new/features/goals/data/models/goal_contribution_model.dart';
import 'package:dhanra_new/features/goals/data/models/goal_model.dart';
import 'package:dhanra_new/features/goals/domain/entities/goal_contribution_entity.dart';
import 'package:dhanra_new/features/goals/domain/entities/goal_entity.dart';
import 'package:dhanra_new/features/goals/domain/entities/goals_summary_entity.dart';
import 'package:dhanra_new/features/goals/domain/repositories/goal_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: GoalRepository)
class GoalRepositoryImpl implements GoalRepository {
  GoalRepositoryImpl(
    this._localDataSource,
    this._accountLocalDataSource,
    this._dashboardLocalDataSource,
  );

  final GoalLocalDataSource _localDataSource;
  final AccountLocalDataSource _accountLocalDataSource;
  final DashboardLocalDataSource _dashboardLocalDataSource;

  @override
  Future<GoalsSummaryEntity> getGoalsSummary() async {
    final goals = await _localDataSource.getGoals();

    double totalTarget = 0;
    double totalSaved = 0;
    int activeCount = 0;
    int completedCount = 0;

    for (final g in goals) {
      totalTarget += g.targetAmount;
      totalSaved += g.currentAmount;
      if (g.isCompleted) {
        completedCount++;
      } else {
        activeCount++;
      }
    }

    return GoalsSummaryEntity(
      totalTarget: totalTarget,
      totalSaved: totalSaved,
      activeGoalsCount: activeCount,
      completedGoalsCount: completedCount,
      goals: goals,
    );
  }

  @override
  Stream<GoalsSummaryEntity> watchGoalsSummary() async* {
    yield await getGoalsSummary();

    await for (final _ in _localDataSource.watchGoals()) {
      yield await getGoalsSummary();
    }
  }

  @override
  Future<GoalEntity> createGoal(GoalEntity goal) async {
    final model = GoalModel.fromEntity(goal);
    final created = await _localDataSource.createGoal(model);
    return created;
  }

  @override
  Future<GoalEntity> updateGoal(GoalEntity goal) async {
    final model = GoalModel.fromEntity(goal);
    final updated = await _localDataSource.updateGoal(model);
    return updated;
  }

  @override
  Future<void> deleteGoal(String goalId) async {
    await _localDataSource.deleteGoal(goalId);
  }

  @override
  Future<GoalContributionEntity> addContribution(
      GoalContributionEntity contribution) async {
    final model = GoalContributionModel.fromEntity(contribution);
    final added = await _localDataSource.addContribution(model);

    // 1. Deduct amount from selected Account balance
    final accounts = await _accountLocalDataSource.getAccounts();
    final accIndex = accounts.indexWhere((a) => a.id == contribution.accountId);
    if (accIndex != -1) {
      final acc = accounts[accIndex];
      final newBalance = acc.balance - contribution.amount;
      await _accountLocalDataSource.updateAccount(
        AccountModel.fromEntity(acc.copyWith(balance: newBalance)),
      );
    }

    // 2. Sync Home Dashboard savings rate
    try {
      final summary = await getGoalsSummary();
      final currentDashboard = await _dashboardLocalDataSource.getSummary();

      final updatedSummary = DashboardSummaryModel(
        userName: currentDashboard.userName,
        totalBalance: currentDashboard.totalBalance,
        monthlyIncome: currentDashboard.monthlyIncome,
        monthlyExpense: currentDashboard.monthlyExpense,
        savingsAmount: summary.totalSaved,
        savingsRatePercentage: currentDashboard.monthlyIncome > 0
            ? (summary.totalSaved / currentDashboard.monthlyIncome) * 100
            : 0.0,
        budgetSpentAmount: currentDashboard.budgetSpentAmount,
        budgetTotalLimit: currentDashboard.budgetTotalLimit,
        recentTransactions: currentDashboard.recentTransactions,
        aiInsightSummary: currentDashboard.aiInsightSummary,
      );

      await _dashboardLocalDataSource.updateSummary(updatedSummary);
    } catch (_) {}

    return added;
  }
}
