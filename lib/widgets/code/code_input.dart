import 'package:youyu/utils/regex_utils.dart';
import 'package:youyu/utils/screen_utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youyu/config/theme.dart';

/// 验证码输入框
class CodeInputContainer extends StatefulWidget {
  //数量
  final int count;

  //结果
  final Function(String code) onResult;

  //颜色
  final Color itemColor;

  //item宽高比
  final double childAspectRatio;

  //item的间距
  final double crossAxisSpacing;

  final Color? textColor;

  /// 重新发起获取验证码
  const CodeInputContainer({
    super.key,
    required this.itemColor,
    required this.childAspectRatio,
    required this.crossAxisSpacing,
    required this.count,
    required this.onResult,
    this.textColor,
  });

  @override
  State createState() => _CodeInputContainerState();
}

class _CodeInputContainerState extends State<CodeInputContainer>
    with WidgetsBindingObserver {
  late final ValueNotifier<String> code = ValueNotifier('');
  late FocusNode inputFocus = FocusNode();
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = code.value;
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      inputFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            /// 点击时弹出输入键盘
            SystemChannels.textInput.invokeMethod('TextInput.show');
            inputFocus.requestFocus();
          },
          child: buildCodeView(),
        ),
        buildCodeInput(),
      ],
    );
  }

  Widget buildCodeInput() {
    return SizedBox(
      height: 1,
      width: 1,
      child: TextField(
        controller: controller,
        focusNode: inputFocus,
        maxLength: widget.count,
        keyboardType: TextInputType.number,
        // 禁止长按复制
        enableInteractiveSelection: false,
        decoration: const InputDecoration(
          counterText: '',
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        inputFormatters: [
          // 只允许输入数字
          RegexUtils().allowNum()
        ],
        onChanged: (v) async {
          code.value = v;
          widget.onResult.call(v);
        },
      ),
    );
  }

  Widget buildCodeView() {
    return ValueListenableBuilder<String>(
      valueListenable: code,
      builder: (context, value, child) {
        return GridView.count(
          padding: EdgeInsets.zero,
          crossAxisCount: widget.count,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisSpacing: widget.crossAxisSpacing,
          childAspectRatio: widget.childAspectRatio,
          children: List.generate(widget.count, (int i) => i).map((index) {
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: widget.itemColor,
                borderRadius: BorderRadius.circular(6.w),
              ),
              child: (value.length > index)
                  ? Text(
                      "*",
                      style: AppTheme().textStyle(
                            fontSize: 24,
                            color: widget.textColor ?? AppTheme.colorTextWhite,
                            fontWeight: FontWeight.w500,
                          ),
                    )
                  : null,
            );
          }).toList(),
        );
      },
    );
  }
}
