import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/input/app_normal_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///房间名称
class LiveSettingNamePop extends StatefulWidget {
  const LiveSettingNamePop(
      {super.key,
      required this.title,
      required this.placeHolder,
      required this.defaultValue});

  final String title;
  final String defaultValue;
  final String placeHolder;

  @override
  State<LiveSettingNamePop> createState() => _LiveSettingNamePopState();
}

class _LiveSettingNamePopState extends State<LiveSettingNamePop> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.defaultValue;
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
            onTap: () {
              //...
            },
            height: 208.h,
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
                    maxLength: 20,
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
              AppColorButton(
                margin: EdgeInsets.only(left: 35.w, right: 35.w),
                titleColor: AppTheme.colorTextWhite,
                title: "完成",
                fontSize: 18.sp,
                bgGradient: AppTheme().btnGradient,
                height: 56.h,
                onClick: () {
                  if (controller.text.trim().isNotEmpty) {
                    Get.back(result: controller.text);
                  } else {
                    ToastUtils.show("请输入房间名称");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
