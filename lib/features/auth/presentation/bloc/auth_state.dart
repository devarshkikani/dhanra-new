import 'package:dhanra_new/features/auth/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthenticatedState extends AuthState {
  const AuthenticatedState(this.user);

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

class UnauthenticatedState extends AuthState {}

class OtpSentState extends AuthState {
  const OtpSentState({
    required this.verificationId,
    required this.phoneNumber,
  });

  final String verificationId;
  final String phoneNumber;

  @override
  List<Object?> get props => [verificationId, phoneNumber];
}

class PasswordResetSentState extends AuthState {}

class AuthFailureState extends AuthState {
  const AuthFailureState(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
