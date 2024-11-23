import 'package:get/get.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/modules/live/common/interactor/pop/link/user/live_link_user_view.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_round_container.dart';
import 'package:flutter/material.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';

///用户上麦申请弹窗
class LiveLinkUser extends StatefulWidget {
  const LiveLinkUser({
    super.key,
    required this.roomId,
  });

  final int roomId;

  @override
  State<LiveLinkUser> createState() => LiveLinkUserState();
}

class LiveLinkUserState extends State<LiveLinkUser>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppRoundContainer(
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.w), topRight: Radius.circular(12.w)),
        bgColor: AppTheme.colorDarkBg,
        height: 390.h,
        child: Column(children: [
          AppRow(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            width: double.infinity,
            height: 44.h,
            children: [
              SizedBox(
                width: 50.w,
              ),
              Text(
                "互动连麦",
                style:
                    AppTheme().textStyle(fontSize: 18.sp, color: Colors.white),
              ),
              AppContainer(
                onTap: () {
                  Get.back();
                },
                width: 50.w,
                child: Center(
                  child: AppLocalImage(
                    path: AppResource().close,
                    width: 12.w,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 15.h,
          ),
          Expanded(
              child: LiveLinkUserApplyPage(
            roomId: widget.roomId,
          )),
          Padding(
            padding: EdgeInsets.all(20.h),
            child: AppColorButton(
              title: '申请连麦',
              width: 326.w,
              height: 56.h,
              titleColor: AppTheme.colorTextWhite,
              bgGradient: AppTheme().btnGradient,
              // bgColor: Colors.transparent,
              onClick: () {
                print("游客申请了连麦");
              },
            ),
          )
        ]));
  }
}
