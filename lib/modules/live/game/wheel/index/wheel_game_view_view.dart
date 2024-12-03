import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/models/gift_game.dart';
import 'package:youyu/modules/live/common/notification/send/live_index_send_msg.dart';
import 'package:youyu/modules/live/game/wheel/index/widget/wheel_ani_widget.dart';
import 'package:youyu/modules/live/game/wheel/index/widget/wheel_coin_widget.dart';
import 'package:youyu/modules/live/game/wheel/index/widget/wheel_nav_widget.dart';
import 'package:youyu/services/game/game_service.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/gift/model/common_gift_pop_model.dart';
import 'wheel_game_view_logic.dart';
import 'widget/wheel_turn_widget.dart';

class WheelGameViewPage extends StatefulWidget {
  const WheelGameViewPage({
    Key? key,
    required this.sendModel,
    required this.sendMsg,
  }) : super(key: key);
  final CommonGiftSendModel sendModel;
  final LiveIndexSendMsg sendMsg;

  @override
  State<WheelGameViewPage> createState() => _WheelGameViewPageState();
}

class _WheelGameViewPageState extends State<WheelGameViewPage>
    with SingleTickerProviderStateMixin {
  final logic = Get.put(WheelGameViewLogic());

  @override
  void initState() {
    super.initState();
    logic.sendMsg = widget.sendMsg;
    logic.sendModel = widget.sendModel;
  }

  @override
  Widget build(BuildContext context) {
    return AppStack(
      width: double.infinity,
      height: 524.w,
      children: [
        ///背景
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: AppLocalImage(
            path: AppResource().gameWheelBg,
            width: double.infinity,
          ),
        ),

        ///tab
        Obx(() => WheelGameNavWidget(
              viewType: logic.viewType.value,
              onTap: logic.onChangeType,
            )),

        ///内容
        Positioned(left: 0, right: 0, bottom: 0, child: _content()),

        Positioned(
            left: 7.w,
            top: 35.w,
            child: AppColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///金豆
                WheelCoinWidget(
                  onTap: () {
                    logic.gotoRecharge();
                  },
                ),

                ///动画开关
                // WheelAniWidget(
                //   margin: EdgeInsets.only(top: 6.h, left: 5.w),
                //   onTap: logic.openOrCloseAni,
                // )
              ],
            )),

        ///规则/说明
        Positioned(
            right: 12.w,
            top: 35.w,
            child: AppLocalImage(
              onTap: logic.openRule,
              path: AppResource().gameWheelRule,
              width: 87 / 2.w,
            )),
      ],
    );
  }

  ///内容
  _content() {
    return Obx(() => AppColumn(
          mainAxisAlignment: MainAxisAlignment.end,
          height: 473.w,
          margin: EdgeInsets.only(top: 18.w),
          children: [
            Expanded(
                child: WheelTurnWidget(
              key: logic.turnKey,
              images: logic.viewType.value == GameSubViewType.primary
                  ? GameService().primaryImages
                  : GameService().advancedImages,
              prices: logic.viewType.value == GameSubViewType.primary
                  ? GameService().primaryPrices
                  : GameService().advancedPrices,
              logic: logic,
            )),

            ///底部
            AppRow(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              height: 69.h,
              children: [
                Expanded(
                  child: AppLocalImage(
                      onTap: () {
                        logic.onSend(1);
                      },
                      path: logic.viewType.value == GameSubViewType.primary
                          ? AppResource().gameWheelCoinLeft1
                          : AppResource().gameWheelCoinLeft2),
                ),
                Expanded(
                  child: AppLocalImage(
                      onTap: () {
                        logic.onSend(5);
                      },
                      path: logic.viewType.value == GameSubViewType.primary
                          ? AppResource().gameWheelCoinCenter1
                          : AppResource().gameWheelCoinCenter2),
                ),
                Expanded(
                  child: AppLocalImage(
                      onTap: () {
                        logic.onSend(10);
                      },
                      path: logic.viewType.value == GameSubViewType.primary
                          ? AppResource().gameWheelCoinRight1
                          : AppResource().gameWheelCoinRight2),
                )
              ],
            ),
            SizedBox(
              height: 17.h,
            ),
          ],
        ));
  }
}
