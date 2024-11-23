import 'package:youyu/utils/platform_utils.dart';
import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/config.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/app_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/modules/submod/web/param/web_model.dart';
import 'package:youyu/modules/wallet/recharge/index/widget/pay_info_item.dart';
import 'package:youyu/router/router.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'recharge_index_logic.dart';

class RechargeIndexPage extends StatefulWidget {
  const RechargeIndexPage({Key? key}) : super(key: key);

  @override
  State<RechargeIndexPage> createState() => _RechargeIndexPageState();
}

class _RechargeIndexPageState extends State<RechargeIndexPage> {
  final RechargeIndexLogic logic = Get.find<RechargeIndexLogic>();

  @override
  void initState() {
    super.initState();
    logic.initPayInfoList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppPage<RechargeIndexLogic>(
      appBar: const AppTopBar(
        title: "充值",
      ),
      childBuilder: (s) {
        return Container(
            padding: EdgeInsets.all(15.w),
            child: GetBuilder<RechargeIndexLogic>(builder: (s) {
              return SingleChildScrollView(
                child: Obx(() => Column(
                      children: [
                        _top(),
                        SizedBox(
                          height: 15.h,
                        ),
                        _list(),
                        SizedBox(
                          height: 30.h,
                        ),
                        //充值
                        Opacity(
                          opacity: logic.isVerify() ? 1 : 0.5,
                          child: AppColorButton(
                            onClick: () {
                              if (s.curSelModel != null) {
                                // if (PlatformUtils.isIOS) {
                                //   Get.toNamed(
                                //       AppRouter()
                                //           .walletPages
                                //           .applePayRoute
                                //           .name,
                                //       parameters: {
                                //         "price": s.curSelModel?.subTitle ?? "",
                                //         "productId": s.curSelModel?.extra ?? ""
                                //       });
                                // }
                                // else {
                                Get.toNamed(
                                    AppRouter().walletPages.payRoute.name,
                                    parameters: {
                                      "price": s.curSelModel?.subTitle ?? ""
                                    });
                                // }
                              } else {
                                Get.toNamed(
                                    AppRouter().walletPages.payRoute.name,
                                    parameters: {
                                      "price": s.customModel?.subTitle ?? ""
                                    });
                              }
                            },
                            title: "立即充值",
                            height: 52.h,
                            titleColor: AppTheme.colorTextWhite,
                            bgGradient: AppTheme().btnGradient,
                          ),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Text(
                          "适度娱乐 理性消费",
                          style: AppTheme().textStyle(
                              fontSize: 14.sp, color: AppTheme.colorTextDark),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        InkWell(
                          onTap: () {
                            Get.toNamed(AppRouter().otherPages.webRoute.name,
                                arguments: WebParam(
                                    url: AppController.to.rechargeAgreement,
                                    title: "充值协议"));
                          },
                          child: RichText(
                              text: TextSpan(
                            text: "1.充值前请仔细阅读",
                            style: AppTheme().textStyle(
                                fontSize: 12.sp,
                                color: AppTheme.colorTextSecond),
                            children: <TextSpan>[
                              TextSpan(
                                  style: AppTheme().textStyle(
                                      fontSize: 12.sp,
                                      color: AppTheme.colorMain),
                                  text: "《${AppConfig.appName}协议》"),
                              TextSpan(
                                style: AppTheme().textStyle(
                                    fontSize: 12.sp,
                                    color: AppTheme.colorTextSecond),
                                text: "，充值成功即代表您同意此协议的内容。",
                              ),
                            ],
                          )),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5.h),
                          alignment: Alignment.centerLeft,
                          child: Text("2.充值成功后无法退款，不可提现。",
                              textAlign: TextAlign.left,
                              style: AppTheme().textStyle(
                                  fontSize: 12.sp,
                                  color: AppTheme.colorTextSecond)),
                        ),
                      ],
                    )),
              );
            }));
      },
    );
  }

  /// 余额
  _top() {
    return AppRow(
      color: AppTheme.colorDarkBg,
      radius: 6.w,
      padding: EdgeInsets.only(left: 12.w, right: 12.w),
      height: 40.h,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("茶豆余额:",
            style: AppTheme()
                .textStyle(fontSize: 16.sp, color: AppTheme.colorTextWhite)),
        Text(
          "${(UserController.to.coins)}",
          style:
              AppTheme().textStyle(fontSize: 16.sp, color: AppTheme.colorMain),
        )
      ],
    );
  }

  /// 列表
  _list() {
    return AppColumn(
      width: double.infinity,
      color: AppTheme.colorDarkBg,
      radius: 6.w,
      padding: EdgeInsets.all(15.w),
      children: [
        GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //水平子Widget之间间距
              crossAxisSpacing: 1.w,
              //垂直子Widget之间间距
              mainAxisSpacing: 1.w,
              //一行的Widget数量
              crossAxisCount: 3,
              //子Widget宽高比例
              childAspectRatio: 100 / 80,
            ),
            itemCount: logic.payInfoList.length,
            itemBuilder: (BuildContext context, int index) {
              return PayInfoItem(
                  model: logic.payInfoList[index],
                  curSelModel: logic.curSelModel,
                  onClick: (item) {
                    if (logic.curSelModel != item) {
                      logic.curSelModel = item;
                      logic.setIsSelCustom = false;
                    }
                  });
            }),
        //自定义金额
        if (PlatformUtils.isAndroid)
          InkWell(
            onTap: logic.showCustomDialog,
            child: AppColumn(
              margin: EdgeInsets.only(top: 10.h, left: 5.w, right: 5.w),
              width: double.infinity,
              strokeColor:
                  logic.isSelCustom ? AppTheme.colorMain : Colors.transparent,
              strokeWidth: 1.w,
              radius: 6.w,
              color: logic.isSelCustom
                  ? const Color(0xFF475739)
                  : AppTheme.colorDarkLightBg,
              padding: EdgeInsets.only(left: 12.w, right: 12.w),
              height: 80.h,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "自定义金额",
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  logic.customModel != null
                      ? (logic.customModel?.title ?? "0")
                      : "请输入10的倍数",
                  style: AppTheme().textStyle(
                      fontSize: 12.sp, color: AppTheme.colorTextSecond),
                )
              ],
            ),
          ),
      ],
    );
  }
}
