import 'package:youyu/models/discover_item.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class NotificationModel {
  NotificationModel({
    required this.id,
    required this.dynamicId,
    required this.pid,
    required this.content,
    required this.createTime,
    required this.userInfo,
    this.dynamicInfo,
  });

  final int? id;

  @JsonKey(name: 'dynamic_id')
  final int? dynamicId;

  @JsonKey(name: 'dynamic_info')
  final DiscoverItem? dynamicInfo;

  final int? pid;

  @JsonKey(name: 'desc')
  final String? content;

  @JsonKey(name: 'create_time')
  final int? createTime;

  @JsonKey(name: 'user_info')
  final UserInfo? userInfo;

  static NotificationModel fromJson(Map<String, dynamic> json) {
    return NotificationModel(
        id: json['id'] as int? ?? 0,
        pid: json['pid'] as int? ?? 0,
        dynamicId: json['dynamic_id'] as int? ?? 0,
        content: json['desc'] as String? ?? '',
        createTime: json['create_time'] as int? ?? 0,
        userInfo: json['user_info'] != null
            ? UserInfo.fromJson(json['user_info'])
            : null,
        dynamicInfo: json['dynamic_info'] != null ? DiscoverItem.fromJson(json['dynamic_info']):null);
  }
}
