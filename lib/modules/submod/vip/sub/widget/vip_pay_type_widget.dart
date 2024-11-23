import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/models/localmodel/menu_model.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';

class VipPayTypeWidget extends StatelessWidget {
  const VipPayTypeWidget(
      {super.key, required this.list, required this.selModel, required this.onClickType});

  final List<MenuModel> list;
  final MenuModel? selModel;
  final Function(MenuModel model) onClickType;

  @override
  Widget build(BuildContext context) {
    return AppColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      margin: EdgeInsets.only(top: 12.h, left: 17.w, right: 17.w),
      children: [
        SizedBox(
          height: 10.h,
        ),
        Text(
          '支付方式',
          style: AppTheme().textStyle(
              fontSize: 16.sp, color: AppTheme.colorTextWhite),
        ),
        SizedBox(
          height: 10.h,
        ),
        ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (context, index) {
              MenuModel model = list[index];
              return AppRow(
                margin: EdgeInsets.only(left: 4.w),
                onTap: () {
                  onClickType(model);
                },
                crossAxisAlignment: CrossAxisAlignment.center,
                width: double.infinity,
                height: 50.h,
                children: [
                  AppLocalImage(
                    path: model.icon,
                    width: 40.w,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: Text(
                      model.title,
                      style: AppTheme().textStyle(
                          fontSize: 14.sp,
                          color: AppTheme.colorTextWhite),
                    ),
                  ),
                  AppLocalImage(
                      path: selModel == model
                          ? AppResource().check2
                          : AppResource().unCheck2,
                  width: 22.w,)
                ],
              );
            })
      ],
    );
  }
}
