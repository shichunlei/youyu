// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discover_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiscoverCommentModel _$DiscoverCommentModelFromJson(
        Map<String, dynamic> json) =>
    DiscoverCommentModel(
      id: json['id'] as int? ?? 0,
      pid: json['pid'] as int? ?? 0,
      dynamicId: json['dynamic_id'] as int? ?? 0,
      time: json['create_time'] as int? ?? 0,
      content: json['desc'] as String? ?? '',
      likeCount: json['like_count'] as int? ?? 0,
      isLike: json['is_like'] as int? ?? 0,
      userInfo: json['user_info'] == null
          ? null
          : UserInfo.fromJson(json['user_info'] as Map<String, dynamic>),
      isReply: json['is_reply'] as int? ?? 0,
      reply: json['reply'] as String? ?? '',
    );

Map<String, dynamic> _$DiscoverCommentModelToJson(
        DiscoverCommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pid': instance.pid,
      'dynamic_id': instance.dynamicId,
      'create_time': instance.time,
      'desc': instance.content,
      'like_count': instance.likeCount,
      'is_like': instance.isLike,
      'user_info': instance.userInfo,
      'is_reply': instance.isReply,
      'reply': instance.reply
    };
