import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/icon/app_more_icon.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'message_setting_logic.dart';

class MessageSettingPage extends StatefulWidget {
  const MessageSettingPage({Key? key}) : super(key: key);

  @override
  State<MessageSettingPage> createState() => _MessageSettingPageState();
}

class _MessageSettingPageState extends State<MessageSettingPage> {
  final logic = Get.find<MessageSettingLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<MessageSettingLogic>(
      appBar: const AppTopBar(
        title: "聊天设置",
      ),
      childBuilder: (s) {
        return AppColumn(
          margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          children: [
            //顶部
            _headerWidget(),
            //内容
            AppColumn(
              margin: EdgeInsets.only(top: 15.h),
              radius: 6.w,
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              color: AppTheme.colorDarkBg,
              children: [
                //TODO:后面在做
                // _normalItem("备注", MessageSettingEventType.remark),
                // _switchItem("特别关心", false),
                _normalItem("举报", MessageSettingEventType.report),
                _normalItem(logic.targetUserInfo?.isBlock == 1 ? "移除黑名单" : "拉黑",
                    MessageSettingEventType.black),
                _normalItem(
                    (logic.targetUserInfo?.isFocus ?? false) ? "取消关注" : "关注",
                    MessageSettingEventType.focus,
                    isShowLine: false)
              ],
            )
          ],
        );
      },
    );
  }

  ///顶部
  _headerWidget() {
    return AppRow(
      onTap: () {
        UserController.to.pushToUserDetail(
            logic.userId, UserDetailRef.chatSetting,
            targetUserInfo: logic.targetUserInfo);
      },
      height: 104.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      radius: 6.w,
      color: AppTheme.colorDarkBg,
      children: [
        AppCircleNetImage(
          imageUrl: logic.targetUserInfo?.avatar ?? "",
          size: 76.w,
        ),
        SizedBox(
          width: 6.w,
        ),
        Expanded(
            child: Text(
          logic.targetUserInfo?.nickname ?? "",
          style: AppTheme().textStyle(
              fontSize: 18.sp, color: AppTheme.colorTextWhite),
        )),
        AppMoreIcon(
          height: 7.h,
          isShowText: false,
        )
      ],
    );
  }

  ///特别关心
  _switchItem(String title, bool value) {
    return AppColumn(
      children: [
        AppRow(
          onTap: () {},
          height: 55.h,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: AppTheme().textStyle(
                  fontSize: 14.sp, color: AppTheme.colorTextWhite),
            ),
            const Expanded(child: SizedBox()),
            CupertinoSwitch(
                activeColor: AppTheme.colorMain,
                value: value,
                onChanged: (value) {
                  //...
                })
          ],
        ),
        AppContainer(
          width: double.infinity,
          height: 0.5.h,
          color: AppTheme.colorLine,
        )
      ],
    );
  }

  ///基础
  _normalItem(String title, MessageSettingEventType eventType,
      {bool isShowLine = true}) {
    return AppColumn(
      children: [
        AppRow(
          onTap: () {
            logic.onClickEvent(eventType);
          },
          height: 55.h,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: AppTheme().textStyle(
                  fontSize: 14.sp, color: AppTheme.colorTextWhite),
            ),
            const Expanded(child: SizedBox()),
            AppMoreIcon(
              height: 7.h,
              isShowText: false,
            )
          ],
        ),
        if (isShowLine)
          AppContainer(
            width: double.infinity,
            height: 1.h,
            color: AppTheme.colorLine,
          )
      ],
    );
  }
}
