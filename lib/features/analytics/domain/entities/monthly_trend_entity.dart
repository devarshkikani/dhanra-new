import 'package:equatable/equatable.dart';

class MonthlyTrendEntity extends Equatable {
  const MonthlyTrendEntity({
    required this.label,
    required this.income,
    required this.expense,
    required this.cashFlow,
  });

  final String label; // e.g. "Week 1", "Jul", "01 Aug"
  final double income;
  final double expense;
  final double cashFlow;

  @override
  List<Object?> get props => [label, income, expense, cashFlow];
}
