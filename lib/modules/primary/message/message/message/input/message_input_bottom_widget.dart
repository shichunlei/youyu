import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../message_detail_logic.dart';

///底部更多
class MessageInputBottomWidget extends StatelessWidget {
  const MessageInputBottomWidget({super.key, required this.logic});

  final MessageDetailLogic logic;

  @override
  Widget build(BuildContext context) {
    return AppColumn(
        height: logic.bottomMoreHeight,
        children: [
          Expanded(
            child: Row(
              children: [
                ///表情
                Obx(() => Expanded(
                      child: AppContainer(
                        onTap: () {
                          logic.onClickEmoji();
                        },
                        child: Center(
                          child: AppLocalImage(
                            path: AppResource().disEmoji,
                            width: 20.w,
                            imageColor:
                                logic.state == MessageDetailInputState.emoji
                                    ? AppTheme.colorMain
                                    : AppTheme.colorTextWhite,
                          ),
                        ),
                      ),
                    )),

                ///图片
                Expanded(
                  child: AppContainer(
                    onTap: () async {
                      logic.onClickImage();
                    },
                    child: Center(
                      child: AppLocalImage(
                        path: AppResource().msgImg,
                        width: 20.w,
                      ),
                    ),
                  ),
                ),

                ///相机
                Expanded(
                  child: AppContainer(
                    onTap: () async {
                      logic.onClickCamera();
                    },
                    child: Center(
                      child: AppLocalImage(
                        path: AppResource().msgCamera,
                        width: 20.w,
                      ),
                    ),
                  ),
                ),

                ///礼物
                Expanded(
                  child: AppContainer(
                    onTap: () async {
                      logic.onClickGift();
                    },
                    child: Center(
                      child: AppLocalImage(
                        path: AppResource().msgGift,
                        width: 20.w,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15.h,
          )
        ]);
  }
}
