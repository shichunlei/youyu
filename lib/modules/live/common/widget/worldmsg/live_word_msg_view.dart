import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/modules/live/index/live_index_logic.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';

class LiveWorldMsgView extends StatelessWidget {
  const LiveWorldMsgView({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: AppContainer(
        onTap: () {
          LiveIndexLogic.to.operation.onOperateHeadline();
        },

        margin: EdgeInsets.only(left: 15.w),
        width: 355.w,
        height: 35.h,
        // decoration: BoxDecoration(
        //   color: Colors.amber,
        //   borderRadius: BorderRadius.circular(12.w),
        // ),
        child: Stack(
          children: [
            AppLocalImage(
              path: AppResource().liveWorldMsgBg,
              // width: 78.w,
              // height: 25.w,
            ),
            Obx(() {
              return Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5.w, top: 0.h),
                    child: LiveIndexLogic.to.liveWorldMsgObs.value?.userInfo !=
                            null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(100.w),
                            child: AppNetImage(
                              onTap: () {
                                UserController.to.pushToUserDetail(
                                    LiveIndexLogic
                                        .to.liveWorldMsgObs.value!.userInfo?.id,
                                    UserDetailRef.live);
                              },
                              imageUrl: LiveIndexLogic
                                  .to.liveWorldMsgObs.value!.userInfo!.avatar!,
                              width: 26.w,
                              height: 26.w,
                              fit: BoxFit.cover,
                            ),
                          )
                        : AppLocalImage(
                            path: AppResource().liveWorldMsgNullAvatar,
                            width: 26.w,
                          ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.w, top: 0.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LiveIndexLogic.to.liveWorldMsgObs.value?.userInfo
                                    ?.nickname ??
                                "虚位以待",
                            style: AppTheme().textStyle(
                                fontSize: 11.5.sp,
                                color:
                                    AppTheme.colorTextWhite.withOpacity(0.8)),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: 210.w, maxHeight: 15.h),
                            child: Marquee(
                              showFadingOnlyWhenScrolling: true,
                              text: LiveIndexLogic
                                      .to.liveWorldMsgObs.value?.message ??
                                  "快来抢头条，享受曝光",
                              style: AppTheme().textStyle(
                                  fontSize: 12.sp,
                                  color: AppTheme.colorTextWhite),
                              blankSpace: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0.h, right: 7.w),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 3.h,
                        ),
                        AppLocalImage(
                          path: AppResource().liveWorldMsgButton,
                          width: 35.w,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppLocalImage(
                              path: AppResource().coin2,
                              width: 9.w,
                            ),
                            SizedBox(
                              width: 3.w,
                            ),
                            Text(
                              LiveIndexLogic.to.liveWorldMsgObs.value?.price
                                      ?.toString() ??
                                  '20',
                              style: AppTheme().textStyle(
                                  fontSize: 8.sp,
                                  color: AppTheme.colorTextWhite),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}
