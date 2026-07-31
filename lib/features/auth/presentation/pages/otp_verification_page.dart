import 'package:dhanra_new/core/router/app_router.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dhanra_new/features/auth/presentation/bloc/auth_event.dart';
import 'package:dhanra_new/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  final String verificationId;
  final String phoneNumber;

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _onVerifyOtp(String smsCode) {
    if (smsCode.length == 6) {
      context.read<AuthBloc>().add(
            VerifyPhoneOtpRequestedEvent(
              verificationId: widget.verificationId,
              smsCode: smsCode,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.primary, width: 2),
      ),
    );

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedState) {
          context.go(AppRoutes.home);
        } else if (state is AuthFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: AppBar(
          title: const Text('Verify OTP'),
          backgroundColor: AppColors.darkBackground,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                const Text(
                  'Enter Verification Code',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'We sent a 6-digit verification code to ${widget.phoneNumber}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.darkTextSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 40),
                Pinput(
                  length: 6,
                  controller: _pinController,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  showCursor: true,
                  onCompleted: _onVerifyOtp,
                ),
                const SizedBox(height: 40),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is AuthLoadingState
                          ? null
                          : () => _onVerifyOtp(_pinController.text),
                      child: state is AuthLoadingState
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Verify & Proceed'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
