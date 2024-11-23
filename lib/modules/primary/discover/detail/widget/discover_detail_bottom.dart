import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/dynamic_controller.dart';
import 'package:youyu/modules/primary/discover/detail/discover_detail_logic.dart';
import 'package:youyu/utils/number_ext.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/input/app_normal_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///底部
class DiscoverDetailBottom extends StatefulWidget {
  const DiscoverDetailBottom(
      {super.key,
      required this.height,
      required this.onClickAt,
      required this.onClickEmoji,
      required this.controller,
      required this.logic,
      required this.onSendComment});

  final double height;
  final TextEditingController controller;
  final Function onClickAt;
  final Function onClickEmoji;
  final Function onSendComment;
  final DiscoverDetailLogic logic;

  @override
  State<DiscoverDetailBottom> createState() => _DiscoverDetailBottomState();
}

class _DiscoverDetailBottomState extends State<DiscoverDetailBottom> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => AppRow(
          crossAxisAlignment: CrossAxisAlignment.center,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          width: double.infinity,
          height: widget.height,
          color: AppTheme.colorDarkBg,
          children: [
            Expanded(
                child: AppRow(
              color: const Color(0xFF000000),
              radius: 99.h,
              height: 40.h,
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              children: [
                //TODO：@先去掉
                // AppLocalImage(
                //   onTap: () {
                //     widget.onClickAt();
                //   },
                //   imageColor: widget.logic.mentionUserIds.isNotEmpty
                //       ? AppTheme.colorMain
                //       : AppTheme.colorTextWhite,
                //   path: AppResource().disAt,
                //   width: 20.w,
                // ),
                // SizedBox(
                //   width: 10.w,
                // ),
                ///表情
                AppLocalImage(
                  onTap: () {
                    widget.onClickEmoji();
                  },
                  path: widget.logic.state == DiscoverDetailInputState.emoji
                      ? AppResource().kb
                      : AppResource().disEmoji,
                  width: 20.w,
                ),
                SizedBox(
                  width: 10.w,
                ),
                ///输入框
                Expanded(
                  child: AppStack(
                    fit: StackFit.expand,
                    children: [
                      AppNormalInput(
                        paddingLeft: 0,
                        focusNode: widget.logic.focusNode,
                        controller: widget.controller,
                        textColor: AppTheme.colorTextWhite,
                        textAlign: TextAlign.left,
                        height: 40.h,
                        textInputAction: TextInputAction.send,
                        onSubmitted: widget.logic.onSubmitted,
                        placeHolder: widget.logic.inputPlaceHolder.value,
                        backgroundColor: Colors.transparent,
                      ),
                      if (widget.logic.state != DiscoverDetailInputState.text)
                        AppContainer(
                          color: Colors.transparent,
                          onTap: () {
                            widget.logic.onClickShowKb();
                          },
                        )
                    ],
                  ),
                )
              ],
            )),
            ///点赞
            AppColumn(
              onTap: () {
                setState(() {
                  DynamicController.to.onLikeChanged(widget.logic.detailModel);
                });
                DynamicController.to.onClickLike(widget.logic.detailModel,
                    onError: () {
                  setState(() {
                    DynamicController.to.onLikeChanged(widget.logic.detailModel);
                  });
                });
              },
              width: 40.w,
              margin: EdgeInsets.symmetric(horizontal: 13.w),
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppLocalImage(
                  path: (widget.logic.detailModel?.isLike ?? 0) == 1
                      ? AppResource().disLike
                      : AppResource().disUnLike,
                  width: 15.w,
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  (widget.logic.detailModel?.like ?? 0).showNum(),
                  style: AppTheme().textStyle(
                      fontSize: 12.sp, color: AppTheme.colorTextSecond),
                )
              ],
            ),
            ///发送
            AppColorButton(
              title: "发送",
              padding: EdgeInsets.zero,
              width: 60.w,
              fontSize: 14.sp,
              height: 30.h,
              titleColor: AppTheme.colorTextWhite,
              bgGradient: AppTheme().btnGradient,
              onClick: () {
                widget.onSendComment();
              },
            ),
          ],
        ));
  }
}
