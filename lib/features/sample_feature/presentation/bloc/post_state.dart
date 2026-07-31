import 'package:equatable/equatable.dart';
import 'package:dhanra_new/features/sample_feature/domain/entities/post.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

class PostInitialState extends PostState {
  const PostInitialState();
}

class PostLoadingState extends PostState {
  const PostLoadingState();
}

class PostLoadedState extends PostState {
  const PostLoadedState(this.posts);

  final List<Post> posts;

  @override
  List<Object?> get props => [posts];
}

class PostErrorState extends PostState {
  const PostErrorState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
