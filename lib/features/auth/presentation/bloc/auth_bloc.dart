import 'package:dhanra_new/core/usecases/usecase.dart';
import 'package:dhanra_new/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:dhanra_new/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:dhanra_new/features/auth/domain/usecases/send_phone_otp_usecase.dart';
import 'package:dhanra_new/features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:dhanra_new/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:dhanra_new/features/auth/domain/usecases/sign_up_with_email_usecase.dart';
import 'package:dhanra_new/features/auth/domain/usecases/verify_phone_otp_usecase.dart';
import 'package:dhanra_new/features/auth/presentation/bloc/auth_event.dart';
import 'package:dhanra_new/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required SignInWithEmailUseCase signInWithEmailUseCase,
    required SignUpWithEmailUseCase signUpWithEmailUseCase,
    required SendPhoneOtpUseCase sendPhoneOtpUseCase,
    required VerifyPhoneOtpUseCase verifyPhoneOtpUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required SignOutUseCase signOutUseCase,
  })  : _getCurrentUserUseCase = getCurrentUserUseCase,
        _signInWithEmailUseCase = signInWithEmailUseCase,
        _signUpWithEmailUseCase = signUpWithEmailUseCase,
        _sendPhoneOtpUseCase = sendPhoneOtpUseCase,
        _verifyPhoneOtpUseCase = verifyPhoneOtpUseCase,
        _resetPasswordUseCase = resetPasswordUseCase,
        _signOutUseCase = signOutUseCase,
        super(AuthInitialState()) {
    on<AuthCheckRequestedEvent>(_onAuthCheckRequested);
    on<SignInWithEmailRequestedEvent>(_onSignInWithEmailRequested);
    on<SignUpWithEmailRequestedEvent>(_onSignUpWithEmailRequested);
    on<SendPhoneOtpRequestedEvent>(_onSendPhoneOtpRequested);
    on<VerifyPhoneOtpRequestedEvent>(_onVerifyPhoneOtpRequested);
    on<ResetPasswordRequestedEvent>(_onResetPasswordRequested);
    on<SignOutRequestedEvent>(_onSignOutRequested);
  }

  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final SignInWithEmailUseCase _signInWithEmailUseCase;
  final SignUpWithEmailUseCase _signUpWithEmailUseCase;
  final SendPhoneOtpUseCase _sendPhoneOtpUseCase;
  final VerifyPhoneOtpUseCase _verifyPhoneOtpUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final SignOutUseCase _signOutUseCase;

  Future<void> _onAuthCheckRequested(
    AuthCheckRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    final (failure, user) = await _getCurrentUserUseCase(const NoParams());
    if (failure != null) {
      emit(UnauthenticatedState());
    } else if (user != null) {
      emit(AuthenticatedState(user));
    } else {
      emit(UnauthenticatedState());
    }
  }

  Future<void> _onSignInWithEmailRequested(
    SignInWithEmailRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    final (failure, user) = await _signInWithEmailUseCase(
      SignInWithEmailParams(email: event.email, password: event.password),
    );
    if (failure != null) {
      emit(AuthFailureState(failure.message));
    } else if (user != null) {
      emit(AuthenticatedState(user));
    } else {
      emit(const AuthFailureState('Sign in failed'));
    }
  }

  Future<void> _onSignUpWithEmailRequested(
    SignUpWithEmailRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    final (failure, user) = await _signUpWithEmailUseCase(
      SignUpWithEmailParams(
        email: event.email,
        password: event.password,
        displayName: event.displayName,
      ),
    );
    if (failure != null) {
      emit(AuthFailureState(failure.message));
    } else if (user != null) {
      emit(AuthenticatedState(user));
    } else {
      emit(const AuthFailureState('Sign up failed'));
    }
  }

  Future<void> _onSendPhoneOtpRequested(
    SendPhoneOtpRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    final (failure, verificationId) = await _sendPhoneOtpUseCase(
      SendPhoneOtpParams(phoneNumber: event.phoneNumber),
    );
    if (failure != null) {
      emit(AuthFailureState(failure.message));
    } else if (verificationId != null) {
      emit(OtpSentState(
        verificationId: verificationId,
        phoneNumber: event.phoneNumber,
      ));
    } else {
      emit(const AuthFailureState('Failed to send OTP'));
    }
  }

  Future<void> _onVerifyPhoneOtpRequested(
    VerifyPhoneOtpRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    final (failure, user) = await _verifyPhoneOtpUseCase(
      VerifyPhoneOtpParams(
        verificationId: event.verificationId,
        smsCode: event.smsCode,
        displayName: event.displayName,
      ),
    );
    if (failure != null) {
      emit(AuthFailureState(failure.message));
    } else if (user != null) {
      emit(AuthenticatedState(user));
    } else {
      emit(const AuthFailureState('OTP verification failed'));
    }
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    final (failure, _) = await _resetPasswordUseCase(
      ResetPasswordParams(email: event.email),
    );
    if (failure != null) {
      emit(AuthFailureState(failure.message));
    } else {
      emit(PasswordResetSentState());
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    await _signOutUseCase(const NoParams());
    emit(UnauthenticatedState());
  }
}
