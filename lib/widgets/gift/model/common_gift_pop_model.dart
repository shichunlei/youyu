import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/gift.dart';
import 'package:youyu/models/my_getuserinfo.dart';

///礼物选择用户信息
class GiftUserPositionInfo {
  //用户信息
  final UserInfo user;

  //用户索引
  final int position;

  GiftUserPositionInfo({
    required this.position,
    required this.user,
  });
}

///礼物数量
class CommonGiftCountModel {
  CommonGiftCountModel({required this.count, required this.name});

  final int count;
  final String name;
}

///选择赠送的模型
class CommonGiftSendModel {
  CommonGiftSendModel(
      {this.roomId,
      this.receiver,
      required this.giftTypeId,
      required this.giftCount,
      required this.gift});

  //直播间id
  final int? roomId;

  //发送人信息
  final UserInfo sender = UserController.imUserInfo();

  //选择的用户(接收多人)
  List<GiftUserPositionInfo>? selUserPosInfo;

  //接收人（接收单人）
  final UserInfo? receiver;

  ///公用
  //礼物模型
  final Gift gift;

  //礼物类型id
  final int giftTypeId;

  //礼物的数量
  final int giftCount;

}
