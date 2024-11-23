import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/gift.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserGiftPop extends StatelessWidget {
  const UserGiftPop({super.key, required this.itemModel});

  final Gift itemModel;

  @override
  Widget build(BuildContext context) {
    return AppColumn(
      mainAxisSize: MainAxisSize.min,
      radius: 10.w,
      margin: EdgeInsets.symmetric(horizontal: 27.w),
      color: AppTheme.colorDarkBg,
      mainAxisAlignment: MainAxisAlignment.center,
      padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 14.h),
      children: [
        AppRow(
          height: 40.h,
          children: [
            SizedBox(
              width: 29.w,
            ),
            Expanded(
                child: Text(
              itemModel.name,
              textAlign: TextAlign.center,
              style: AppTheme().textStyle(
                  fontSize: 18.sp, color: AppTheme.colorTextWhite),
            )),
            AppContainer(
              onTap: () {
                Get.back();
              },
              width: 29.w,
              height: 29.w,
              child: Center(
                child: AppLocalImage(
                  width: 16.w,
                  path: AppResource().close,
                  imageColor: AppTheme.colorTextWhite,
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        _centerGift(),
        SizedBox(
          height: 31.h,
        ),
        Text(
          '通过礼物界面可直接赠送',
          style: AppTheme().textStyle(
              fontSize: 14.sp, color: AppTheme.colorTextSecond),
        ),
        SizedBox(
          height: 20.h,
        ),
      ],
    );
  }

  _centerGift() {
    return AppColumn(
      width: 140.w,
      height: 167.h,
      mainAxisAlignment: MainAxisAlignment.center,
      color: AppTheme.colorDarkLightBg,
      radius: 8.w,
      onTap: () {},
      children: [
        AppNetImage(
          width: double.infinity,
          height: 100.h,
          imageUrl: itemModel.image,
          fit: BoxFit.contain,
          defaultWidget: const SizedBox.shrink(),
        ),
        SizedBox(
          height: 10.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppLocalImage(
              path: AppResource().coin2,
              width: 15.w,
            ),
            SizedBox(
              width: 7.w,
            ),
            Text(
              itemModel.unitPrice.toString(),
              style: AppTheme().textStyle(
                  fontSize: 14.sp, color: AppTheme.colorTextWhite),
            ),
          ],
        )
      ],
    );
  }
}
