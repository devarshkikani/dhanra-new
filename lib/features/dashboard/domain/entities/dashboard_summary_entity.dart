import 'package:equatable/equatable.dart';

class DashboardRecentTransactionEntity extends Equatable {
  const DashboardRecentTransactionEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.isCredit,
  });

  final String id;
  final String title;
  final String category;
  final double amount;
  final String date;
  final bool isCredit;

  @override
  List<Object?> get props => [id, title, category, amount, date, isCredit];
}

class DashboardSummaryEntity extends Equatable {
  const DashboardSummaryEntity({
    required this.userName,
    required this.totalBalance,
    required this.monthlyIncome,
    required this.monthlyExpense,
    required this.savingsAmount,
    required this.savingsRatePercentage,
    required this.budgetSpentAmount,
    required this.budgetTotalLimit,
    required this.recentTransactions,
    required this.aiInsightSummary,
  });

  final String userName;
  final double totalBalance;
  final double monthlyIncome;
  final double monthlyExpense;
  final double savingsAmount;
  final double savingsRatePercentage;
  final double budgetSpentAmount;
  final double budgetTotalLimit;
  final List<DashboardRecentTransactionEntity> recentTransactions;
  final String aiInsightSummary;

  double get budgetPercentage =>
      budgetTotalLimit > 0 ? (budgetSpentAmount / budgetTotalLimit) : 0.0;

  @override
  List<Object?> get props => [
        userName,
        totalBalance,
        monthlyIncome,
        monthlyExpense,
        savingsAmount,
        savingsRatePercentage,
        budgetSpentAmount,
        budgetTotalLimit,
        recentTransactions,
        aiInsightSummary,
      ];
}
