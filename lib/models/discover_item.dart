import 'package:audioplayers/audioplayers.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

part 'discover_item.g.dart';

@JsonSerializable()
class DiscoverItem implements BaseModel {
  ///动态id
  @JsonKey(name: 'id')
  final int? id;

  ///动态图片
  @JsonKey(name: 'imgs')
  final List<String>? images;

  ///动态文案
  @JsonKey(name: 'desc')
  final String? content;

  ///动态语音
  @JsonKey(name: 'tape')
  final String? audio;

  //语音时间
  @JsonKey(name: 'tape_s')
  final num? audioTime;

  ///是否点赞
  @JsonKey(name: 'is_like')
  int? isLike;

  //点赞数量
  @JsonKey(name: 'like')
  int? like;

  //时间
  @JsonKey(name: 'create_time')
  final int? createTime;

  @JsonKey(name: 'user_info')
  final UserInfo? userInfo;

  //评论数量
  @JsonKey(name: 'coment_count')
  int? commentCount;

  int curTime = 0;
  PlayerState playerState = PlayerState.stopped;

  DiscoverItem(
      {required this.id,
      required this.content,
      required this.images,
      required this.audio,
      required this.isLike,
      required this.like,
      required this.createTime,
      required this.userInfo,
      required this.audioTime,
      required this.commentCount}) {
    curTime = (audioTime ?? 0.0).toInt();
  }

  @override
  factory DiscoverItem.fromJson(Map<String, dynamic> json) =>
      _$DiscoverItemFromJson(json);

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
