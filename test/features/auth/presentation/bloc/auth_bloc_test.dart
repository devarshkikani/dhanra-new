import 'package:bloc_test/bloc_test.dart';
import 'package:dhanra_new/core/error/failures.dart';
import 'package:dhanra_new/core/usecases/usecase.dart';
import 'package:dhanra_new/features/auth/domain/entities/user_entity.dart';
import 'package:dhanra_new/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:dhanra_new/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:dhanra_new/features/auth/domain/usecases/send_phone_otp_usecase.dart';
import 'package:dhanra_new/features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:dhanra_new/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:dhanra_new/features/auth/domain/usecases/sign_up_with_email_usecase.dart';
import 'package:dhanra_new/features/auth/domain/usecases/verify_phone_otp_usecase.dart';
import 'package:dhanra_new/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dhanra_new/features/auth/presentation/bloc/auth_event.dart';
import 'package:dhanra_new/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

class MockSignInWithEmailUseCase extends Mock
    implements SignInWithEmailUseCase {}

class MockSignUpWithEmailUseCase extends Mock
    implements SignUpWithEmailUseCase {}

class MockSendPhoneOtpUseCase extends Mock implements SendPhoneOtpUseCase {}

class MockVerifyPhoneOtpUseCase extends Mock implements VerifyPhoneOtpUseCase {}

class MockResetPasswordUseCase extends Mock implements ResetPasswordUseCase {}

class MockSignOutUseCase extends Mock implements SignOutUseCase {}

void main() {
  late AuthBloc authBloc;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
  late MockSignInWithEmailUseCase mockSignInWithEmailUseCase;
  late MockSignUpWithEmailUseCase mockSignUpWithEmailUseCase;
  late MockSendPhoneOtpUseCase mockSendPhoneOtpUseCase;
  late MockVerifyPhoneOtpUseCase mockVerifyPhoneOtpUseCase;
  late MockResetPasswordUseCase mockResetPasswordUseCase;
  late MockSignOutUseCase mockSignOutUseCase;

  setUp(() {
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    mockSignInWithEmailUseCase = MockSignInWithEmailUseCase();
    mockSignUpWithEmailUseCase = MockSignUpWithEmailUseCase();
    mockSendPhoneOtpUseCase = MockSendPhoneOtpUseCase();
    mockVerifyPhoneOtpUseCase = MockVerifyPhoneOtpUseCase();
    mockResetPasswordUseCase = MockResetPasswordUseCase();
    mockSignOutUseCase = MockSignOutUseCase();

    authBloc = AuthBloc(
      getCurrentUserUseCase: mockGetCurrentUserUseCase,
      signInWithEmailUseCase: mockSignInWithEmailUseCase,
      signUpWithEmailUseCase: mockSignUpWithEmailUseCase,
      sendPhoneOtpUseCase: mockSendPhoneOtpUseCase,
      verifyPhoneOtpUseCase: mockVerifyPhoneOtpUseCase,
      resetPasswordUseCase: mockResetPasswordUseCase,
      signOutUseCase: mockSignOutUseCase,
    );

    registerFallbackValue(const NoParams());
    registerFallbackValue(
      const SignInWithEmailParams(email: '', password: ''),
    );
    registerFallbackValue(
      const SendPhoneOtpParams(phoneNumber: ''),
    );
  });

  const tUser = UserEntity(
    id: 'user_123',
    email: 'test@dhanra.com',
    phoneNumber: '+919876543210',
    displayName: 'Test User',
  );

  test('initial state should be AuthInitialState', () {
    expect(authBloc.state, AuthInitialState());
  });

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoadingState, AuthenticatedState] when AuthCheckRequestedEvent finds active user',
    build: () {
      when(() => mockGetCurrentUserUseCase(any()))
          .thenAnswer((_) async => (null, tUser));
      return authBloc;
    },
    act: (bloc) => bloc.add(AuthCheckRequestedEvent()),
    expect: () => [
      AuthLoadingState(),
      const AuthenticatedState(tUser),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoadingState, AuthenticatedState] when SignInWithEmailRequestedEvent is successful',
    build: () {
      when(() => mockSignInWithEmailUseCase(any()))
          .thenAnswer((_) async => (null, tUser));
      return authBloc;
    },
    act: (bloc) => bloc.add(
      const SignInWithEmailRequestedEvent(
        email: 'test@dhanra.com',
        password: 'password123',
      ),
    ),
    expect: () => [
      AuthLoadingState(),
      const AuthenticatedState(tUser),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoadingState, AuthFailureState] when SignInWithEmailRequestedEvent fails',
    build: () {
      when(() => mockSignInWithEmailUseCase(any())).thenAnswer(
        (_) async => (const AuthFailure('Invalid credentials'), null),
      );
      return authBloc;
    },
    act: (bloc) => bloc.add(
      const SignInWithEmailRequestedEvent(
        email: 'test@dhanra.com',
        password: 'wrongpassword',
      ),
    ),
    expect: () => [
      AuthLoadingState(),
      const AuthFailureState('Invalid credentials'),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoadingState, OtpSentState] when SendPhoneOtpRequestedEvent is successful',
    build: () {
      when(() => mockSendPhoneOtpUseCase(any()))
          .thenAnswer((_) async => (null, 'verification_id_123'));
      return authBloc;
    },
    act: (bloc) => bloc.add(
      const SendPhoneOtpRequestedEvent(phoneNumber: '+919876543210'),
    ),
    expect: () => [
      AuthLoadingState(),
      const OtpSentState(
        verificationId: 'verification_id_123',
        phoneNumber: '+919876543210',
      ),
    ],
  );
}
