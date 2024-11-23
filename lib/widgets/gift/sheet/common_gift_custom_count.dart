import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/input/app_normal_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonGiftCustomCount extends StatefulWidget {
  const CommonGiftCustomCount(
      {super.key, required this.textController, this.maxValue});

  final TextEditingController textController;
  final int? maxValue;

  @override
  State<CommonGiftCustomCount> createState() => _CommonGiftCustomCountState();
}

class _CommonGiftCustomCountState extends State<CommonGiftCustomCount> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // 键盘消失时的逻辑处理
        if (widget.textController.text.isEmpty) {
          Get.back();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppColumn(
      height: ScreenUtils.screenHeight,
      mainAxisSize: MainAxisSize.min,
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
                  controller: widget.textController,
                  isShowEye: false,
                  onSubmitted: (s) {
                    _submit();
                  },
                  placeHolder: "请输入自定义礼物数量"),
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

  _submit() {
    int? count = int.tryParse(widget.textController.text);
    if (count == null || count <= 0) {
      ToastUtils.show('请输入正确的数量');
      return;
    }
    if (widget.maxValue != null && count > widget.maxValue!) {
      ToastUtils.show('数量不能超过${widget.maxValue}');
      return;
    }
    Get.back(result: count);
  }
}
