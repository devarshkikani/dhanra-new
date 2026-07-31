import 'dart:convert';
import 'package:dhanra_new/core/constants/app_constants.dart';
import 'package:dhanra_new/core/error/exceptions.dart';
import 'package:dhanra_new/features/sample_feature/data/models/post_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PostLocalDataSource {
  Future<List<PostModel>> getLastPosts();
  Future<void> cachePosts(List<PostModel> postsToCache);
}

@LazySingleton(as: PostLocalDataSource)
class PostLocalDataSourceImpl implements PostLocalDataSource {
  PostLocalDataSourceImpl(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  @override
  Future<List<PostModel>> getLastPosts() async {
    final jsonString = _sharedPreferences.getString(AppConstants.postsCacheKey);
    if (jsonString != null) {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw const CacheException('No cached posts found');
    }
  }

  @override
  Future<void> cachePosts(List<PostModel> postsToCache) async {
    final jsonList = postsToCache.map((post) => post.toJson()).toList();
    await _sharedPreferences.setString(
      AppConstants.postsCacheKey,
      jsonEncode(jsonList),
    );
  }
}
