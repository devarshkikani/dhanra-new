import 'package:dhanra_new/features/dashboard/domain/entities/dashboard_summary_entity.dart';

class DashboardRecentTransactionModel extends DashboardRecentTransactionEntity {
  const DashboardRecentTransactionModel({
    required super.id,
    required super.title,
    required super.category,
    required super.amount,
    required super.date,
    required super.isCredit,
  });

  factory DashboardRecentTransactionModel.fromJson(Map<String, dynamic> json) {
    return DashboardRecentTransactionModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      date: json['date'] as String? ?? '',
      isCredit: json['isCredit'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'amount': amount,
      'date': date,
      'isCredit': isCredit,
    };
  }
}

class DashboardSummaryModel extends DashboardSummaryEntity {
  const DashboardSummaryModel({
    required super.userName,
    required super.totalBalance,
    required super.monthlyIncome,
    required super.monthlyExpense,
    required super.savingsAmount,
    required super.savingsRatePercentage,
    required super.budgetSpentAmount,
    required super.budgetTotalLimit,
    required super.recentTransactions,
    required super.aiInsightSummary,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      userName: json['userName'] as String? ?? 'User',
      totalBalance: (json['totalBalance'] as num?)?.toDouble() ?? 0.0,
      monthlyIncome: (json['monthlyIncome'] as num?)?.toDouble() ?? 0.0,
      monthlyExpense: (json['monthlyExpense'] as num?)?.toDouble() ?? 0.0,
      savingsAmount: (json['savingsAmount'] as num?)?.toDouble() ?? 0.0,
      savingsRatePercentage:
          (json['savingsRatePercentage'] as num?)?.toDouble() ?? 0.0,
      budgetSpentAmount: (json['budgetSpentAmount'] as num?)?.toDouble() ?? 0.0,
      budgetTotalLimit: (json['budgetTotalLimit'] as num?)?.toDouble() ?? 0.0,
      recentTransactions: (json['recentTransactions'] as List<dynamic>?)
              ?.map((e) => DashboardRecentTransactionModel.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          [],
      aiInsightSummary: json['aiInsightSummary'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'totalBalance': totalBalance,
      'monthlyIncome': monthlyIncome,
      'monthlyExpense': monthlyExpense,
      'savingsAmount': savingsAmount,
      'savingsRatePercentage': savingsRatePercentage,
      'budgetSpentAmount': budgetSpentAmount,
      'budgetTotalLimit': budgetTotalLimit,
      'recentTransactions': recentTransactions
          .map((e) => (e as DashboardRecentTransactionModel).toJson())
          .toList(),
      'aiInsightSummary': aiInsightSummary,
    };
  }
}
