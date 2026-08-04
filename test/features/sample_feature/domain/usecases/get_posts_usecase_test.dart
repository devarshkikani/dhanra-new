import 'package:dhanra_new/core/error/failures.dart';
import 'package:dhanra_new/core/usecases/usecase.dart';
import 'package:dhanra_new/features/sample_feature/domain/entities/post.dart';
import 'package:dhanra_new/features/sample_feature/domain/repositories/post_repository.dart';
import 'package:dhanra_new/features/sample_feature/domain/usecases/get_posts_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostRepository extends Mock implements PostRepository {}

void main() {
  late GetPostsUseCase useCase;
  late MockPostRepository mockRepository;

  setUp(() {
    mockRepository = MockPostRepository();
    useCase = GetPostsUseCase(mockRepository);
  });

  const tPost = Post(
    id: 1,
    userId: 1,
    title: 'Test Title',
    body: 'Test Body',
  );
  final tPosts = [tPost];

  test('should return list of posts from repository', () async {
    // arrange
    when(() => mockRepository.getPosts())
        .thenAnswer((_) async => (null, tPosts));

    // act
    final result = await useCase(const NoParams());

    // assert
    expect(result, (null, tPosts));
    verify(() => mockRepository.getPosts()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ServerFailure when repository fails', () async {
    // arrange
    const tFailure = ServerFailure('Server Error');
    when(() => mockRepository.getPosts())
        .thenAnswer((_) async => (tFailure, null));

    // act
    final result = await useCase(const NoParams());

    // assert
    expect(result, (tFailure, null));
    verify(() => mockRepository.getPosts()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
