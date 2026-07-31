import 'package:dhanra_new/core/di/injection.dart';
import 'package:dhanra_new/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dhanra_new/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:dhanra_new/features/auth/presentation/pages/login_page.dart';
import 'package:dhanra_new/features/auth/presentation/pages/otp_verification_page.dart';
import 'package:dhanra_new/features/auth/presentation/pages/register_page.dart';
import 'package:dhanra_new/features/auth/presentation/pages/splash_page.dart';
import 'package:dhanra_new/features/auth/presentation/pages/onboarding_page.dart';
import 'package:dhanra_new/features/sample_feature/presentation/pages/post_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

abstract class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String otpVerification = '/otp-verification';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
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
      builder: (context, state) => const PostPage(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Route not found: ${state.uri}'),
    ),
  ),
);
