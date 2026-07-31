import 'package:dhanra_new/core/usecases/usecase.dart';
import 'package:dhanra_new/features/sample_feature/domain/usecases/get_posts_usecase.dart';
import 'package:dhanra_new/features/sample_feature/presentation/bloc/post_event.dart';
import 'package:dhanra_new/features/sample_feature/presentation/bloc/post_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc(this._getPostsUseCase) : super(const PostInitialState()) {
    on<FetchPostsEvent>(_onFetchPosts);
  }

  final GetPostsUseCase _getPostsUseCase;

  Future<void> _onFetchPosts(
    FetchPostsEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(const PostLoadingState());
    final (failure, posts) = await _getPostsUseCase(NoParams());
    if (failure != null) {
      emit(PostErrorState(failure.message));
    } else if (posts != null) {
      emit(PostLoadedState(posts));
    }
  }
}
