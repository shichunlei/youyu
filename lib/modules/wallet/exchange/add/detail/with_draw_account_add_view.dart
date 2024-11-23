import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'with_draw_account_add_logic.dart';

class WithDrawAccountAddPage extends StatefulWidget {
  const WithDrawAccountAddPage({Key? key}) : super(key: key);

  @override
  State<WithDrawAccountAddPage> createState() => _WithDrawAccountAddPageState();
}

class _WithDrawAccountAddPageState extends State<WithDrawAccountAddPage> {
  late WithDrawAccountAddLogic logic = Get.find<WithDrawAccountAddLogic>();

  @override
  void initState() {
    super.initState();
    Get.put(() => WithDrawAccountAddLogic());
  }

  @override
  Widget build(BuildContext context) {
    return AppPage<WithDrawAccountAddLogic>(
      appBar: const AppTopBar(
        title: "支付宝账号",
      ),
      childBuilder: (s) {
        return Container(
            padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 15.h),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AppColumn(
                    margin: EdgeInsets.only(top: 15.h),
                    width: double.infinity,
                    color: AppTheme.colorDarkLightBg,
                    radius: 6.w,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _textField("姓名", "请输入姓名", logic.nameController,
                          logic.nameFocusNode),
                      Container(
                        color: AppTheme.colorLine,
                        height: 0.5.h,
                      ),
                      _textField("支付宝账号", "请填写支付宝账号", logic.numberController,
                          logic.numberFocusNode),
                      Container(
                        color: AppTheme.colorLine,
                        height: 0.5.h,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 23.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppLocalImage(
                        path: AppResource().warning,
                        width: 16.w,
                        height: 16.w,
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Text(
                        "请与注册时实名信息一致",
                        style: AppTheme().textStyle(
                            fontSize: 12.sp, color: AppTheme.colorRed),
                      ),
                    ],
                  ),
                  //完成
                  Obx(() => Opacity(
                        opacity: logic.isVerify.value ? 1 : 0.5,
                        child: AppContainer(
                          onTap: () {
                            if (logic.isVerify()) {
                               logic.onCommit();
                            }
                          },
                          margin: EdgeInsets.only(top: 86.h),
                          height: 52.h,
                          gradient: AppTheme().btnGradient,
                          radius: 25.h,
                          alignment: Alignment.center,
                          child: Text("提交",
                              textAlign: TextAlign.center,
                              style: AppTheme().textStyle(
                                  fontSize: 18.sp,
                                  color: AppTheme.colorTextWhite)),
                        ),
                      )),
                ],
              ),
            ));
      },
    );
  }

  _textField(String title, String hint, TextEditingController controller,
      FocusNode focusNode) {
    return Container(
      height: 50.h,
      padding: EdgeInsets.only(left: 17.w, right: 17.w),
      // padding: EdgeInsets.fromLTRB(26.w, 0, 26.w, 0),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16.sp, color: AppTheme.colorTextSecond),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
              child: TextField(
            controller: controller,
            focusNode: focusNode,
            onChanged: (text) {
              logic.update();
            },
            keyboardType: TextInputType.text,
            // TextInputType还有很多别键盘可以根据自己需要的场景调用
            maxLines: 1,
            // 输入文本的样式
            style: AppTheme().textStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.colorTextWhite,
                ),
            cursorColor: AppTheme.colorMain,
            //光标颜色
            decoration: InputDecoration(
              hintText: hint,
              //提示文本
              hintStyle: const TextStyle(color: Color(0xFF666666)),
              //提示文本样式
              hintMaxLines: 1,
              //提示文本行数
              isDense: true,
              ////改变输入框是否为密集型，默认为false，修改为true时，图标及间距会变小
              contentPadding: EdgeInsets.fromLTRB(2.w, 1.w, 2.w, 1.w),
              //内间距
              filled: true,
              //如果为true，则输入使用fillColor指定的颜色填充
              fillColor: const Color(0x00FFFFFF),
              //相当于输入框的背景颜色
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    style: BorderStyle.solid, color: Color(0x00FFFFFF)), //
                borderRadius: BorderRadius.all(Radius.circular(12.w)),
              ),
              // border: InputBorder.none, //边框
              border: OutlineInputBorder(
                // borderSide: BorderSide.none, //
                borderRadius: BorderRadius.all(Radius.circular(12.w)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    style: BorderStyle.solid, color: Color(0x00FFFFFF)), //
                borderRadius: BorderRadius.all(Radius.circular(12.w)),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
