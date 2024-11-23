import 'package:youyu/models/localmodel/user_tag_model.dart';
import 'package:youyu/models/dress.dart';
import 'package:youyu/models/room_list_item.dart';
import 'package:youyu/models/user_val.dart';
import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';
part 'my_getuserinfo.g.dart';

@JsonSerializable()
class UserInfo implements BaseModel {
  ///用户ID
  final int? id;

  ///是否显示靓号
  @JsonKey(name: 'is_fancy_number')
  final int? isFancyNumber;

  bool get isHighFancyNum => ((isFancyNumber ?? 0) == 1);

  ///靓号
  @JsonKey(name: 'fancy_number')
  final int? fancyNumber;

  ///是否实名认证
  @JsonKey(name: 'is_real')
  int? isReal;

  ///手机号
  String? mobile;

  ///昵称
  String? nickname;

  ///头像
  String? avatar;

  ///vip
  @JsonKey(name: 'is_vip')
  final int? is_vip;

  bool get isVip => ((is_vip ?? 0) == 1);

  @JsonKey(name: 'is_svip')
  final int? is_svip;

  bool get isSVip => ((is_svip ?? 0) == 1);

  ///金币余额 (茶豆)
  num? coins;

  //排行榜用到(茶豆/茶叶)
  @JsonKey(name: 'num')
  final String? numCoin;

  ///钻石余额
  num? diamonds;

  ///0:未知 1:男 2:女
  int? gender;

  ///个性签名
  String? signature;

  ///出生日期
  @JsonKey(name: 'birth_time')
  int? birthTime;

  ///在线状态1:在线,0:不在线
  @JsonKey(name: 'online_status')
  final int? onlineStatus;

  bool get isOnline => ((onlineStatus ?? 0) == 1);

  ///当前所在房间ID
  @JsonKey(name: 'online_room')
  final int? onlineRoom;

  ///状态1:启用,0:禁用
  final int? status;

  ///im信息
  @JsonKey(name: 'im_user_sig')
  final String? imUserSig;

  ///im 群id
  @JsonKey(name: 'group_id')
  String? imGroupId;

  ///用户经验值
  @JsonKey(name: 'user_val')
  final UserVal? userVal;

  ///地区
  final List<String>? region;

  ///兴趣
  final String? interest;

  ///是否拉黑了对方
  @JsonKey(name: 'is_block')
  int? isBlock;

  @JsonKey(name: 'is_cover_block')
  final int? isCoverBlock;

  ///关注人数
  @JsonKey(name: 'focus_count')
  final int? focusCount;

  ///关注直播间数
  @JsonKey(name: 'focus_room_count')
  final int? focusRoomCount;

  ///新增访客
  @JsonKey(name: 'access_unread_count')
  final int? focusNewCount;

  ///粉丝数
  @JsonKey(name: 'focus_me_count')
  final int? focusMeCount;

  ///比例
  @JsonKey(name: 'proportion')
  int? proportion;

  ///好友数
  @JsonKey(name: 'friend_count')
  final int? friendCount;

  ///谁看过我
  @JsonKey(name: 'access_count')
  final int? accessCount;

  ///是否创建了房间
  @JsonKey(name: 'this_room')
  final int? thisRoom;

  ///创建的房间信息
  @JsonKey(name: 'this_room_info')
  final RoomListItem? thisRoomInfo;

  ///是否显示游戏?
  @JsonKey(name: 'show_game')
  int? showGame;

  ///用户是否在直播
  @JsonKey(name: 'is_play')
  final int? is_play;

  bool get isPlay => ((is_play ?? 0) == 1);

  ///是否设置过密码
  @JsonKey(name: 'is_pass')
  int? isPass;

  //用户关注了我
  @JsonKey(name: 'user_is_focus_me')
  final int? userIsFocusMe;

  //我关注了用户
  @JsonKey(name: 'me_is_focus_user')
  int? meIsFocusUser;

  bool get isFocus => ((meIsFocusUser ?? 0) == 1);

  //是否是好友
  @JsonKey(name: 'is_friend')
  final int? isFriend;

  //是否是管理
  @JsonKey(name: 'is_manage')
  int? isManage;

  //直播间使用   0 没禁言  1 禁言了
  @JsonKey(name: 'is_muted')
  int? isMuted;

  //公会id
  @JsonKey(name: 'union_id')
  String? unionId;

  //公会名称
  @JsonKey(name: 'union_name')
  final String? unionName;

  //装扮
  final List<DressInfo>? dress;

  //用户标签，本地处理
  List<UserTagModel>? _userTagList;

  List<UserTagModel> get userTagList {
    _userTagList ??= UserTagModel.userTags(this);
    return _userTagList!;
  }

  ///头环
  DressInfo? _dressHead;

  DressInfo? dressHead() {
    if (_dressHead == null && dress != null) {
      for (DressInfo value in dress!) {
        if (value.type == 1) {
          _dressHead = value;
          break;
        }
      }
    }
    return _dressHead;
  }

  ///音麦
  DressInfo? _dressWheat;

  DressInfo? dressWheat() {
    if (_dressWheat == null && dress != null) {
      for (DressInfo value in dress!) {
        if (value.type == 3) {
          _dressWheat = value;
          break;
        }
      }
    }
    return _dressWheat;
  }

  ///座驾
  DressInfo? _dressCar;

  DressInfo? dressCar() {
    if (_dressCar == null && dress != null) {
      for (DressInfo value in dress!) {
        if (value.type == 4) {
          _dressCar = value;
          break;
        }
      }
    }
    return _dressCar;
  }

  UserInfo(
      {required this.id,
      this.isManage,
      this.isCoverBlock,
      this.isFancyNumber,
      this.fancyNumber = 0,
      this.is_vip,
      this.is_svip,
      this.dress,
      this.mobile = '',
      this.nickname = '',
      this.avatar = '',
      this.coins = 0,
      this.diamonds = 0,
      this.gender = 0,
      this.signature = '',
      this.birthTime = 0,
      this.onlineStatus = 0,
      this.onlineRoom = 0,
      this.status = 1,
      this.region = const [],
      this.interest = '',
      this.accessCount = 0,
      this.focusCount = 0,
      this.focusMeCount = 0,
      this.friendCount = 0,
      this.imGroupId = '',
      this.thisRoom = 0,
      this.userVal,
      this.isReal,
      this.imUserSig = '',
      this.isFriend = 0,
      this.meIsFocusUser = 0,
      this.userIsFocusMe = 0,
      this.showGame = 0,
      this.thisRoomInfo,
      this.focusRoomCount,
      this.focusNewCount,
      this.isBlock,
      this.is_play,
      this.numCoin,
      this.isMuted,
      this.isPass,
      this.unionName,
      this.unionId,
      this.proportion});

  @override
  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}
