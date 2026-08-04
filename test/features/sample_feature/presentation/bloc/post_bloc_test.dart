import 'package:bloc_test/bloc_test.dart';
import 'package:dhanra_new/core/error/failures.dart';
import 'package:dhanra_new/core/usecases/usecase.dart';
import 'package:dhanra_new/features/sample_feature/domain/entities/post.dart';
import 'package:dhanra_new/features/sample_feature/domain/usecases/get_posts_usecase.dart';
import 'package:dhanra_new/features/sample_feature/presentation/bloc/post_bloc.dart';
import 'package:dhanra_new/features/sample_feature/presentation/bloc/post_event.dart';
import 'package:dhanra_new/features/sample_feature/presentation/bloc/post_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPostsUseCase extends Mock implements GetPostsUseCase {}

void main() {
  late PostBloc postBloc;
  late MockGetPostsUseCase mockGetPostsUseCase;

  setUp(() {
    mockGetPostsUseCase = MockGetPostsUseCase();
    postBloc = PostBloc(mockGetPostsUseCase);
  });

  tearDown(() {
    postBloc.close();
  });

  const tPost = Post(
    id: 1,
    userId: 1,
    title: 'Test Title',
    body: 'Test Body',
  );
  final tPosts = [tPost];

  test('initial state should be PostInitialState', () {
    expect(postBloc.state, equals(const PostInitialState()));
  });

  blocTest<PostBloc, PostState>(
    'emits [PostLoadingState, PostLoadedState] when FetchPostsEvent is successful',
    build: () {
      when(() => mockGetPostsUseCase(const NoParams()))
          .thenAnswer((_) async => (null, tPosts));
      return postBloc;
    },
    act: (bloc) => bloc.add(const FetchPostsEvent()),
    expect: () => [
      const PostLoadingState(),
      PostLoadedState(tPosts),
    ],
    verify: (_) {
      verify(() => mockGetPostsUseCase(const NoParams())).called(1);
    },
  );

  blocTest<PostBloc, PostState>(
    'emits [PostLoadingState, PostErrorState] when FetchPostsEvent fails',
    build: () {
      when(() => mockGetPostsUseCase(const NoParams())).thenAnswer(
        (_) async => (const ServerFailure('Failed to fetch posts'), null),
      );
      return postBloc;
    },
    act: (bloc) => bloc.add(const FetchPostsEvent()),
    expect: () => [
      const PostLoadingState(),
      const PostErrorState('Failed to fetch posts'),
    ],
    verify: (_) {
      verify(() => mockGetPostsUseCase(const NoParams())).called(1);
    },
  );
}
