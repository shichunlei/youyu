import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NobilityQAPop extends StatelessWidget {
  const NobilityQAPop({super.key});

  @override
  Widget build(BuildContext context) {
    return AppColumn(
      mainAxisSize: MainAxisSize.min,
      radius: 10.w,
      margin: EdgeInsets.symmetric(horizontal: 27.w),
      color: AppTheme.colorDarkBg,
      mainAxisAlignment: MainAxisAlignment.center,
      padding: EdgeInsets.only(left: 17.w, right: 17.w, top: 0, bottom: 24.h),
      children: [
        AppStack(
          height: 50,
          children: [
            Center(
              child: Text(
                "说明",
                style: AppTheme().textStyle(
                    fontSize: 18.sp, color: AppTheme.colorTextWhite),
              ),
            ),
            Positioned(
              top: 15.h,
              right: 0,
              child: AppLocalImage(
                onTap: () {
                  Get.back();
                },
                width: 15.w,
                path: AppResource().close,
                imageColor: AppTheme.colorTextWhite,
              ),
            )
          ],
        ),
        _content()
      ],
    );
  }

  _content() {
    return Column(
      children: [
        Text(
          '1、爵位经验由礼物赠送的茶豆消费额决定(1茶豆=1经验)',
          maxLines: 10,
          style: AppTheme().textStyle(
              fontSize: 14.sp, color: AppTheme.colorTextWhite),
        ),
        SizedBox(
          height: 4.h,
        ),
        Text(
          '2、爵位由低到高依次为男爵、子爵、伯爵、侯爵、公爵、国王、帝王',
          maxLines: 10,
          style: AppTheme().textStyle(
              fontSize: 14.sp, color: AppTheme.colorTextWhite),
        ),
        SizedBox(
          height: 4.h,
        ),
        Text(
          '3、爵位从获得之日起有效期为30天，相关的升级、保级、降级规则:',
          maxLines: 12,
          style: AppTheme().textStyle(
              fontSize: 14.sp, color: AppTheme.colorTextWhite),
        ),
        SizedBox(
          height: 4.h,
        ),
        Text(
          '（1）升级:在当前爵位到期前，经验达到下一级爵位经验要求后则自动升级。',
          maxLines: 12,
          style: AppTheme().textStyle(
              fontSize: 14.sp, color: AppTheme.colorTextWhite),
        ),
        SizedBox(
          height: 4.h,
        ),
        Text(
          '（2）保级:在当前爵位到期时，若经验达到保级标准但未达到升级标准，则自动保级成功，有效期重置为30天，保级经验清零。',
          maxLines: 12,
          style: AppTheme().textStyle(
              fontSize: 14.sp, color: AppTheme.colorTextWhite),
        ),
        SizedBox(
          height: 4.h,
        ),
        Text(
          '（3）降级:在当前爵位到期时，经验未达到保级标准，则自动下降一级，降级后有效期重置为30天，如降级后保级经验不足则所有爵位经验清零。',
          maxLines: 12,
          style: AppTheme().textStyle(
              fontSize: 14.sp, color: AppTheme.colorTextWhite),
        ),
        SizedBox(
          height: 4.h,
        ),
      ],
    );
  }
}
