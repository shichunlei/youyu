import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/router/router.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/icon/app_more_icon.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'setting_privacy_logic.dart';

///隐私设置
class SettingPrivacyPage extends StatelessWidget {
  SettingPrivacyPage({Key? key}) : super(key: key);

  final logic = Get.find<SettingPrivacyLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<SettingPrivacyLogic>(
      appBar: const AppTopBar(
        title: "隐私设置",
      ),
      childBuilder: (s) {
        return AppColumn(
          mainAxisSize: MainAxisSize.min,
          margin: EdgeInsets.all(15.w),
          color: AppTheme.colorDarkBg,
          radius: 6.w,
          children: [
            _blackItem(),
          ],
        );
      },
    );
  }

  //TODO:后面做
  _futureFunc() {
    return Obx(() => AppColumn(
      mainAxisSize: MainAxisSize.min,
      margin: EdgeInsets.all(15.w),
      color: AppTheme.colorDarkBg,
      radius: 6.w,
      children: [
        _switchItem("消息防打扰", "不接收陌生人消息",
            UserController.to.setControl.isOpenDisturb.value, (value) {
              logic.onSwitchDisturb(value);
            }),
        Container(
          height: 0.5,
          color: AppTheme.colorLine,
        ),
        _switchItem('手机通讯录隐身', '别人无法通过手机通讯录找到你',
            UserController.to.setControl.isBookAddressHidden.value,
                (value) {
              logic.onSwitchAddressBook(value);
            }),
        Container(
          height: 0.5,
          color: AppTheme.colorLine,
        ),
        _blackItem(),
      ],
    ));
  }

  _switchItem(String title, String subTitle, bool value, var onChanged) {
    return AppRow(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      height: 80.h,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppColumn(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTheme().textStyle(
                  fontSize: 14.sp, color: AppTheme.colorTextWhite),
            ),
            SizedBox(
              height: 2.h,
            ),
            Text(
              subTitle,
              style: AppTheme().textStyle(
                  fontSize: 12.sp, color: AppTheme.colorTextSecond),
            ),
          ],
        ),
        const Expanded(child: SizedBox()),
        CupertinoSwitch(
            activeColor: AppTheme.colorMain,
            value: value,
            onChanged: (value) {
              onChanged(value);
            })
      ],
    );
  }

  _blackItem() {
    return AppRow(
      onTap: () {
        Get.toNamed(AppRouter().settingPages.setBlackRoute.name);
      },
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      height: 80.h,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "黑名单",
          style: AppTheme().textStyle(
              fontSize: 14.sp, color: AppTheme.colorTextWhite),
        ),
        const Expanded(child: SizedBox()),
        AppMoreIcon(
          height: 7.h,
          isShowText: false,
        )
      ],
    );
  }
}
