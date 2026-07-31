import 'dart:convert';
import 'package:dhanra_new/core/error/exceptions.dart';
import 'package:dhanra_new/features/auth/data/models/user_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearCache();
}

const String cachedUserKey = 'CACHED_USER_KEY';

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final jsonString = _prefs.getString(cachedUserKey);
      if (jsonString != null) {
        return UserModel.fromJson(json.decode(jsonString) as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw const CacheException('Failed to retrieve cached user');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await _prefs.setString(cachedUserKey, json.encode(user.toJson()));
    } catch (e) {
      throw const CacheException('Failed to cache user session');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _prefs.remove(cachedUserKey);
    } catch (e) {
      throw const CacheException('Failed to clear cached user session');
    }
  }
}
