import 'package:youyu/utils/string_extension.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RechargeCustomDialog extends StatefulWidget {
  const RechargeCustomDialog(
      {super.key, required this.dValue, required this.onDone});

  final String dValue;
  final Function(String count, String price) onDone;

  @override
  State<RechargeCustomDialog> createState() => _RechargeCustomDialogState();
}

class _RechargeCustomDialogState extends State<RechargeCustomDialog> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.dValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: AppStack(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.only(left: 20.w, right: 20.w),
          width: double.infinity,
          height: 284.h,
          color: AppTheme.colorDarkBg,
          radius: 10.w,
          children: [
            AppColumn(
              width: double.infinity,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 27.h,
                ),
                Text(
                  "自定义充值数量",
                  style: AppTheme().textStyle(
                      fontSize: 18.sp, color: AppTheme.colorTextWhite),
                ),
                SizedBox(
                  height: 16.h,
                ),
                AppLocalImage(
                  path: AppResource().coin2,
                  width: 20.w,
                  height: 20.w,
                ),
                SizedBox(
                  height: 16.h,
                ),
                SizedBox(
                  width: 150.w,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              onChanged: (text) {
                                setState(() {});
                              },
                              //隐藏文本
                              keyboardType: TextInputType.number,
                              // TextInputType还有很多别键盘可以根据自己需要的场景调用
                              maxLines: 1,
                              // 输入文本的样式
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFFFFFFFF),
                              ),
                              cursorColor: AppTheme.colorMain,
                              //光标颜色
                              decoration: InputDecoration(
                                hintText: '请输入10的倍数',
                                //提示文本
                                hintStyle:
                                    const TextStyle(color: Color(0xFF999999)),
                                //提示文本样式
                                hintMaxLines: 1,
                                //提示文本行数
                                isDense: true,
                                ////改变输入框是否为密集型，默认为false，修改为true时，图标及间距会变小
                                contentPadding:
                                    EdgeInsets.fromLTRB(2.w, 1.w, 2.w, 1.w),
                                //内间距
                                filled: true,
                                //如果为true，则输入使用fillColor指定的颜色填充
                                fillColor: const Color(0x00FFFFFF),
                                //相当于输入框的背景颜色
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      style: BorderStyle.solid,
                                      color: Color(0x00FFFFFF)), //
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.w)),
                                ),
                                // border: InputBorder.none, //边框
                                border: OutlineInputBorder(
                                  // borderSide: BorderSide.none, //
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.w)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      style: BorderStyle.solid,
                                      color: Color(0x00FFFFFF)), //
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.w)),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "豆",
                            style: AppTheme().textStyle(
                                fontSize: 14.sp,
                                color: AppTheme.colorTextWhite),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 2.h),
                        width: 150.w,
                        height: 0.5.h,
                        color: const Color(0xFFD8D8D8),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        _isVerify()
                            ? "¥${(double.parse(_controller.text) / 10.0).toStringAsFixed(2)}"
                            : "¥ -- ",
                        style: AppTheme()
                            .textStyle(fontSize: 24, color: AppTheme.colorMain),
                      )
                    ],
                  ),
                ),
                Opacity(
                  opacity: _isVerify() ? 1 : 0.5,
                  child: AppColorButton(
                    onClick: () {
                      if (_isVerify()) {
                        double money = double.parse(_controller.text) / 10.0;
                        if (money > 10000) {
                          ToastUtils.show("单笔充值不能超过10000");
                        } else {
                          widget.onDone(_controller.text,
                              "${double.parse(_controller.text) / 10.0}");
                          Get.back();
                        }
                      }
                    },
                    margin: EdgeInsets.only(top: 30.h),
                    width: 171.w,
                    height: 52.h,
                    title: "确定",
                    titleColor: AppTheme.colorTextWhite,
                    bgGradient: AppTheme().btnGradient,
                    alignment: Alignment.center,
                  ),
                )
              ],
            ),
            Positioned(
                top: 2.h,
                right: 1.w,
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    child: Icon(
                      Icons.close,
                      size: 18.w,
                      color: Colors.white,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  _isVerify() {
    if (_controller.text.isNotEmpty) {
      if (_controller.text.cnIsNumber()) {
        if (int.parse(_controller.text).toInt() % 10 == 0) {
          return true;
        }
      }
    }

    return false;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
