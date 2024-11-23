import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/input/app_area_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///房间公告
class LiveSettingNoticePop extends StatefulWidget {
  const LiveSettingNoticePop(
      {super.key,
      required this.title,
      required this.placeHolder,
      required this.defaultValue});

  final String title;
  final String placeHolder;
  final String defaultValue;

  @override
  State<LiveSettingNoticePop> createState() => _LiveSettingNoticePopState();
}

class _LiveSettingNoticePopState extends State<LiveSettingNoticePop> {
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
            height: 220.h,
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
              AppAreaInput(
                textColor: AppTheme.colorTextWhite,
                controller: controller,
                textInputAction: TextInputAction.done,
                bgColor: const Color(0xFF000000),
                placeHolderColor: AppTheme.colorTextSecond,
                height: 68.h,
                placeHolder: widget.placeHolder,
                theme: AppWidgetTheme.dark,
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
                  Get.back(result: controller.text);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
