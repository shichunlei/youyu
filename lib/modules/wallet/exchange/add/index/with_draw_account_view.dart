import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/router/router.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'with_draw_account_logic.dart';

class WithDrawAccountPage extends StatelessWidget {
  WithDrawAccountPage({Key? key}) : super(key: key);

  final logic = Get.find<WithDrawAccountLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<WithDrawAccountLogic>(
      appBar: AppTopBar(
        key: logic.navKey,
        title: "添加账号",
      ),
      childBuilder: (s) {
        return Container(
            padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 15.h),
            child: SingleChildScrollView(
              child: AppColumn(
                margin: EdgeInsets.only(top: 15.h),
                width: double.infinity,
                color: AppTheme.colorDarkLightBg,
                radius: 6.w,
                padding: EdgeInsets.only(left: 12.w, right: 12.w),
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _item("选择方式", "支付宝", false),
                  logic.accountModel != null
                      ? InkWell(
                          onTap: () {
                            Get.toNamed(AppRouter()
                                .walletPages
                                .withDrawAccountChangeRoute
                                .name,arguments: logic.accountModel);
                          },
                          child: _item("更换账号", "", true),
                        )
                      : InkWell(
                          onTap: () {
                            Get.toNamed(AppRouter()
                                .walletPages
                                .withDrawAccountAddRoute
                                .name);
                          },
                          child: _item("添加账号", "", true),
                        ),
                ],
              ),
            ));
      },
    );
  }

  _item(String title, String rightText, bool isRight) {
    return AppRow(
      height: 50.h,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14.sp, color: Colors.white),
        ),
        isRight
            ? Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.colorTextDark,
                size: 11.w,
              )
            : Text(
                rightText,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.colorTextDark,
                ),
              )
      ],
    );
  }
}
