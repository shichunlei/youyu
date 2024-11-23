import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/models/localmodel/image_model.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reorderables/reorderables.dart';
import 'user_image_manager_logic.dart';

class UserImageManagerPage extends StatelessWidget {
  UserImageManagerPage({Key? key}) : super(key: key);

  final logic = Get.find<UserImageManagerLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<UserImageManagerLogic>(
      appBar: const AppTopBar(
        title: "照片管理",
      ),
      childBuilder: (s) {
        return AppColumn(
          margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          children: [
            _imageWidget(),
            // _vipCard(),
            SizedBox(
              height: 63.h,
            ),
            AppColorButton(
                width: 238.w,
                height: 56.w,
                onClick: () {
                  logic.uploadImages();
                },
                padding: EdgeInsets.zero,
                fontSize: 16.sp,
                title: '添加照片到照片墙',
                titleColor: AppTheme.colorTextWhite,
                bgGradient: AppTheme().btnGradient),
          ],
        );
      },
    );
  }

  _imageWidget() {
    return AppColumn(
      padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 8.h),
      radius: 6.w,
      color: AppTheme.colorDarkBg,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppRow(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          height: 37.h,
          children: [
            Text(
              '长按可移动图片顺序',
              style: AppTheme().textStyle(
                  fontSize: 12.sp, color: AppTheme.colorTextSecond),
            ),
            Text(
              '非会员只可上传3张照片',
              style: AppTheme().textStyle(
                  fontSize: 12.sp, color: const Color(0xFFCDCDCD)),
            ),
          ],
        ),
        Obx(() =>
            ReorderableWrap(
                spacing: 6.w,
                runSpacing: 6.w,
                alignment: WrapAlignment.start,
                onReorder: logic.onReorder,
                children: logic.imageList.map((model) {
                  if (model.type == ImageModelType.add) {
                    return AppLocalImage(
                        width: logic.itemWidth,
                        height: logic.itemWidth,
                        onTap: () {
                          logic.addImage();
                        },
                        path: AppResource().imgAdd);
                  }
                  return AppStack(children: [
                    AppNetImage(
                      fit: BoxFit.cover,
                      width: logic.itemWidth,
                      height: logic.itemWidth,
                      key: ValueKey(model.imageId),
                      imageUrl: model.imageUrl,
                      radius: BorderRadius.all(Radius.circular(8.w)),
                      defaultWidget: AppTheme().defaultNewImage(
                          color: AppTheme.colorDarkLightBg),
                      errorWidget: AppTheme().defaultNewImage(
                          color: AppTheme.colorDarkLightBg),
                    ),
                    Positioned(
                        right: 0,
                        child: AppContainer(
                          onTap: () {
                            logic.delImage(model);
                          },
                          width: 20.w,
                          height: 20.w,
                          child: Center(
                            child: AppLocalImage(
                              path: AppResource().imgDel,
                              width: 14.w,
                            ),
                          ),
                        ))
                  ],);
                }).toList()))
      ],
    );
  }

  _vipCard() {
    return AppRow(
      crossAxisAlignment: CrossAxisAlignment.center,
      padding: EdgeInsets.only(left: 18.w, right: 5.w),
      height: 40.h,
      color: const Color(0xFF1B1B2D),
      margin: EdgeInsets.only(top: 15.h),
      radius: 99.h,
      children: [
        AppLocalImage(
          path: AppResource().mineVipLeft,
          height: 21.h,
        ),
        SizedBox(
          width: 10.w,
        ),
        Expanded(
          child: Text(
            "开通VIP可上传9张照片",
            style: AppTheme().textStyle(
                fontSize: 14.sp, color: AppTheme.colorTextWhite),
          ),
        ),
        AppColorButton(
          onClick: logic.onClickOpenVip,
          title: "立即开通",
          height: 32.h,
          borderRadius: BorderRadius.all(Radius.circular(99.w)),
          fontSize: 12.sp,
          alignment: Alignment.center,
          titleColor: AppTheme.colorTextPrimary,
          padding: EdgeInsets.only(left: 8.w, right: 8.w),
          bgGradient: AppTheme().vipGradient,
        )
      ],
    );
  }

}
