import 'package:dhanra_new/core/di/injection.dart';
import 'package:dhanra_new/core/services/notification_service.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/app_radius.dart';

import 'package:dhanra_new/features/accounts/domain/entities/account_entity.dart';
import 'package:dhanra_new/features/accounts/domain/usecases/create_account_usecase.dart';
import 'package:dhanra_new/features/accounts/domain/usecases/get_accounts_usecase.dart';
import 'package:dhanra_new/features/accounts/presentation/pages/accounts_page.dart';
import 'package:dhanra_new/features/accounts/presentation/widgets/add_edit_account_dialog.dart';
import 'package:dhanra_new/features/analytics/presentation/pages/analytics_page.dart';
import 'package:dhanra_new/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:dhanra_new/features/settings/presentation/pages/settings_page.dart';
import 'package:dhanra_new/features/transactions/presentation/pages/transactions_page.dart';
import 'package:dhanra_new/core/widgets/widgets.dart';
import 'package:flutter/material.dart';

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const TransactionsPage(),
    const AnalyticsPage(),
    // const AccountsPage(),
    const SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 1. Proactively request Notification permissions on app launch
      await NotificationService().requestPermission();

      // 2. Check if user has zero accounts and prompt initial setup
      final accounts = await getIt<GetAccountsUseCase>().call();
      if (mounted && accounts.isEmpty) {
        _promptInitialAccountSetup(context);
      }
    });
  }

  Future<void> _promptInitialAccountSetup(BuildContext context) async {
    final result = await showModalBottomSheet<AccountEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddEditAccountDialog(),
    );

    if (result != null && mounted) {
      await getIt<CreateAccountUseCase>().call(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.darkCard.withValues(alpha: 0.95),
              borderRadius: AppRadius.borderPill,
              border: Border.all(color: AppColors.glassBorder),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                    0, Icons.home_rounded, Icons.home_outlined, 'Home'),
                _buildNavItem(1, Icons.receipt_long_rounded,
                    Icons.receipt_long_outlined, 'Txns'),
                _buildNavItem(2, Icons.bar_chart_rounded,
                    Icons.bar_chart_outlined, 'Analytics'),
                // _buildNavItem(3, Icons.account_balance_wallet_rounded,
                //     Icons.account_balance_wallet_outlined, 'Accounts'),
                _buildNavItem(3, Icons.settings_rounded,
                    Icons.settings_outlined, 'Settings'),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Widget _buildNavItem(
      int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: Duration.zero,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.18)
              : Colors.transparent,
          borderRadius: AppRadius.borderPill,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
