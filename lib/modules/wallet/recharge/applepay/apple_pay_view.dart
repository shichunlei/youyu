import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'apple_pay_logic.dart';

class ApplePayPage extends StatelessWidget {
  ApplePayPage({Key? key}) : super(key: key);

  final logic = Get.find<ApplePayLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<ApplePayLogic>(
      appBar: const AppTopBar(title: "支付"),
      childBuilder: (s) {
        return Container(
            padding: EdgeInsets.all(15.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AppColumn(
                    margin: EdgeInsets.only(top: 15.h),
                    width: double.infinity,
                    height: 80.h,
                    color: AppTheme.colorDarkBg,
                    radius: 6.w,
                    padding: EdgeInsets.only(left: 12.w, right: 12.w),
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("¥${s.price}",
                          style: AppTheme().textStyle(
                              fontSize: 16.sp,
                              color: AppTheme.colorRed)),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        "支付金额（元）",
                        style: AppTheme().textStyle(
                            fontSize: 14.sp,
                            color: AppTheme.colorTextWhite),
                      )
                    ],
                  ),
                  // AppColumn(
                  //   margin: EdgeInsets.only(top: 15.h),
                  //   width: double.infinity,
                  //   color: AppTheme.colorDarkBg,
                  //   radius: 6.w,
                  //   padding: EdgeInsets.only(left: 19.w, right: 19.w),
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: [
                  //     Container(
                  //       height: 40.h,
                  //       alignment: Alignment.centerLeft,
                  //       child: Text("苹果支付",
                  //           style: AppTheme().textStyle(
                  //               fontSize: 16.sp,
                  //               color: AppTheme.colorTextWhite)),
                  //     ),
                  //     ListView.builder(
                  //         physics: const NeverScrollableScrollPhysics(),
                  //         shrinkWrap: true,
                  //         itemCount: s.payStyleList.length,
                  //         itemBuilder: (context, index) {
                  //           MenuModel model = s.payStyleList[index];
                  //           return AppRow(
                  //             onTap: () {
                  //               logic.selectedPayType(model);
                  //             },
                  //             height: 48.h,
                  //             crossAxisAlignment: CrossAxisAlignment.center,
                  //             children: [
                  //               AppLocalImage(
                  //                 path: model.icon,
                  //                 width: 28.w,
                  //                 height: 28.w,
                  //               ),
                  //               SizedBox(
                  //                 width: 10.w,
                  //               ),
                  //               Expanded(
                  //                 child: Text(model.title,
                  //                     style: AppTheme().textStyle(
                  //                         fontSize: 14.sp,
                  //                         color:
                  //                             AppTheme.colorTextSecond)),
                  //               ),
                  //               s.curModel.title == model.title
                  //                   ? AppLocalImage(
                  //                       path: AppResource().sel,
                  //                       width: 20.w,
                  //                       height: 20.w,
                  //                     )
                  //                   : AppLocalImage(
                  //                       path: AppResource().unSel,
                  //                       width: 20.w,
                  //                       height: 20.w,
                  //                     )
                  //             ],
                  //           );
                  //         }),
                  //   ],
                  // ),
                  //充值
                  AppColorButton(
                    onClick: () {
                      logic.onPay();
                    },
                    title: "确定苹果支付",
                    margin: EdgeInsets.only(top: 74.h),
                    height: 52.h,
                    titleColor: AppTheme.colorTextWhite,
                    bgGradient: AppTheme().btnGradient,
                  )
                ],
              ),
            ));
      },
    );
  }
}
