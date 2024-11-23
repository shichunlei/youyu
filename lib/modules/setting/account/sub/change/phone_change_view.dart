import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/modules/setting/account/sub/change/phone_change_logic.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneChangePage extends StatefulWidget {
  const PhoneChangePage({Key? key}) : super(key: key);

  @override
  State<PhoneChangePage> createState() => _PhoneChangePageState();
}

class _PhoneChangePageState extends State<PhoneChangePage> {
  late PhoneChangeLogic logic = Get.find<PhoneChangeLogic>();

  @override
  void initState() {
    super.initState();
    Get.put(() => PhoneChangeLogic());
  }

//
  @override
  Widget build(BuildContext context) {
    return AppPage<PhoneChangeLogic>(
      appBar: const AppTopBar(
        title: "更换手机号",
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
                    height: 140.h,
                    color: AppTheme.colorDarkBg,
                    radius: 6.w,
                    padding: EdgeInsets.only(left: 12.w, right: 12.w),
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppLocalImage(
                        path: AppResource().walletAccountChange,
                        width: 42.w,
                        height: 52.h,
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      UserController.to.mobile.isNotEmpty
                          ? RichText(
                              text: TextSpan(
                              text: "已绑定手机号",
                              style: AppTheme().textStyle(
                                  fontSize: 12.sp,
                                  color: AppTheme.colorTextSecond),
                              children: <TextSpan>[
                                TextSpan(
                                    style: AppTheme().textStyle(
                                        fontSize: 12.sp,
                                        color: AppTheme.colorTextWhite),
                                    text: UserController.to.encryptMobile),
                              ],
                            ))
                          : Text(
                              '未绑定手机号',
                              style: AppTheme().textStyle(
                                  fontSize: 12.sp,
                                  color: AppTheme.colorTextSecond),
                            ),
                    ],
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  //完成
                  Opacity(
                    opacity: 1,
                    child: AppContainer(
                      onTap: () {
                        logic.onChange();
                      },
                      margin: EdgeInsets.only(top: 66.h),
                      height: 52.h,
                      gradient: AppTheme().btnGradient,
                      radius: 25.h,
                      alignment: Alignment.center,
                      child: Text(
                        "更换手机号",
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
}
