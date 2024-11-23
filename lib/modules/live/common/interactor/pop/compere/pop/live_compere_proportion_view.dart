import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/input/app_normal_input.dart';
import 'live_compere_proportion_logic.dart';

class LiveCompereProportionPage extends StatefulWidget {
  const LiveCompereProportionPage(
      {Key? key,
      required this.proportion,
      required this.roomId,
      required this.userId,
      required this.onRefresh})
      : super(key: key);
  final int proportion;
  final String roomId;
  final String userId;
  final Function onRefresh;

  @override
  State<LiveCompereProportionPage> createState() =>
      _LiveCompereProportionPageState();
}

class _LiveCompereProportionPageState extends State<LiveCompereProportionPage> {
  final logic = Get.put(LiveCompereProportionLogic());

  @override
  void initState() {
    super.initState();
    logic.editingController.text = "${widget.proportion}";
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
                "设置流水比例",
                style: AppTheme()
                    .textStyle(fontSize: 16.sp, color: AppTheme.colorTextWhite),
              ),
              SizedBox(
                height: 20.h,
              ),
              AppRow(
                //subtextGap = 8
                height: 41.h,
                crossAxisAlignment: CrossAxisAlignment.center,
                padding: EdgeInsets.only(left: 16.w, right: 16.w),
                radius: 99.w,
                color: const Color(0xFF000000),
                children: [
                  AppLocalImage(
                    onTap: () {
                      String oldValue = logic.editingController.text;
                      if (oldValue.isNotEmpty && int.parse(oldValue) > 0) {
                        logic.editingController.text =
                            "${int.parse(oldValue) - 1}";
                      }
                    },
                    path: AppResource().livePSub,
                    width: 18.w,
                    height: 18.w,
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Expanded(
                      child: AppNormalInput(
                          radius: 99.w,
                          counter: const SizedBox.shrink(),
                          maxLength: 20,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(3), // 设置输入长度限制
                            FilteringTextInputFormatter.digitsOnly, // 只允许输入数字
                          ],
                          keyboardType: TextInputType.number,
                          textColor: AppTheme.colorTextWhite,
                          textAlign: TextAlign.center,
                          controller: logic.editingController,
                          placeHolderColor: AppTheme.colorTextSecond,
                          backgroundColor: const Color(0xFF000000),
                          height: 40.h,
                          placeHolder: "")),
                  SizedBox(
                    width: 20.w,
                  ),
                  AppLocalImage(
                    onTap: () {
                      String oldValue = logic.editingController.text;
                      if (oldValue.isNotEmpty && int.parse(oldValue) < 100) {
                        logic.editingController.text =
                            "${int.parse(oldValue) + 1}";
                      }
                    },
                    path: AppResource().livePAdd,
                    width: 18.w,
                    height: 18.w,
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              AppRow(
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
                    ),
                  ),
                  SizedBox(
                    width: 23.w,
                  ),
                  Expanded(
                    child: AppColorButton(
                      titleColor: AppTheme.colorTextWhite,
                      title: "确定",
                      fontSize: 18.sp,
                      bgGradient: AppTheme().btnGradient,
                      height: 44.h,
                      onClick: () async {
                        if (logic.editingController.text.isNotEmpty) {
                          int proportion =
                              int.parse(logic.editingController.text);
                          if (proportion >= 0 && proportion <= 100) {
                            int value = await logic.onSetManager(
                                widget.roomId,
                                widget.userId,
                                int.parse(logic.editingController.text));
                            if (value == 1) {
                              widget.onRefresh();
                            }
                          } else {
                            ToastUtils.show("请输入0-100分成比例");
                          }
                        } else {
                          ToastUtils.show("请输入分成比例");
                        }
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
