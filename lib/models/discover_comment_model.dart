import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';
import 'my_getuserinfo.dart';
part 'discover_comment_model.g.dart';

@JsonSerializable()
class DiscoverCommentModel implements BaseModel {

  final int? id;
  final int? pid;

  @JsonKey(name: 'dynamic_id')
  final int? dynamicId;

  @JsonKey(name: 'create_time')
  final int? time;

  @JsonKey(name: 'desc')
  final String? content;

  @JsonKey(name: 'user_info')
  final UserInfo? userInfo;

  @JsonKey(name: 'like_count')
  int? likeCount;

  @JsonKey(name: 'is_like')
  int? isLike;

  @JsonKey(name: 'is_reply')
  final int isReply;

  final String? reply;


  DiscoverCommentModel(
      {required this.content,
      required this.userInfo,
      required this.time,
      required this.id,
      required this.pid,
      required this.dynamicId,
      required this.likeCount,
      required this.isLike,
      required this.isReply,
        this.reply, });

  @override
  factory DiscoverCommentModel.fromJson(Map<String, dynamic> json) =>
      _$DiscoverCommentModelFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$DiscoverCommentModelToJson(this);
}
