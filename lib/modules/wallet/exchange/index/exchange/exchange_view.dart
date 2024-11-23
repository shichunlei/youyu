import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'exchange_logic.dart';

class ExchangeNewPage extends StatefulWidget {
  const ExchangeNewPage({Key? key}) : super(key: key);

  @override
  State<ExchangeNewPage> createState() => _ExchangeNewPageState();
}

class _ExchangeNewPageState extends State<ExchangeNewPage> with AutomaticKeepAliveClientMixin {

  late ExchangeLogic logic = Get.find<ExchangeLogic>();

  @override
  void initState() {
    super.initState();
    Get.put<ExchangeLogic>(ExchangeLogic());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppPage<ExchangeLogic>(
      isUseScaffold: false,
      childBuilder: (s) {
        return Obx(() => SingleChildScrollView(
              child: Column(
                children: [
                  AppColumn(
                    margin: EdgeInsets.only(top: 15.h),
                    width: double.infinity,
                    height: 103.h,
                    gradient: const LinearGradient(
                        colors: [Color(0xFF7E54D8), Color(0xFFD563C6)]),
                    radius: 6.w,
                    padding: EdgeInsets.only(left: 12.w, right: 12.w),
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("钻石余额",
                          style: AppTheme().textStyle(
                              fontSize: 16.sp,
                              color: AppTheme.colorTextWhite)),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 6.h),
                            child: AppLocalImage(
                              path: AppResource().coin3,
                              width: 32.w,
                              height: 32.w,
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            "${UserController.to.diamonds}",
                            style: AppTheme().textStyle(
                                fontSize: 28.sp,
                                color: AppTheme.colorTextWhite),
                          )
                        ],
                      )
                    ],
                  ),
                  AppColumn(
                    margin: EdgeInsets.only(top: 15.h),
                    width: double.infinity,
                    color: AppTheme.colorDarkBg,
                    radius: 6.w,
                    padding: EdgeInsets.only(left: 15.w, right: 15.w),
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 17.h,
                      ),
                      Text(
                        "茶豆兑换",
                        style: AppTheme().textStyle(
                            fontSize: 16.sp,
                            color: AppTheme.colorTextWhite),
                      ),
                      SizedBox(
                        height: 14.h,
                      ),
                      _textField("请输入兑换的钻石数量", "钻石", true),
                      SizedBox(
                        height: 17.h,
                      ),
                      _textField("", "金豆", false),
                      SizedBox(
                        height: 25.h,
                      ),
                    ],
                  ),
                  Opacity(
                    opacity: logic.isVerify() ? 1 : 0.5,
                    child: AppContainer(
                      onTap: () {
                        if (logic.isVerify()) {
                          logic.exchange();
                        }
                      },
                      margin: EdgeInsets.only(top: 36.h),
                      height: 52.h,
                      gradient: AppTheme().btnGradient,
                      radius: 25.w,
                      alignment: Alignment.center,
                      child: Text(
                        "立即兑换",
                        textAlign: TextAlign.center,
                        style: AppTheme().textStyle(
                            fontSize: 18.sp,
                            color: AppTheme.colorTextWhite),
                      ),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }

  _textField(String hint, String rightText, bool isEnable) {
    return AppRow(
      height: 50.h,
      padding: EdgeInsets.only(left: 17.w, right: 17.w),
      // padding: EdgeInsets.fromLTRB(26.w, 0, 26.w, 0),
      alignment: Alignment.center,
      color: AppTheme.colorDarkLightBg,
      radius: 6.w,
      children: [
        isEnable
            ? Expanded(
                child: TextField(
                controller: logic.diamondController,
                focusNode: logic.diamondFocusNode,
                onChanged: (text) {
                  logic.update();
                },
                keyboardType: TextInputType.text,
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
            : Expanded(
                child: Text(
                logic.coin.value.toString(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFFFFFFF),
                ),
              )),
        Text(
          rightText,
          style: TextStyle(fontSize: 16.sp, color: Colors.white),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
