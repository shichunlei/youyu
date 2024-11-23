import 'dart:ui';

import 'package:get/get.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/gift.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/modules/live/common/interactor/pop/gift/give/live_give_gift_logic.dart';
import 'package:youyu/modules/live/index/live_index_logic.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/material.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:youyu/widgets/gift/model/common_gift_pop_model.dart';
import 'package:youyu/widgets/user/user_avatar_state_widget.dart';

///酒吧送礼弹窗
class LivePopGiveGift extends StatefulWidget {
  const LivePopGiveGift({
    required this.gift,
    required this.userlist,
    super.key,
  });

  final Gift gift;
  final List<UserInfo?> userlist;

  @override
  State<LivePopGiveGift> createState() => LivePopGiveGiftState();
}

class LivePopGiveGiftState extends State<LivePopGiveGift>
    with SingleTickerProviderStateMixin {
  final logic = Get.put(LiveGiveGiftLogic());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: AppColumn(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            width: double.infinity,
            padding: EdgeInsets.only(top: 10.h),
            color: const Color(0x99181818),
            topRightRadius: 12.w,
            topLeftRadius: 12.w,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.userlist.length > 1)
                        Expanded(
                          child: Center(
                            child: Text(
                              '赠送全麦',
                              style: AppTheme().textStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                              ),
                            ),
                          ),
                        )
                      else ...[
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '赠送',
                              style: AppTheme().textStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20.w), // 添加间距
                        Center(
                          child: UserAvatarStateWidget(
                            avatar: widget.userlist[0]?.avatar ?? '',
                            size: 46.w,
                            userInfo: widget.userlist[0],
                          ),
                        ),
                        SizedBox(width: 20.w), // 添加间距
                        Expanded(
                          child: Text(
                            widget.userlist[0]?.nickname ?? '',
                            style: AppTheme().textStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  _giftItem(widget.gift),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(20.h),
                child: AppColorButton(
                  title: '确定',
                  width: 326.w,
                  height: 56.h,
                  titleColor: AppTheme.colorTextWhite,
                  bgGradient: AppTheme().btnGradient,
                  // bgColor: Colors.transparent,
                  onClick: () {
                    print('赠送酒吧礼物');

                    /// 构建单个送礼消息
                    CommonGiftSendModel sendModel = CommonGiftSendModel(
                      gift: widget.gift,
                      giftCount: 1,
                      giftTypeId: 1,
                      roomId: LiveIndexLogic.to.roomId,
                      // receiver: widget.user,
                    );
                    //多用户
                    sendModel.selUserPosInfo = [];

                    for (var user in widget.userlist) {
                      GiftUserPositionInfo userInfo =
                          GiftUserPositionInfo(position: 0, user: user!);
                      //过滤掉自己
                      if (user.id != UserController.to.id) {
                        sendModel.selUserPosInfo?.add(userInfo);
                      }
                    }

                    LiveIndexLogic.to.notification?.sendMsg
                        .sendGift(sendModel, false);
                  },
                ),
              )
            ],
          )),
    );
  }

  Widget _giftItem(Gift? gift) {
    return Center(
      child: AppContainer(
        strokeColor: Colors.transparent,
        strokeWidth: 1.w,
        // gradient: isSelected ? AppTheme().btnGradient : null,
        // width: 76.w,
        // height: 41.h,
        color: Colors.black.withOpacity(0.4),
        // onTap: () {
        //   logic.selectIndex.value = list[index]!.id;
        // },
        radius: 7.w,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 14.h),
              child: AppNetImage(
                width: 33.w,
                height: 33.h,
                imageUrl: gift!.image,
                fit: BoxFit.contain,
                defaultWidget: const SizedBox.shrink(),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Center(
                child: Text(gift.name,
                    style: AppTheme()
                        .textStyle(fontSize: 17.sp, color: Colors.white))),
            SizedBox(
              height: 2.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppLocalImage(
                  path: AppResource().coin2,
                  width: 9.w,
                ),
                SizedBox(
                  width: 2.w,
                ),
                Text(
                  "${gift.unitPrice}",
                  style: AppTheme().textStyle(
                      fontSize: 10.sp, color: AppTheme.colorTextWhite),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
