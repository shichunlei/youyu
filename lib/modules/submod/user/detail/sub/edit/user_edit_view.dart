
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/time_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/icon/app_more_icon.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'user_edit_logic.dart';

class UserEditPage extends StatelessWidget {
  UserEditPage({Key? key}) : super(key: key);

  final logic = Get.find<UserEditLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<UserEditLogic>(
      appBar: const AppTopBar(
        title: "编辑资料",
      ),
      childBuilder: (s) {
        return SingleChildScrollView(
          child: AppColumn(
            width: ScreenUtils.screenWidth,
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            children: [
              SizedBox(
                height: 10.h,
              ),
              _header(),
              SizedBox(
                height: 15.h,
              ),
              _content()
            ],
          ),
        );
      },
    );
  }

  _header() {
    return AppColumn(
      width: ScreenUtils.screenWidth,
      height: 149.h,
      color: AppTheme.colorDarkBg,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      radius: 6.w,
      children: [
        AppStack(
          onTap: () {
            logic.selectHead();
          },
          children: [
            Obx(
              () => AppCircleNetImage(
                imageUrl: logic.imageModel.value?.imageUrl ??
                    UserController.to.avatar,
                size: 98.w,
              ),
            ),
            Positioned(
                right: 0,
                bottom: 0,
                child: AppLocalImage(
                  path: AppResource().smallPhoto2,
                  width: 28.w,
                ))
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          '会员可传动态头像哦~',
          style: AppTheme().textStyle(fontSize: 14.sp, color: AppTheme.colorTextDark),
        )
      ],
    );
  }

  _content() {
    return AppColumn(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      crossAxisAlignment: CrossAxisAlignment.start,
      width: ScreenUtils.screenWidth,
      radius: 6.w,
      color: AppTheme.colorDarkBg,
      children: [
        SizedBox(
          height: 20.h,
        ),
        Text(
          '基本信息',
          style: AppTheme().textStyle(
              fontSize: 16.sp, color: AppTheme.colorTextSecond),
        ),
        _item(
            title: "昵称",
            subTitle: logic.nickNameController.text,
            hasMore: true,
            onClick: logic.onPushNickName),
        _item(
            title: "性别",
            subTitle: logic.sex == 1 ? "男" : "女",
            hasMore: false,
            onClick: logic.selectSex),
        _item(
            title: "生日",
            subTitle: TimeUtils.dateToMonthDay(logic.birthDayTime),
            hasMore: false,
            onClick: logic.selectBirthDay),
        _item(
            title: "个性签名",
            subTitle: logic.signController.text,
            hasMore: true,
            onClick: logic.pushToSign),
      ],
    );
  }

  _item(
      {required String title,
      String? subTitle,
      bool hasMore = false,
      required Function onClick}) {
    return AppRow(
      onTap: () {
        onClick();
      },
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      height: 50.h,
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTheme().textStyle(
                fontSize: 16.sp, color: AppTheme.colorTextWhite),
          ),
        ),
        AppMoreIcon(
          height: double.infinity,
          title: subTitle,
          imageWidth: 5.w,
          fontSize: 14.sp,
        )
      ],
    );
  }
}
