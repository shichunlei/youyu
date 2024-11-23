import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/widgets/gift/model/common_gift_pop_model.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonGiftCountSheet extends StatelessWidget {
  const CommonGiftCountSheet(
      {super.key, required this.list, required this.onCustomCount});

  final List<CommonGiftCountModel> list;
  final Function onCustomCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      //这里44 是底部input栏的高度
      padding: EdgeInsets.only(bottom: 44.h + 8.h),
      alignment: Alignment.bottomRight,
      child: AppColumn(
        margin: EdgeInsets.only(right: 16.w),
        width: 121.w,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppColumn(
            padding: EdgeInsets.only(
                left: 12.w, right: 12.w, top: 8.h, bottom: 10.h),
            radius: 10.w,
            color: const Color(0xFF585858),
            children: [
              ListView.builder(
                  itemCount: list.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    CommonGiftCountModel model = list[index];
                    return AppRow(
                      onTap: () {
                        Get.back(result: model.count);
                      },
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      height: 30.h,
                      color: Colors.transparent,
                      children: [
                        Text(
                          "${model.count}",
                          style: AppTheme().textStyle(
                              fontSize: 12.sp,
                              color: AppTheme.colorTextWhite),
                        ),
                        Text(
                          model.name,
                          style: AppTheme().textStyle(
                              fontSize: 12.sp,
                              color: AppTheme.colorMain),
                        )
                      ],
                    );
                  }),
              AppColorButton(
                onClick: () {
                  Get.back();
                  onCustomCount();
                },
                alignment: Alignment.centerLeft,
                height: 30.h,
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                bgColor: Colors.transparent,
                title: "自定义数量",
                fontSize: 12.sp,
                titleColor: AppTheme.colorTextWhite,
              )
            ],
          ),
          AppContainer(
            padding: EdgeInsets.only(left: (122 / 4).w),
            alignment: Alignment.centerLeft,
            child: AppLocalImage(
              fit: BoxFit.fill,
              path: AppResource().liveGraySz,
              width: 10.w,
            ),
          )
        ],
      ),
    );
  }
}
