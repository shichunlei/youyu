import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/input/app_normal_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///房间加锁
class LiveSettingPwPop extends StatefulWidget {
  const LiveSettingPwPop(
      {super.key, required this.title, required this.placeHolder});

  final String title;
  final String placeHolder;

  @override
  State<LiveSettingPwPop> createState() => _LiveSettingPwPopState();
}

class _LiveSettingPwPopState extends State<LiveSettingPwPop> {
  final TextEditingController controller = TextEditingController();
  var isVerify = false.obs;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      /*
      if (controller.text.length > 6 &&
          (controller.text.hasLowerCase() || controller.text.hasUpperCase()) &&
          controller.text.hasNumber()) {
        isVerify.value = true;
      } else {
        isVerify.value = false;
      }
       */
      if (controller.text.isNotEmpty) {
        isVerify.value = true;
      } else {
        isVerify.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Get.back();
        },
        child: Center(
          child: AppColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            onTap: () {
              //...
            },
            height: 308.h,
            radius: 10.w,
            margin: EdgeInsets.symmetric(horizontal: 27.w),
            color: AppTheme.colorDarkBg,
            mainAxisAlignment: MainAxisAlignment.center,
            padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 14.h),
            children: [
              Text(
                widget.title,
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
                    placeHolder: widget.placeHolder),
              ),
              SizedBox(
                height: 20.h,
              ),
              Obx(() => Opacity(
                    opacity: isVerify.value ? 1.0 : 0.5,
                    child: AppRow(
                      onTap: () {
                        if (controller.text.trim().isNotEmpty) {
                          Get.back(result: controller.text);
                        } else {
                          ToastUtils.show("请输入房间密码");
                        }
                      },
                      radius: 99.h,
                      mainAxisAlignment: MainAxisAlignment.center,
                      margin: EdgeInsets.only(left: 35.w, right: 35.w),
                      gradient: AppTheme().btnGradient,
                      height: 56.h,
                      children: [
                        AppLocalImage(
                          path: AppResource().livePwLock,
                          width: 13.w,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          '加锁',
                          style: AppTheme().textStyle(
                              fontSize: 14.sp,
                              color: AppTheme.colorTextWhite),
                        )
                      ],
                    ),
                  )),
              SizedBox(
                height: 18.h,
              ),
              Text(
                "*建议设置6位数以上包含数字，字母的长密码，密码越长越安全。",
                maxLines: 3,
                style: AppTheme().textStyle(
                    fontSize: 12.sp, color: AppTheme.colorTextSecond),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                "*其余玩家可以通过输入密码进入房间。",
                maxLines: 3,
                style: AppTheme().textStyle(
                    fontSize: 12.sp, color: AppTheme.colorTextSecond),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                "*为保护玩家隐私，锁房后房间内不可截屏，录屏。",
                maxLines: 3,
                style: AppTheme().textStyle(
                    fontSize: 12.sp, color: AppTheme.colorTextSecond),
              )
            ],
          ),
        ),
      ),
    );
  }
}
