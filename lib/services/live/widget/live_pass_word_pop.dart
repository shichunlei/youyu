import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/app_controller.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/input/app_normal_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

typedef UnLockTapCallback = Function(int roomId, String pw);

///房间解锁
class LivePwPop extends StatefulWidget {
  const LivePwPop({super.key, required this.roomId, required this.onClickLock});

  final int roomId;
  final UnLockTapCallback onClickLock;

  @override
  State<LivePwPop> createState() => _LivePwPopState();
}

class _LivePwPopState extends State<LivePwPop> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: exitVerify, child: Center(
      child: AppStack(
        height: 250.h,
        children: [
          AppColumn(
            crossAxisAlignment: CrossAxisAlignment.center,
            onTap: () {
              //...
            },
            height: 250.h,
            radius: 10.w,
            margin: EdgeInsets.symmetric(horizontal: 27.w),
            color: AppTheme.colorDarkBg,
            mainAxisAlignment: MainAxisAlignment.center,
            padding: EdgeInsets.symmetric(horizontal: 27.w, vertical: 27.h),
            children: [
              Text(
                "房间密码",
                style: AppTheme().textStyle(
                    fontSize: 16.sp, color: AppTheme.colorTextWhite),
              ),
              SizedBox(
                height: 20.h,
              ),
              AppContainer(
                //subtextGap = 8
                padding: EdgeInsets.only(top: 8.h),
                radius: 99.w,
                color: const Color(0xFF000000),
                child: AppNormalInput(
                    radius: 99.w,
                    counter: const SizedBox.shrink(),
                    maxLength: 100,
                    textColor: AppTheme.colorTextWhite,
                    textAlign: TextAlign.center,
                    controller: controller,
                    placeHolderColor: AppTheme.colorTextSecond,
                    backgroundColor: const Color(0xFF000000),
                    height: 42.h,
                    placeHolder: "请输入房间密码"),
              ),
              SizedBox(
                height: 20.h,
              ),
              //按钮
              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(
                    left: 22.w, right: 22.w, top: 15.h, bottom: 20.h),
                child: _doubleButton(),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Future<bool> exitVerify() async {
    return Future.value(false);
  }

  _doubleButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: AppColorButton(
              title: "取消",
              width: 120.w,
              height: 44.h,
              titleColor: AppTheme.colorMain,
              borderColor: AppTheme.colorMain,
              onClick: () {
                FocusScope.of(context).requestFocus(FocusNode());
                Get.back();
              },
            )),
        SizedBox(
          width: 20.w,
        ),
        Expanded(
            child: AppColorButton(
              title: "确认",
              height: 44.h,
              titleColor: AppTheme.colorTextWhite,
              bgGradient: AppTheme().btnGradient,
              onClick: () async {
                if (controller.text.isEmpty) {
                  ToastUtils.show("请输入密码");
                  return;
                }
                AppController.to.closeKeyboard();
                Get.back();
                widget.onClickLock(widget.roomId, controller.text);
              },
            )),
      ],
    );
  }
}
