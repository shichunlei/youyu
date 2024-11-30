import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/modules/live/game/wheel/index/widget/wheel_ani_widget.dart';
import 'package:youyu/modules/live/game/wheel/index/widget/wheel_coin_widget.dart';
import 'package:youyu/modules/live/game/wheel/index/widget/wheel_nav_widget.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/gift/model/common_gift_pop_model.dart';
import 'dart:ui' as ui;
import 'wheel_game_view_logic.dart';
import 'widget/wheel_turn_widget.dart';

class WheelGameViewPage extends StatefulWidget {
  WheelGameViewPage(
      {Key? key,
      required this.sendModel,
      required this.images,
      required this.prices})
      : super(key: key);
  final CommonGiftSendModel sendModel;
  final List<ui.Image> images;
  final List<String> prices;

  @override
  State<WheelGameViewPage> createState() => _WheelGameViewPageState();
}

class _WheelGameViewPageState extends State<WheelGameViewPage>
    with SingleTickerProviderStateMixin {
  final logic = Get.put(WheelGameViewLogic());

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
              onTap: (WheelGameViewType viewType) {
                logic.viewType.value = viewType;
              },
            )),

        ///内容
        _content(),

        Positioned(
            left: 7.w,
            top: 35.w,
            child: AppColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///金豆
                const WheelCoinWidget(),

                ///动画开关
                WheelAniWidget(
                  margin: EdgeInsets.only(top: 6.h, left: 5.w),
                  onTap: logic.openOrCloseAni,
                )
              ],
            )),

        ///规则/说明
        Positioned(
            right: 12.w,
            top: 35.w,
            child: AppLocalImage(
              path: AppResource().gameWheelRule,
              width: 87 / 2.w,
            )),
      ],
    );
  }

  ///内容
  _content() {
    return AppColumn(
      margin: EdgeInsets.only(top: 18.w),
      children: [
        Expanded(
            child: WheelTurnWidget(
          images: widget.images,
          prices: widget.prices,
        )),

        ///底部
        Obx(() => AppRow(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              height: 69.h,
              children: [
                Expanded(
                  child: AppLocalImage(
                      onTap: () {
                        logic.onSend(1);
                      },
                      path: logic.viewType.value == WheelGameViewType.primary
                          ? AppResource().gameWheelCoinLeft1
                          : AppResource().gameWheelCoinLeft2),
                ),
                Expanded(
                  child: AppLocalImage(
                      onTap: () {
                        logic.onSend(2);
                      },
                      path: logic.viewType.value == WheelGameViewType.primary
                          ? AppResource().gameWheelCoinCenter1
                          : AppResource().gameWheelCoinCenter2),
                ),
                Expanded(
                  child: AppLocalImage(
                      onTap: () {
                        logic.onSend(3);
                      },
                      path: logic.viewType.value == WheelGameViewType.primary
                          ? AppResource().gameWheelCoinRight1
                          : AppResource().gameWheelCoinRight2),
                )
              ],
            )),
        SizedBox(
          height: 17.h,
        ),
      ],
    );
  }
}
