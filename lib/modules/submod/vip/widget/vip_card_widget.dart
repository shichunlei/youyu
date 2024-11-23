import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/submod/vip/model/vip_index_model.dart';
import 'package:youyu/modules/submod/vip/vip_logic.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';

class VipCardWidget extends StatelessWidget {
  const VipCardWidget({super.key, required this.model, required this.height});

  final VipCardModel model;
  final double height;

  @override
  Widget build(BuildContext context) {
    return AppColumn(
      margin: EdgeInsets.symmetric(horizontal: 30.w),
      padding: EdgeInsets.only(left: 6.w, right: 6.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.h),
          border: Border.all(
            width: 1.w,
            color: VipLogic.borderColor(model.isSVip),
          ),
          image: DecorationImage(
              image: AssetImage(AppResource().vipTopBg),
              fit: BoxFit.contain)),
      width: double.infinity,
      height: height,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _topWidget(),
        AppContainer(
          height: 40.h,
          alignment: Alignment.centerRight,
          child: Text(
            '未开通',
            style: AppTheme().textStyle(
                fontSize: 12.sp, color: VipLogic.textColor(model.isSVip)),
          ),
        )
      ],
    );
  }

  _topWidget() {
    return AppRow(
      crossAxisAlignment: CrossAxisAlignment.start,
      margin: EdgeInsets.only(top: 14.h),
      children: [
        AppCircleNetImage(
          size: 51.w,
          imageUrl: model.headUrl,
        ),
        SizedBox(
          width: 6.w,
        ),
        Expanded(
            child: AppColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.userName ?? "",
              style: AppTheme().textStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: VipLogic.textColor(model.isSVip)),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(model.subTitle ?? "",
                style: AppTheme().textStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: VipLogic.textColor(model.isSVip)))
          ],
        )),
        AppLocalImage(
          path: model.isSVip ? AppResource().svip : AppResource().vip,
          height: 18.h,
          fit: BoxFit.fitHeight,
        )
      ],
    );
  }
}
