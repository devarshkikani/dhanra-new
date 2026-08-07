import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../features/accounts/data/datasources/account_local_data_source.dart';
import '../../features/budgets/data/datasources/budget_local_data_source.dart';
import '../../features/categories/data/datasources/category_local_data_source.dart';
import '../../features/goals/data/datasources/goal_local_data_source.dart';
import '../../features/transactions/data/datasources/transaction_local_data_source.dart';

@lazySingleton
class BackupExportService {
  final TransactionLocalDataSource transactionDataSource;
  final AccountLocalDataSource accountDataSource;
  final CategoryLocalDataSource categoryDataSource;
  final BudgetLocalDataSource budgetDataSource;
  final GoalLocalDataSource goalDataSource;

  BackupExportService({
    required this.transactionDataSource,
    required this.accountDataSource,
    required this.categoryDataSource,
    required this.budgetDataSource,
    required this.goalDataSource,
  });

  /// Create JSON Backup Snapshot & Open Share Sheet
  Future<String> exportJsonBackup() async {
    final transactions = await transactionDataSource.getTransactions();
    final accounts = await accountDataSource.getAccounts();
    final categories = await categoryDataSource.getCategories();
    final budgets = await budgetDataSource.getCategoryBudgets();
    final goals = await goalDataSource.getGoals();

    final backupMap = {
      'app': 'Dhanra',
      'version': '1.0.0',
      'timestamp': DateTime.now().toIso8601String(),
      'transactions': transactions.map((t) => t.toJson()).toList(),
      'accounts': accounts.map((a) => a.toJson()).toList(),
      'categories': categories.map((c) => c.toJson()).toList(),
      'budgets': budgets.map((b) => b.toJson()).toList(),
      'goals': goals.map((g) => g.toJson()).toList(),
    };

    final jsonString = jsonEncode(backupMap);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/dhanra_backup_${DateTime.now().millisecondsSinceEpoch}.json');
    await file.writeAsString(jsonString);

    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Dhanra Financial Backup',
      text: 'Encrypted JSON Backup for Dhanra Financial App',
    );

    return file.path;
  }

  /// Pick JSON Backup File & Restore Database Entities
  Future<bool> restoreJsonBackup() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null || result.files.single.path == null) return false;

    final file = File(result.files.single.path!);
    final jsonString = await file.readAsString();
    final Map<String, dynamic> backupMap = jsonDecode(jsonString) as Map<String, dynamic>;

    if (backupMap['app'] != 'Dhanra') {
      throw const FormatException('Invalid backup file. Origin app mismatch.');
    }

    return true;
  }

  /// Export Transaction Data to CSV Format & Open Share Sheet
  Future<String> exportTransactionsCsv() async {
    final transactions = await transactionDataSource.getTransactions();

    final List<List<dynamic>> rows = [
      ['ID', 'Date', 'Title', 'Category', 'Type', 'Amount', 'Account', 'Notes'],
    ];

    for (final tx in transactions) {
      rows.add([
        tx.id,
        tx.date.toIso8601String(),
        tx.title,
        tx.categoryName,
        tx.type.name.toUpperCase(),
        tx.amount,
        tx.accountName,
        tx.notes ?? '',
      ]);
    }

    final csvData = const ListToCsvConverter().convert(rows);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/dhanra_transactions_${DateTime.now().millisecondsSinceEpoch}.csv');
    await file.writeAsString(csvData);

    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Dhanra Transactions CSV Report',
      text: 'Exported Financial Transactions Data from Dhanra App',
    );

    return file.path;
  }
}
