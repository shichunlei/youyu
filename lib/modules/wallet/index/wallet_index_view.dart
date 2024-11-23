import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/models/localmodel/menu_model.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/router/router.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_round_container.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'wallet_index_logic.dart';
import 'package:youyu/widgets/page_life_state.dart';
class WalletIndexPage extends StatefulWidget {
  const WalletIndexPage({Key? key}) : super(key: key);

  @override
  State<WalletIndexPage> createState() => _WalletIndexPageState();
}

class _WalletIndexPageState extends PageLifeState<WalletIndexPage> {
  final logic = Get.find<WalletIndexLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<WalletIndexLogic>(
      appBar: const AppTopBar(
        title: "钱包",
      ),
      childBuilder: (s) {
        return Container(
          padding: EdgeInsets.all(15.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppRow(
                  width: ScreenUtils.screenWidth,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: _topSection(
                          1,
                          colors: [
                            const Color(0xFF1878CD),
                            const Color(0xFF72ECF5)
                          ],
                          title: "余额",
                          value:
                          "${(UserController.to.coins)}茶豆",
                          imagePath: AppResource().coin2,
                          btn: "充值",
                          onTap: () {
                            //充值
                            Get.toNamed(AppRouter().walletPages.rechargeRoute.name);
                          },
                        )),
                    SizedBox(
                      width: 8.w,
                    ),
                    Expanded(
                      child: _topSection(
                        2,
                        colors: [
                          const Color(0xFF7E54D8),
                          const Color(0xFFD563C6)
                        ],
                        title: "收益",
                        value:
                        "${(UserController.to.diamonds)}钻石",
                        imagePath: AppResource().coin3,
                        btn: "兑换",
                        onTap: () {
                          // 兑换
                          Get.toNamed(AppRouter().walletPages.exchangeRoute.name,arguments: logic.commission);
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                _list()
              ],
            ),
          ),
        );
      },
    );
  }

  /// 顶部
  _topSection(int index,
      {required List<Color> colors,
      required String title,
      required String value,
      required String imagePath,
      required String btn,
      required GestureTapCallback? onTap}) {
    return AppColumn(
      onTap: onTap,
      height: 134.h,
      padding:
          EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h, bottom: 10.h),
      gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
      radius: 10.w,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    value,
                    style: TextStyle(fontSize: 14.sp, color: Colors.white),
                  ),
                ],
              ),
            ),
            AppLocalImage(
              path: imagePath,
              width: index == 1 ? 33.w : 38.w,
              height: index == 1 ? 33.w : 38.w,
              fit: BoxFit.contain,
            ),
          ],
        ),
        AppRoundContainer(
            width: 78.w,
            height: 34.h,
            alignment: Alignment.center,
            gradient: AppTheme().btnGradient,
            child: Text(
              btn,
              style: AppTheme().textStyle(
                  fontSize: 14.sp, color: AppTheme.colorTextWhite),
            )),
      ],
    );
  }

  ///列表
  _list() {
    return Container(
      padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
      decoration: BoxDecoration(
          color: AppTheme.colorDarkBg,
          borderRadius: BorderRadius.circular(6.w)),
      child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: logic.itemList.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            MenuModel model = logic.itemList[index];
            return InkWell(
              onTap: () {
                switch (model.type) {
                  case WalletListType.backpack:
                    //背包礼物明细
                    Get.toNamed(AppRouter().walletPages.backPackOrderRoute.name);
                    break;
                  default:
                    //充值 & 提现记录 & 茶豆明细 & 钻石明细
                    Get.toNamed(AppRouter().walletPages.recordIndexRoute.name,
                        arguments: model);
                    break;
                }
              },
              child: AppRow(
                height: 52.h,
                padding: EdgeInsets.only(left: 20.w, right: 20.w),
                children: [
                  AppLocalImage(
                    path: model.icon,
                    width: 20.w,
                    height: 20.w,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: Text(
                      model.title,
                      style: TextStyle(fontSize: 14.sp, color: Colors.white),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 20.w,
                  )
                ],
              ),
            );
          }),
    );
  }

  @override
  void onPagePause() {
  }

  @override
  void onPageResume() {
    logic.setSuccessType();
  }
}
