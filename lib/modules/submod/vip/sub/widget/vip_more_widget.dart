import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/models/localmodel/menu_model.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/submod/vip/model/vip_index_model.dart';
import 'package:youyu/modules/submod/vip/vip_logic.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';

class VipMoreWidget extends StatelessWidget {
  const VipMoreWidget({super.key, required this.list});

  final List<VipMoreModel> list;

  @override
  Widget build(BuildContext context) {
    return AppColumn(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10.h),
          height: 1.w,
          color: const Color(0xFF808080),
        ),
        AppContainer(
          margin: EdgeInsets.only(left: 17.w, right: 17.w, top: 17.h),
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) {
                VipMoreModel model = list[index];
                return _itemContent(model);
              }),
        )
      ],
    );
  }

  _itemContent(VipMoreModel model) {
    return AppColumn(
      topRightRadius: 13.w,
      topLeftRadius: 13.w,
      gradientBegin: Alignment.topCenter,
      gradientEnd: Alignment.bottomCenter,
      gradientStartColor: const Color(0xFF3E3E3E),
      gradientEndColor: const Color(0x003E3E3E),
      children: [
        AppRow(
          height: 42.h,
          strokeColor: VipLogic.borderColor(model.isSVip),
          strokeWidth: 1.w,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          crossAxisAlignment: CrossAxisAlignment.center,
          alignment: Alignment.center,
          gradientBegin: Alignment.topCenter,
          gradientEnd: Alignment.bottomCenter,
          gradientStartColor: const Color(0xFFD8D8D8),
          gradientEndColor: const Color(0x00D8D8D8),
          topRightRadius: 13.w,
          topLeftRadius: 13.w,
          children: [
            AppLocalImage(
                width: 14.w,
                path: model.isSVip
                    ? AppResource().vipSV
                    : AppResource().vipV),
            SizedBox(
              width: 2.w,
            ),
            Container(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Text(
                model.title,
                style: AppTheme().textStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: VipLogic.textColor(model.isSVip)),
              ),
            ),
            SizedBox(
              width: 3.w,
            ),
            Text(
              model.subTitle,
              style: AppTheme().textStyle(fontSize: 12.sp, color: const Color(0xFF606060)),
            ),
          ],
        ),
        _gridContent(model.list, model.isSVip)
      ],
    );
  }

  _gridContent(List<MenuModel> list, bool isSVip) {
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 15.h, bottom: 40.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //水平子Widget之间间距
          crossAxisSpacing: 1,
          //垂直子Widget之间间距
          mainAxisSpacing: 20.h,
          //一行的Widget数量
          crossAxisCount: 3,
          //子Widget宽高比例
          childAspectRatio: 107 / (218 / 2),
        ),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          MenuModel model = list[index];
          return AppColumn(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppLocalImage(
                path: model.icon,
                width: 50.w,
              ),
              SizedBox(
                height: 6.h,
              ),
              Text(
                model.title,
                style: AppTheme().textStyle(
                    fontSize: 14.sp, color: VipLogic.textColor(isSVip)),
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                model.subTitle ?? "",
                style: AppTheme().textStyle(
                    fontSize: 13.sp, color: const Color(0xFF9E9E9E)),
              ),
            ],
          );
        });
  }
}
