import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/shop_item.dart';
import 'package:youyu/models/shop_price_item.dart';
import 'package:youyu/router/router.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/icon/app_more_icon.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopBuyDialog extends StatefulWidget {
  const ShopBuyDialog({super.key, required this.item});

  final ShopItem item;

  @override
  State<ShopBuyDialog> createState() => _ShopBuyDialogState();
}

class _ShopBuyDialogState extends State<ShopBuyDialog> {
  final List<ShopPriceItem> dataList = [];
  ShopPriceItem? curPriceBean;

  @override
  void initState() {
    super.initState();
    dataList.addAll(widget.item.price ?? []);
    curPriceBean = dataList.first;
  }

  @override
  Widget build(BuildContext context) {
    return AppColumn(
      color: AppTheme.colorDarkBg,
      height: 278.h + ScreenUtils.safeBottomHeight,
      topRightRadius: 20.w,
      topLeftRadius: 20.w,
      children: [
        AppContainer(
          height: 58.h,
          child: Center(
            child: Text(
              '茶豆购买',
              style: AppTheme().textStyle(
                  fontSize: 18.sp, color: AppTheme.colorTextWhite),
            ),
          ),
        ),
        Expanded(child: _list()),
        _content(),
        _bottom()
      ],
    );
  }

  ///价格列表
  _list() {
    return AppContainer(
        height: 110.h,
        width: double.infinity,
        child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 15.w, right: 15.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //水平子Widget之间间距
              crossAxisSpacing: 8.w,
              //垂直子Widget之间间距
              mainAxisSpacing: 8.w,
              //一行的Widget数量
              crossAxisCount: 3,
              //子Widget宽高比例
              childAspectRatio: 1,
            ),
            itemCount: dataList.length,
            itemBuilder: (BuildContext context, int index) {
              ShopPriceItem model = dataList[index];
              int day = model.day ?? 0;
              String dayString = day.toString();
              if (day == -1) {
                dayString = "永久";
              }
              return AppColumn(
                onTap: () {
                  setState(() {
                    curPriceBean = model;
                  });
                },
                mainAxisAlignment: MainAxisAlignment.center,
                color: _isSel(model)
                    ? const Color(0xFF2B1C4C)
                    : AppTheme.colorDarkLightBg,
                radius: 10.w,
                strokeWidth: 1,
                strokeColor: _isSel(model)
                    ? const Color(0xFF612ADA)
                    : AppTheme.colorDarkLightBg,
                children: [
                  Text(
                    dayString,
                    style: AppTheme().textStyle(
                          fontSize: 18.sp,
                          color: _isSel(model)
                              ? const Color(0xFF612ADA)
                              : AppTheme.colorTextWhite,
                        ),
                  ),
                  AppRow(
                    margin: EdgeInsets.only(top: 10.h),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppLocalImage(
                        path: AppResource().coin2,
                        width: 14.w,
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Text(
                        (model.price ?? 0).toString(),
                        style: AppTheme().textStyle(
                            fontSize: 14.sp,
                            color: AppTheme.colorTextWhite),
                      ),
                    ],
                  )
                ],
              );
            }));
  }

  ///价格说明-> 去充值
  _content() {
    return AppRow(
      onTap: () {
        Get.toNamed(AppRouter().walletPages.rechargeRoute.name);
      },
      mainAxisAlignment: MainAxisAlignment.center,
      margin: EdgeInsets.only(left: 15.w, top: 15.h, right: 15.w),
      children: [
        AppLocalImage(
          path: AppResource().coin2,
          width: 14.w,
        ),
        SizedBox(
          width: 4.w,
        ),
        Obx(
          () => Flexible(
              child: Text(
            "茶豆余额: ${UserController.to.coins}",
            style: AppTheme().textStyle(
                fontSize: 14.sp, color: AppTheme.colorTextSecond),
          )),
        ),
        SizedBox(
          width: 7.w,
        ),
        AppMoreIcon(
            textColor: AppTheme.colorRed,
            imageColor: AppTheme.colorRed,
            title: "去充值",
            height: 15.h)
      ],
    );
  }

  ///购买按钮
  _bottom() {
    return AppColorButton(
        height: 56.h,
        margin: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 10.h,
            bottom: ScreenUtils.safeBottomHeight),
        onClick: () {
          if ((UserController.to.coins >= (curPriceBean?.price ?? 0))) {
            Get.back(result: curPriceBean);
          }
        },
        padding: EdgeInsets.zero,
        fontSize: 14.sp,
        title: (UserController.to.coins >= (curPriceBean?.price ?? 0))
            ? '购买'
            : "金币不足",
        titleColor: AppTheme.colorTextWhite,
        bgGradient: AppTheme().shopBtnGradient);
  }

  ///是否选中
  _isSel(ShopPriceItem model) {
    return model == curPriceBean;
  }
}
