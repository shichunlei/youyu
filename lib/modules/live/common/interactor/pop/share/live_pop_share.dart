import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/models/localmodel/menu_model.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'live_pop_share_logic.dart';

class LivePopShare extends StatelessWidget {
  LivePopShare({Key? key}) : super(key: key);

  final logic = Get.put(LivePopShareLogic());

  @override
  Widget build(BuildContext context) {
    return AppColumn(
      color: AppTheme.colorDarkBg,
      crossAxisAlignment: CrossAxisAlignment.center,
      topLeftRadius: 12.w,
      topRightRadius: 12.w,
      height: 172.h + ScreenUtils.safeBottomHeight,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      children: [
        Text(
          "分享",
          style:
              TextStyle(fontSize: 18.sp, color: AppTheme.colorTextWhite),
        ),
        SizedBox(
          height: 22.h,
        ),
        _list()
      ],
    );
  }

  _list() {
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //水平子Widget之间间距
          crossAxisSpacing: 10.w,
          //垂直子Widget之间间距
          mainAxisSpacing: 20.h,
          //一行的Widget数量
          crossAxisCount: 5,
          //子Widget宽高比例
          childAspectRatio: 52 / 85,
        ),
        itemCount: logic.list.length,
        itemBuilder: (BuildContext context, int index) {
          MenuModel model = logic.list[index];
          return AppColumn(
            onTap: () {
              Get.back(result: model);
            },
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppLocalImage(
                path: model.icon,
                width: 52.w,
                height: 52.w,
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                model.title,
                style: AppTheme().textStyle(
                    fontSize: 12.sp, color: AppTheme.colorTextSecond),
              )
            ],
          );
        });
  }
}
