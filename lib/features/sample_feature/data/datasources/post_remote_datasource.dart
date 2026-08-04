import 'package:dhanra_new/core/error/exceptions.dart';
import 'package:dhanra_new/features/sample_feature/data/models/post_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getPosts();
}

@LazySingleton(as: PostRemoteDataSource)
class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  PostRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<PostModel>> getPosts() async {
    try {
      final response = await _dio.get<List<dynamic>>('/posts');
      if (response.statusCode == 200 && response.data != null) {
        return response.data!
            .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw const ServerException('Failed to load posts from remote server');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error occurred');
    }
  }
}
