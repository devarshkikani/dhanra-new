import 'package:dhanra_new/core/error/exceptions.dart';
import 'package:dhanra_new/core/error/failures.dart';
import 'package:dhanra_new/core/network/network_info.dart';
import 'package:dhanra_new/features/sample_feature/data/datasources/post_local_datasource.dart';
import 'package:dhanra_new/features/sample_feature/data/datasources/post_remote_datasource.dart';
import 'package:dhanra_new/features/sample_feature/domain/entities/post.dart';
import 'package:dhanra_new/features/sample_feature/domain/repositories/post_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PostRepository)
class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  final PostRemoteDataSource remoteDataSource;
  final PostLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<(Failure?, List<Post>?)> getPosts() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteModels = await remoteDataSource.getPosts();
        await localDataSource.cachePosts(remoteModels);
        final posts = remoteModels.map((m) => m.toEntity()).toList();
        return (null, posts);
      } on ServerException catch (e) {
        return (ServerFailure(e.message), null);
      }
    } else {
      try {
        final localModels = await localDataSource.getLastPosts();
        final posts = localModels.map((m) => m.toEntity()).toList();
        return (null, posts);
      } on CacheException catch (e) {
        return (CacheFailure(e.message), null);
      }
    }
  }
}
