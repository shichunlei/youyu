import 'package:youyu/models/base_model.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/services/im/model/ext/im_forbidden_model.dart';
import 'package:youyu/services/im/model/ext/im_group_at_model.dart';
import 'package:youyu/services/im/model/ext/im_hug_up_mic_model.dart';
import 'package:youyu/services/im/model/ext/im_kick_out_model.dart';
import 'package:youyu/services/im/model/ext/im_live_text_model.dart';
import 'package:youyu/services/im/model/ext/im_manager_model.dart';
import 'package:youyu/services/im/model/ext/im_room_setting_model.dart';
import 'package:youyu/services/im/model/ext/im_screen_speak_model.dart';
import 'package:youyu/services/im/model/ext/im_slide_gift_model.dart';
import 'package:youyu/services/im/model/im_msg_type.dart';
import 'ext/im_gift_model.dart';

class IMCustomMessageModel<T extends BaseModel> {
  IMCustomMessageModel(
      {this.userInfo, this.data, this.timestamp, this.loss_time});

  //用户信息
  final UserInfo? userInfo;

  //数据
  T? data;

  //时间戳
  final int? timestamp;

  final int? loss_time;

  @override
  factory IMCustomMessageModel.fromJson(
      IMMsgType messageType, Map<String, dynamic> json) {
    IMCustomMessageModel<T> model = IMCustomMessageModel(
        userInfo: json['userInfo'] != null
            ? UserInfo.fromJson(json['userInfo'] as Map<String, dynamic>)
            : UserInfo.fromJson(json['user_info'] as Map<String, dynamic>),
        timestamp: json['timestamp'] as int? ?? 0,
        data: null,
        loss_time: json['loss_time'] as int? ?? 0);

    if (json['data'] != null) {
      Map<String, dynamic> jsonData = json['data'];
      switch (messageType) {
        case IMMsgType.liveRoomText:
          model.data = IMLiveTextMsg.fromJson(jsonData) as T?;
          break;
        case IMMsgType.gift:
        case IMMsgType.luckyGift:
          model.data = IMGiftModel.fromJson(jsonData) as T?;
          break;
        case IMMsgType.joinRoom:
          model.data = IMLiveTextMsg.fromJson(jsonData) as T?;
          break;
        case IMMsgType.slideGift:
          model.data = IMSlideGiftModel.fromJson(jsonData) as T?;
          break;
        case IMMsgType.screenSpeak:
          model.data = IMScreenSpeakMsg.fromJson(jsonData) as T?;
          break;
        case IMMsgType.roomSetting:
          model.data = IMRoomSettingMsg.fromJson(jsonData) as T?;
          break;
        case IMMsgType.manager:
          model.data = IMSyncManagerMsg.fromJson(jsonData) as T?;
          break;
        case IMMsgType.groupAt:
          model.data = IMGroupAtTextMsg.fromJson(jsonData) as T?;
          break;
        case IMMsgType.hugUpMicMsg:
          model.data = IMHugUpMicMsg.fromJson(jsonData) as T?;
          break;
        case IMMsgType.forbidden:
          model.data = IMForbiddenMsg.fromJson(jsonData) as T?;
          break;
        case IMMsgType.kickOut:
          model.data = IMKickOutMsg.fromJson(jsonData) as T?;
          break;
        default:
          break;
      }
    }

    return model;
  }

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson(IMMsgType messageType) {
    Map<String, dynamic> jsonMap = {
      'userInfo': _toIMJson(userInfo),
      'timestamp': timestamp,
      'loss_time': loss_time
    };
    switch (messageType) {
      case IMMsgType.liveRoomText:
        jsonMap['data'] = (data as IMLiveTextMsg).toJson();
        break;
      case IMMsgType.gift:
      case IMMsgType.luckyGift:
        jsonMap['data'] = (data as IMGiftModel).toJson();
        break;
      case IMMsgType.joinRoom:
        jsonMap['data'] = (data as IMLiveTextMsg).toJson();
        break;
      case IMMsgType.slideGift:
        jsonMap['data'] = (data as IMSlideGiftModel).toJson();
        break;
      case IMMsgType.screenSpeak:
        jsonMap['data'] = (data as IMScreenSpeakMsg).toJson();
        break;
      case IMMsgType.roomSetting:
        jsonMap['data'] = (data as IMRoomSettingMsg).toJson();
        break;
      case IMMsgType.manager:
        jsonMap['data'] = (data as IMSyncManagerMsg).toJson();
        break;
      case IMMsgType.groupAt:
        jsonMap['data'] = (data as IMGroupAtTextMsg).toJson();
        break;
      case IMMsgType.hugUpMicMsg:
        jsonMap['data'] = (data as IMHugUpMicMsg).toJson();
        break;
      case IMMsgType.forbidden:
        jsonMap['data'] = (data as IMForbiddenMsg).toJson();
        break;
      case IMMsgType.kickOut:
        jsonMap['data'] = (data as IMKickOutMsg).toJson();
        break;
      default:
        break;
    }
    return jsonMap;
  }

  Map<String, dynamic> _toIMJson(UserInfo? instance) {
    if (instance == null) return {};
    return {
      'id': instance.id,
      'fancy_number': instance.fancyNumber,
      'is_fancy_number': instance.isFancyNumber,
      'nickname': instance.nickname,
      'avatar': instance.avatar,
      'gender': instance.gender,
      'user_val': instance.userVal,
      'dress': instance.dress
    };
  }
}
