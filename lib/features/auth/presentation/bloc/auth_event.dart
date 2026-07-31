import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequestedEvent extends AuthEvent {}

class SignInWithEmailRequestedEvent extends AuthEvent {
  const SignInWithEmailRequestedEvent({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class SignUpWithEmailRequestedEvent extends AuthEvent {
  const SignUpWithEmailRequestedEvent({
    required this.email,
    required this.password,
    required this.displayName,
  });

  final String email;
  final String password;
  final String displayName;

  @override
  List<Object?> get props => [email, password, displayName];
}

class SendPhoneOtpRequestedEvent extends AuthEvent {
  const SendPhoneOtpRequestedEvent({required this.phoneNumber});

  final String phoneNumber;

  @override
  List<Object?> get props => [phoneNumber];
}

class VerifyPhoneOtpRequestedEvent extends AuthEvent {
  const VerifyPhoneOtpRequestedEvent({
    required this.verificationId,
    required this.smsCode,
    this.displayName,
  });

  final String verificationId;
  final String smsCode;
  final String? displayName;

  @override
  List<Object?> get props => [verificationId, smsCode, displayName];
}

class ResetPasswordRequestedEvent extends AuthEvent {
  const ResetPasswordRequestedEvent({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}

class SignOutRequestedEvent extends AuthEvent {}
