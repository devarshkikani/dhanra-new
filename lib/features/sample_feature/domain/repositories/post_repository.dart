import 'package:dhanra_new/core/error/failures.dart';
import 'package:dhanra_new/features/sample_feature/domain/entities/post.dart';

abstract class PostRepository {
  Future<(Failure?, List<Post>?)> getPosts();
}
