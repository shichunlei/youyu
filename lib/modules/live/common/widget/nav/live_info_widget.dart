import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/app_round_container.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveInfoWidget extends StatelessWidget {
  const LiveInfoWidget(
      {super.key,
      required this.roomName,
      required this.liveFancyNumber,
      required this.liveHot,
      required this.isFocus,
      required this.onLiveFocus,
      required this.roomType,
      required this.isLock});

  final int liveFancyNumber;
  final Rx<String> roomName;
  final Rx<String> roomType;
  final Rx<String> liveHot;
  final Rx<int> isFocus;

  ///是否加锁
  final Rx<int> isLock;
  final Function onLiveFocus;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 名称 & 标签
              Obx(() => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          roomName.value,
                          style: AppTheme().textStyle(
                              color: AppTheme.colorTextWhite,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      if (roomType.value.isNotEmpty)
                        AppRoundContainer(
                            bgColor: const Color(0x33FFFFFF),
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(
                                left: 4.w, right: 4.w, top: 2.h, bottom: 2.h),
                            child: Text(
                              roomType.value,
                              style: AppTheme().textStyle(
                                  fontSize: 9.sp,
                                  color: AppTheme.colorTextWhite),
                            ))
                    ],
                  )),
              SizedBox(
                height: 6.h,
              ),

              ///ID & 热度
              Obx(
                () => Expanded(
                    child: RichText(
                        maxLines: 1,
                        text: TextSpan(
                          text: "ID:$liveFancyNumber  ",
                          style: AppTheme().textStyle(
                              color: AppTheme.colorTextWhite, fontSize: 11.sp),
                          children: [
                            WidgetSpan(
                                child: AppLocalImage(
                                  path: AppResource().liveHot,
                                  width: 12.w,
                                  height: 12.w,
                                ),
                                baseline: TextBaseline.ideographic),
                            TextSpan(
                              style: AppTheme().textStyle(
                                  color: AppTheme.colorTextWhite,
                                  fontSize: 11.sp),
                              text: liveHot.value,
                            ),
                          ],
                        ))),
              )
            ],
          )),
          SizedBox(
            width: 5.w,
          ),
          Obx(() => isLock.value == 1
              ? AppContainer(
                  margin: const EdgeInsets.only(right: 8),
                  child: Center(
                    child: AppLocalImage(
                      path: AppResource().liveSeatLock,
                      width: 15.w,
                    ),
                  ),
                )
              : const SizedBox.shrink()),
          Obx(() => _rightWidget())
        ],
      ),
    );
  }

  //是否关注
  _rightWidget() {
    return isFocus.value == 0
        ? AppColorButton(
            title: "+ 关注",
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            width: 46.w,
            fontSize: 10.sp,
            height: 20.h,
            titleColor: AppTheme.colorTextWhite,
            bgGradient: AppTheme().btnGradient,
            onClick: onLiveFocus,
          )
        : const SizedBox.shrink();
  }
}
