import 'package:youyu/models/localmodel/user_tag_model.dart';
import 'package:youyu/models/my_getuserinfo.dart';

///直播间消息类型
enum LiveMessageType {
  topSpace, //顶部占位（本地处理）
  announcement, //房间公告消息&欢迎语
  text, //文字消息
  join, //加入房间消息
  leave, //离开房间消息
  gift, //礼物消息
  luckGift, //福袋礼物消息
  manager, //管理消息
  groupAt, //at消息
  game, //抽奖(游戏)公告 （暂时用不到，预留）
  vip, //vip
  tagLevel; //标签等级
}

class LiveMessageModel<T> {
  LiveMessageModel(
      {required this.type,
      required this.isManager,
      this.userInfo,
      required this.data,
      this.timestamp}) {
    if (isManager && userInfo != null) {
      List<UserTagModel> userTagList = userInfo!.userTagList;
      if (userTagList.isNotEmpty) {
        userInfo?.userTagList.insert(
            userTagList.length - 1, UserTagModel(type: UserTagType.manger));
      } else {
        userInfo?.userTagList.add(UserTagModel(type: UserTagType.manger));
      }
    }
  }

  //消息类型
  final LiveMessageType type;

  //是否是管理员发的消息
  final bool isManager;

  //发送者的用户信息
  UserInfo? userInfo;

  //数据
  T? data;

  //时间戳
  int? timestamp;
}
