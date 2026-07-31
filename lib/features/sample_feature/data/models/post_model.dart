import 'package:dhanra_new/features/sample_feature/domain/entities/post.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
abstract class PostModel with _$PostModel {
  const factory PostModel({
    required int id,
    required int userId,
    required String title,
    required String body,
  }) = _PostModel;

  const PostModel._();

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  factory PostModel.fromEntity(Post post) => PostModel(
        id: post.id,
        userId: post.userId,
        title: post.title,
        body: post.body,
      );

  Post toEntity() => Post(
        id: id,
        userId: userId,
        title: title,
        body: body,
      );
}
