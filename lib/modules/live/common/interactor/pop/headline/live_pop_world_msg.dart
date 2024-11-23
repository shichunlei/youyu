import 'package:get/get.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/modules/live/common/interactor/pop/headline/live_pop_world_msg_logic.dart';
import 'package:youyu/modules/live/index/live_index_logic.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_round_container.dart';
import 'package:flutter/material.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/input/app_area_input.dart';

///抢头条弹窗
class LivePopWorldMsg extends StatefulWidget {
  const LivePopWorldMsg({
    super.key,
    required this.roomId,
  });

  final int roomId;

  @override
  State<LivePopWorldMsg> createState() => LivePopWorldMsgState();
}

class LivePopWorldMsgState extends State<LivePopWorldMsg>
    with SingleTickerProviderStateMixin {
  final logic = Get.put(LivePopWorldMsgLogic());
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
                "抢头条",
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
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: AppContainer(
                strokeColor: AppTheme.colorMain,
                strokeWidth: 1.w,
                radius: 16.w,
                child: AppAreaInput(
                  padding: EdgeInsets.only(
                      left: 15.w, right: 15.w, top: 12.w, bottom: 12.w),
                  textColor: AppTheme.colorTextWhite,
                  controller: logic.controller,
                  textInputAction: TextInputAction.newline,
                  bgColor: Colors.transparent,
                  placeHolderColor: AppTheme.colorTextSecond,
                  height: 130.h,
                  placeHolder: "输入内容仅限 30个字。禁止发布色情、赌博等违反相关法律的内容;违规者将进行封号处理。",
                  theme: AppWidgetTheme.dark,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppLocalImage(
                path: AppResource().coin2,
                width: 15.w,
              ),
              SizedBox(
                width: 8.w,
              ),
              Text(
                //Todo 替换成真实数据
                LiveIndexLogic.to.liveWorldMsgObs.value?.price?.toString() ??
                    '20',
                style: AppTheme()
                    .textStyle(fontSize: 16.sp, color: AppTheme.colorTextWhite),
              ),
            ],
          ),
          SizedBox(
            height: 15.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 25.w, right: 25.w, bottom: 27.h),
            child: AppColorButton(
              title: '确定',
              width: 326.w,
              height: 56.h,
              titleColor: AppTheme.colorTextWhite,
              bgGradient: AppTheme().btnGradient,
              // bgColor: Colors.transparent,
              onClick: () async {
                print("发送世界消息");
                //如果有输入内容则发布消息
                if (logic.controller.text.toString().isNotEmpty) {
                  bool result = await LiveIndexLogic.to.operation
                      .onOperateSendWorldMsg(logic.controller.text.toString());
                  if (result) {
                    ToastUtils.show("发送成功");
                    Get.back();
                  }
                }
              },
            ),
          ),
        ]));
  }
}
