import 'package:dhanra_new/core/common_widgets/app_button.dart';
import 'package:dhanra_new/core/common_widgets/app_text_field.dart';
import 'package:dhanra_new/core/common_widgets/glass_card.dart';
import 'package:dhanra_new/core/router/app_router.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/app_gradients.dart';
import 'package:dhanra_new/core/widgets/widgets.dart' hide AppButton, AppTextField;
import 'package:dhanra_new/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dhanra_new/features/auth/presentation/bloc/auth_event.dart';
import 'package:dhanra_new/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _emailFormKey = GlobalKey<FormState>();
  final _phoneFormKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onEmailSubmit() {
    if (_emailFormKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            SignInWithEmailRequestedEvent(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          );
    }
  }

  void _onPhoneSubmit() {
    if (_phoneFormKey.currentState?.validate() ?? false) {
      var phone = _phoneController.text.trim();
      if (!phone.startsWith('+')) {
        phone = '+91$phone'; // Default country code if omitted
      }
      context.read<AuthBloc>().add(
            SendPhoneOtpRequestedEvent(phoneNumber: phone),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedState) {
          context.go(AppRoutes.home);
        } else if (state is OtpSentState) {
          context.push(
            AppRoutes.otpVerification,
            extra: {
              'verificationId': state.verificationId,
              'phoneNumber': state.phoneNumber,
            },
          );
        } else if (state is AuthFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: AppBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: AppGradients.primary,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 14),
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            AppGradients.primary.createShader(bounds),
                        child: const Text(
                          'Dhanra',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sign in to manage your financial portfolio.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 28),
                  GlassCard(
                    padding: const EdgeInsets.all(4),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        gradient: AppGradients.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelColor: Colors.white,
                      unselectedLabelColor: AppColors.textSecondary,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      tabs: const [
                        Tab(text: 'Email'),
                        Tab(text: 'Mobile OTP'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 360,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Email Form
                        Form(
                          key: _emailFormKey,
                          child: Column(
                            children: [
                              AppTextField(
                                controller: _emailController,
                                label: 'Email Address',
                                hintText: 'example@domain.com',
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: const Icon(
                                  Icons.email_outlined,
                                  color: AppColors.textSecondary,
                                  size: 20,
                                ),
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'Enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              AppTextField(
                                controller: _passwordController,
                                label: 'Password',
                                hintText: '••••••••',
                                obscureText: _obscurePassword,
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: AppColors.textSecondary,
                                  size: 20,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: AppColors.textSecondary,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                validator: (val) {
                                  if (val == null || val.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () =>
                                      context.push(AppRoutes.forgotPassword),
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: AppColors.secondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, state) {
                                  return AppButton(
                                    text: 'Sign In',
                                    isLoading: state is AuthLoadingState,
                                    onPressed: _onEmailSubmit,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        // Phone OTP Form
                        Form(
                          key: _phoneFormKey,
                          child: Column(
                            children: [
                              AppTextField(
                                controller: _phoneController,
                                label: 'Mobile Number',
                                hintText: '9876543210',
                                keyboardType: TextInputType.phone,
                                prefixIcon: const Icon(
                                  Icons.phone_android_outlined,
                                  color: AppColors.textSecondary,
                                  size: 20,
                                ),
                                validator: (val) {
                                  if (val == null || val.length < 10) {
                                    return 'Enter a valid mobile number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'We will send a 6-digit OTP to verify your mobile number.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const Spacer(),
                              BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, state) {
                                  return AppButton(
                                    text: 'Send OTP',
                                    isLoading: state is AuthLoadingState,
                                    onPressed: _onPhoneSubmit,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      GestureDetector(
                        onTap: () => context.push(AppRoutes.register),
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
