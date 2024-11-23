import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'withdraw_logic.dart';

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({Key? key, this.commission,}) : super(key: key);
  final String? commission;
  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {

  late WithdrawLogic logic = Get.find<WithdrawLogic>();

  @override
  void initState() {
    super.initState();
    Get.put<WithdrawLogic>(WithdrawLogic());
  }

  @override
  Widget build(BuildContext context) {
    return AppPage<WithdrawLogic>(
      childBuilder: (s) {
        return Obx(() => SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 15.h,
              ),
              Text(
                "总资产（钻石）",
                style: AppTheme().textStyle(
                    fontSize: 16.sp, color: AppTheme.colorTextWhite),
              ),
              SizedBox(
                height: 4.5.h,
              ),
              Text(
                "${UserController.to.diamonds}",
                style: AppTheme().textStyle(
                    fontSize: 20.sp, color: AppTheme.colorMain),
              ),
              AppColumn(
                margin: EdgeInsets.only(top: 32.h),
                width: double.infinity,
                color: AppTheme.colorDarkBg,
                radius: 6.w,
                padding: EdgeInsets.only(left: 23.w, right: 23.w),
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppRow(
                    onTap: () {
                      logic.pushToAccount();
                    },
                    height: 54.h,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "到户账户",
                        style: AppTheme().textStyle(
                            fontSize: 16.sp,
                            color: AppTheme.colorTextWhite),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12.w,
                        color: AppTheme.colorTextSecond,
                      )
                    ],
                  ),
                  Container(
                    height: 0.5.h,
                    color: AppTheme.colorLine,
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  Text(
                    "提现金额",
                    style: AppTheme().textStyle(
                        fontSize: 16.sp, color: AppTheme.colorTextWhite),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20.h, bottom: 13.h),
                    child: Row(
                      children: [
                        Text(
                          "¥",
                          style: AppTheme().textStyle(
                              fontSize: 20.sp,
                              color: AppTheme.colorTextWhite),
                        ),
                        Expanded(
                          child: _textField("请输入提现金额", logic.moneyController,
                              logic.moneyFocusNode),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 0.5.h,
                    color: AppTheme.colorLine,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  AppRow(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                    InkWell(
                      onTap: () {
                        logic.moneyController.text =
                        "${UserController.to.diamonds}";
                      },
                      child: Text(
                        "全部提现",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.colorMain,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    Text('提现手续费${widget.commission}%',style: AppTheme().textStyle(fontSize: 12.sp,color: AppTheme.colorTextSecond),)
                  ],),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 65.h,
                    child: Text(
                      "*注：1钻石=1元。",
                      style: TextStyle(
                          fontSize: 12.sp, color: const Color(0xFF999999)),
                    ),
                  )
                ],
              ),
              Opacity(
                opacity: logic.isVerify.value ? 1 : 0.5,
                child: AppContainer(
                  onTap: () {
                    logic.withdraw();
                  },
                  margin: EdgeInsets.only(top: 41.h),
                  height: 52.h,
                  gradient: AppTheme().btnGradient,
                  radius: 25.h,
                  // padding: EdgeInsets.fromLTRB(26.w, 0, 26.w, 0),
                  alignment: Alignment.center,
                  child: Text(
                    "提现",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.w,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.h,),
              AppContainer(
                onTap: () {
                  //TODO:test
                },
                alignment: Alignment.center,
                child: Text("查看提现规则",style: AppTheme().textStyle(fontSize: 12.sp,color: AppTheme.colorTextSecond),),
              )
            ],
          ),
        ));
      },
    );
  }

  _textField(
      String hint, TextEditingController controller, FocusNode focusNode) {
    return Container(
      margin: EdgeInsets.only(top: 3.h),
      height: 30.h,
      padding: EdgeInsets.only(left: 17.w, right: 17.w),
      // padding: EdgeInsets.fromLTRB(26.w, 0, 26.w, 0),
      alignment: Alignment.center,
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
      ),
    );
  }
}
