import 'package:dhanra_new/core/error/failures.dart';
import 'package:dhanra_new/features/auth/domain/entities/user_entity.dart';
import 'package:dhanra_new/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:dhanra_new/features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late SignInWithEmailUseCase useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = SignInWithEmailUseCase(mockAuthRepository);
  });

  const tEmail = 'test@dhanra.com';
  const tPassword = 'password123';
  const tUserEntity = UserEntity(
    id: 'user_123',
    email: tEmail,
    phoneNumber: '+919876543210',
    displayName: 'Test User',
  );

  test(
    'should return UserEntity when repository sign in is successful',
    () async {
      when(
        () => mockAuthRepository.signInWithEmail(
          email: tEmail,
          password: tPassword,
        ),
      ).thenAnswer((_) async => (null, tUserEntity));

      final result = await useCase(
        const SignInWithEmailParams(email: tEmail, password: tPassword),
      );

      expect(result, (null, tUserEntity));
      verify(
        () => mockAuthRepository.signInWithEmail(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );

  test(
    'should return AuthFailure when repository sign in fails',
    () async {
      const tFailure = AuthFailure('Invalid credentials');
      when(
        () => mockAuthRepository.signInWithEmail(
          email: tEmail,
          password: tPassword,
        ),
      ).thenAnswer((_) async => (tFailure, null));

      final result = await useCase(
        const SignInWithEmailParams(email: tEmail, password: tPassword),
      );

      expect(result, (tFailure, null));
      verify(
        () => mockAuthRepository.signInWithEmail(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );
}
