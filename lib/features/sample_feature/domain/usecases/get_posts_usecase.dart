import 'package:dhanra_new/core/error/failures.dart';
import 'package:dhanra_new/core/usecases/usecase.dart';
import 'package:dhanra_new/features/sample_feature/domain/entities/post.dart';
import 'package:dhanra_new/features/sample_feature/domain/repositories/post_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetPostsUseCase implements UseCase<(Failure?, List<Post>?), NoParams> {
  GetPostsUseCase(this.repository);

  final PostRepository repository;

  @override
  Future<(Failure?, List<Post>?)> call(NoParams params) async {
    return repository.getPosts();
  }
}
