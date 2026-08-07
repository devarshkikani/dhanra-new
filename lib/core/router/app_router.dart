import 'package:dhanra_new/core/common_widgets/main_shell_page.dart';
import 'package:dhanra_new/core/di/injection.dart';
import 'package:dhanra_new/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dhanra_new/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:dhanra_new/features/auth/presentation/pages/login_page.dart';
import 'package:dhanra_new/features/auth/presentation/pages/onboarding_page.dart';
import 'package:dhanra_new/features/auth/presentation/pages/otp_verification_page.dart';
import 'package:dhanra_new/features/auth/presentation/pages/register_page.dart';
import 'package:dhanra_new/features/auth/presentation/pages/splash_page.dart';
import 'package:dhanra_new/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:dhanra_new/features/notifications/presentation/bloc/notifications_event.dart';
import 'package:dhanra_new/features/notifications/presentation/pages/notifications_page.dart';
import 'package:dhanra_new/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:dhanra_new/features/settings/presentation/bloc/settings_event.dart';
import 'package:dhanra_new/features/settings/presentation/pages/about_privacy_page.dart';
import 'package:dhanra_new/features/settings/presentation/pages/backup_restore_page.dart';
import 'package:dhanra_new/features/settings/presentation/pages/currency_settings_page.dart';
import 'package:dhanra_new/features/settings/presentation/pages/security_settings_page.dart';
import 'package:dhanra_new/features/settings/presentation/pages/theme_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:dhanra_new/features/accounts/presentation/pages/accounts_page.dart';
import 'package:dhanra_new/features/analytics/presentation/pages/analytics_page.dart';
import 'package:dhanra_new/features/budgets/presentation/pages/budgets_page.dart';
import 'package:dhanra_new/features/categories/presentation/pages/categories_page.dart';
import 'package:dhanra_new/features/goals/presentation/pages/goals_page.dart';
import 'package:dhanra_new/features/transactions/presentation/pages/transactions_page.dart';

abstract class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String otpVerification = '/otp-verification';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String transactions = '/transactions';
  static const String accounts = '/accounts';
  static const String categories = '/categories';
  static const String budgets = '/budgets';
  static const String analytics = '/analytics';
  static const String goals = '/goals';
  static const String notifications = '/notifications';
  static const String themeSettings = '/theme-settings';
  static const String currencySettings = '/currency-settings';
  static const String securitySettings = '/security-settings';
  static const String backupRestore = '/backup-restore';
  static const String aboutPrivacy = '/about-privacy';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => BlocProvider<AuthBloc>(
        create: (_) => getIt<AuthBloc>(),
        child: const SplashPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => BlocProvider<AuthBloc>(
        create: (_) => getIt<AuthBloc>(),
        child: const LoginPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => BlocProvider<AuthBloc>(
        create: (_) => getIt<AuthBloc>(),
        child: const RegisterPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.otpVerification,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return BlocProvider<AuthBloc>(
          create: (_) => getIt<AuthBloc>(),
          child: OtpVerificationPage(
            verificationId: extra['verificationId'] as String? ?? '',
            phoneNumber: extra['phoneNumber'] as String? ?? '',
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => BlocProvider<AuthBloc>(
        create: (_) => getIt<AuthBloc>(),
        child: const ForgotPasswordPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const MainShellPage(),
    ),
    GoRoute(
      path: AppRoutes.transactions,
      builder: (context, state) => const TransactionsPage(),
    ),
    GoRoute(
      path: AppRoutes.accounts,
      builder: (context, state) => const AccountsPage(),
    ),
    GoRoute(
      path: AppRoutes.categories,
      builder: (context, state) => const CategoriesPage(),
    ),
    GoRoute(
      path: AppRoutes.budgets,
      builder: (context, state) => const BudgetsPage(),
    ),
    GoRoute(
      path: AppRoutes.analytics,
      builder: (context, state) => const AnalyticsPage(),
    ),
    GoRoute(
      path: AppRoutes.goals,
      builder: (context, state) => const GoalsPage(),
    ),
    GoRoute(
      path: AppRoutes.notifications,
      builder: (context, state) => BlocProvider<NotificationsBloc>(
        create: (_) => getIt<NotificationsBloc>()..add(const LoadNotificationSettingsEvent()),
        child: const NotificationsPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.themeSettings,
      builder: (context, state) => BlocProvider<SettingsBloc>(
        create: (_) => getIt<SettingsBloc>()..add(const LoadSettingsEvent()),
        child: const ThemeSettingsPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.currencySettings,
      builder: (context, state) => BlocProvider<SettingsBloc>(
        create: (_) => getIt<SettingsBloc>()..add(const LoadSettingsEvent()),
        child: const CurrencySettingsPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.securitySettings,
      builder: (context, state) => BlocProvider<SettingsBloc>(
        create: (_) => getIt<SettingsBloc>()..add(const LoadSettingsEvent()),
        child: const SecuritySettingsPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.backupRestore,
      builder: (context, state) => BlocProvider<SettingsBloc>(
        create: (_) => getIt<SettingsBloc>()..add(const LoadSettingsEvent()),
        child: const BackupRestorePage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.aboutPrivacy,
      builder: (context, state) => const AboutPrivacyPage(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Route not found: ${state.uri}'),
    ),
  ),
);
