import 'package:youyu/widgets/gift/model/common_gift_pop_model.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/auth_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/gift_tab.dart';
import 'package:youyu/models/lucky_gift.dart';
import 'package:youyu/services/im/model/ext/im_gift_model.dart';
import 'package:youyu/services/im/model/im_custom_message_mdoel.dart';
import 'package:youyu/services/im/model/im_msg_type.dart';
import 'package:youyu/services/im/im_service.dart';
import 'package:get/get.dart';
import '../models/gift.dart';
import 'base/base_controller.dart';

///礼物管理
class GiftController extends AppBaseController {
  static GiftController get to => Get.find<GiftController>();

  /// 礼物总列表
  RxList<GiftTab> giftList = <GiftTab>[].obs;

  /// 背包礼物列表
  final RxList<Gift> _backpackList = <Gift>[].obs;

  ///背包礼物类型id标识
  static int backPackId = -99;

  ///福袋礼物标识
  static int ftId = 2;

  ///加载礼物信息
  onInitData(List<GiftTab> list) {
    GiftController.to.giftList.value = list;
  }

  Future<List<Gift>> fetchBackPack({bool foreUpdate = false}) async {
    //获取背包礼物
    if (_backpackList.isNotEmpty && !foreUpdate) return _backpackList;
    if (AuthController.to.isLogin) {
      try {
        var value = await request(AppApi.giftBackPackUrl);
        var list =
            (value.data as List<dynamic>).map((e) => Gift.fromJson(e)).toList();
        _backpackList.value = list;
      } catch (e) {
        e.printError();
      }
    }
    return _backpackList;
  }

  /// 会话聊天送礼物
  msgSendGift(CommonGiftSendModel? sendModel) async {
    if (sendModel != null) {
      // showCommit();
      try {
        await request(AppApi.msgSendGiftUrl, params: {
          "to_user_ids": sendModel.receiver?.id,
          "type": sendModel.giftTypeId == GiftController.backPackId ? 2 : 1,
          "gift_id": sendModel.gift.id,
          "count": sendModel.giftCount
        });
        //更新用户信息
        UserController.to.updateMyInfo();
        Gift copyGift = Gift.fromJson(sendModel.gift.toJson());
        copyGift.count = sendModel.giftCount;
        IMGiftModel giftModel =
            IMGiftModel(gift: copyGift, receiver: sendModel.receiver);

        //TODO:后面再区分福袋礼物
        IMCustomMessageModel<IMGiftModel> model = IMCustomMessageModel(
            userInfo: UserController.imUserInfo(),
            data: giftModel,
            timestamp: DateTime.now().millisecondsSinceEpoch);
        try {
          var v2timValueCallback = await IMService().sendC2CCustomMsg(
              model, IMMsgType.gift.type,
              receiver: sendModel.receiver?.id.toString());
          if (v2timValueCallback.code == 0) {
            return v2timValueCallback.data;
          }
        } catch (e) {
          //...
        }
      } catch (e) {
        hiddenCommit();
      }
    }
  }

  ///直播间赠送普通礼物
  liveSendNormalGift(
      CommonGiftSendModel? sendModel,
      Function(IMCustomMessageModel<IMGiftModel> model, bool isLast) onSend,
      bool isSupportGift) async {
    if (sendModel != null) {
      // showCommit();
      try {
        Map<String, dynamic> params = {
          'room_id': sendModel.roomId,
          "type": sendModel.giftTypeId == GiftController.backPackId ? 2 : 1,
          "to_user_ids": sendModel.selUserPosInfo
              ?.map((e) => e.user.id.toString())
              .toList()
              .join(","),
          "gift_id": sendModel.gift.id,
          "count": sendModel.giftCount
        };

        if (isSupportGift) {
          params["assist_user_id"] = sendModel.selUserPosInfo
              ?.map((e) => e.user.id.toString())
              .toList()
              .join(",");
        }

        await request(AppApi.liveGiftSendUrl, params: params);
        //更新用户信息
        UserController.to.updateMyInfo();
        Gift copyGift = Gift.fromJson(sendModel.gift.toJson());
        copyGift.count = sendModel.giftCount;
        bool isPlaySvg = (copyGift.playSvg == 1);

        ///普通礼物
        for (int i = 0; i < sendModel.selUserPosInfo!.length; i++) {
          bool isLast = i == (sendModel.selUserPosInfo!.length - 1);
          if (isLast) {
            ///只有最后一条才播放svg
            if (isPlaySvg) {
              copyGift.playSvg = 1;
            }
          } else {
            copyGift.playSvg = 0;
          }
          GiftUserPositionInfo posInfo = sendModel.selUserPosInfo![i];
          IMGiftModel giftModel =
              IMGiftModel(gift: copyGift, receiver: posInfo.user);
          IMCustomMessageModel<IMGiftModel> model = IMCustomMessageModel(
              userInfo: UserController.imUserInfo(),
              data: giftModel,
              timestamp: DateTime.now().millisecondsSinceEpoch);
          onSend(model, isLast);
        }
      } catch (e) {
        //...
      }
    }
  }

  ///直播间送福袋礼物
  liveSendLuckyGift(
      CommonGiftSendModel? sendModel,
      Function(IMCustomMessageModel<IMGiftModel> model, bool isLast) onSend,
      bool isSupportGift,Function() onError) async {
    if (sendModel != null) {
      // showCommit();
      try {
        Map<String, dynamic> params = {
          'room_id': sendModel.roomId,
          "type": sendModel.giftTypeId == GiftController.backPackId ? 2 : 1,
          "to_user_ids": sendModel.selUserPosInfo
              ?.map((e) => e.user.id.toString())
              .toList()
              .join(","),
          "gift_id": sendModel.gift.id,
          "count": sendModel.giftCount
        };

        if (isSupportGift) {
          params["assist_user_id"] = sendModel.selUserPosInfo
              ?.map((e) => e.user.id.toString())
              .toList()
              .join(",");
        }
        var value = await request(AppApi.liveGiftSendUrl, params: params);
        //更新用户信息
        UserController.to.updateMyInfo();

        //福袋礼物
        List<dynamic> list = value.data['list'];
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = list[i];
          LuckyGift entity = LuckyGift.fromJson(map);
          entity.gift.count = sendModel.giftCount;

          bool isLast = i == (list.length - 1);

          ///只有最后一条才播放svg
          if (!isLast) {
            for (Gift subGift in entity.gift.childList!) {
              subGift.playSvg = 0;
            }
          }
          IMGiftModel luckyModel =
              IMGiftModel(gift: entity.gift, receiver: entity.userInfo);
          IMCustomMessageModel<IMGiftModel> model = IMCustomMessageModel(
              userInfo: UserController.imUserInfo(),
              data: luckyModel,
              timestamp: DateTime.now().millisecondsSinceEpoch);
          onSend(model, isLast);
        }
      } catch (e) {
        //...
        onError();
      }
    }
  }
}
