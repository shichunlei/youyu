import 'package:youyu/models/base_model.dart';
import 'package:youyu/models/room_detail_info.dart';
import 'package:youyu/services/live/live_service.dart';

class IMRoomSettingMsg extends BaseModel {
  IMRoomSettingMsg({required this.settingType, required this.roomInfo})
      : super.fromJson();

  final RoomDetailInfo roomInfo;
  final LiveSettingType settingType;

  @override
  factory IMRoomSettingMsg.fromJson(
          Map<String, dynamic> json) =>
      IMRoomSettingMsg(
          roomInfo: RoomDetailInfo.fromJson(json['roomInfo']),
          settingType:
              LiveSettingType.fromType(json['settingType'] as int? ?? 0));

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'roomInfo': roomInfo,
      'settingType': settingType.type
    };
  }
}
