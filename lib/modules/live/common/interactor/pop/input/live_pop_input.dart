import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/input/app_normal_input.dart';
import 'package:youyu/widgets/app/input/controller/app_text_editing_contronller.dart';
import 'package:youyu/widgets/app/input/controller/entity/ait_span_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LivePopInput extends StatefulWidget {
  const LivePopInput({super.key, required this.isAt, this.targetUserInfo});

  final bool isAt;
  final UserInfo? targetUserInfo;

  @override
  State<LivePopInput> createState() => _LivePopInputState();
}

class _LivePopInputState extends State<LivePopInput> {
  final AppTextEditingController textController = AppTextEditingController();

  final FocusNode _focusNode = FocusNode();
  bool isBack = false;
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // 键盘消失时的逻辑处理
        if (textController.text.isEmpty) {
          if (!isBack) {
            isBack = true;
            Get.back(canPop: false);
          }

        }
      }
    });
    if (widget.isAt) {
      Future.delayed(const Duration(milliseconds: 200), () {
        addAit();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppColumn(
      mainAxisSize: MainAxisSize.max,
      children: [
        const Expanded(child: SizedBox()),
        AppRow(
          width: double.infinity,
          height: 44.w,
          color: AppTheme.colorDarkBg,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          children: [
            Expanded(
              child: AppNormalInput(
                  paddingLeft: 0,
                  focusNode: _focusNode,
                  autofocus: true,
                  fontSize: 14.sp,
                  textColor: AppTheme.colorTextWhite,
                  backgroundColor: Colors.transparent,
                  height: 50.h,
                  controller: textController,
                  isShowEye: false,
                  onSubmitted: (s) {
                    _submit();
                  },
                  placeHolder: "请输入内容"),
            ),
            SizedBox(
              width: 10.w,
            ),
            AppColorButton(
                width: 55.w,
                height: 25.w,
                onClick: _submit,
                padding: EdgeInsets.zero,
                fontSize: 14.sp,
                title: '确定',
                titleColor: const Color(0xFF000000),
                bgGradient: AppTheme().btnGradient),
          ],
        )
      ],
    );
  }

  addAit() {
    textController.insertSpan(SpanEntity("@${widget.targetUserInfo?.nickname} ",
        "{[@${widget.targetUserInfo?.nickname}},${widget.targetUserInfo?.id}]}",
        color: AppTheme.colorMain));
  }

  void onTextChanged(String newText) {
    int selectionStart = textController.selection.start;
    if (newText.isNotEmpty && selectionStart > 0) {
      String mentionChar = newText[selectionStart - 1];
      if (mentionChar == '@') {
        // 删除刚刚输入的@
        // textController.deleteText(1);
        // print("输入@");
        // Navigator.push(context, MaterialPageRoute(builder: (context) => TableCalendarPage()));
      }
    }
  }

  _submit() {
    if (textController.text.trim().isEmpty) {
      ToastUtils.show('请输入内容');
      return;
    }
    isBack = true;
    Get.back(result: textController.text);
  }
}
