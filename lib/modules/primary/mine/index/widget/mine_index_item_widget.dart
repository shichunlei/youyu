import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/models/localmodel/menu_model.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_round_container.dart';
import 'package:youyu/widgets/app/icon/app_more_icon.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';

class MineIndexItemWidget extends StatelessWidget {
  const MineIndexItemWidget(
      {super.key, required this.list, required this.onClick});

  final List<MenuModel> list;
  final Function(MenuModel model) onClick;

  @override
  Widget build(BuildContext context) {
    return AppRoundContainer(
        alignment: Alignment.center,
        height: 51.h * list.length,
        borderRadius: BorderRadius.all(Radius.circular(8.w)),
        bgColor: AppTheme.colorWhiteBg,
        margin: EdgeInsets.only(top: 11.h, left: 14.w, right: 14.w),
        child: ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (context, index) {
              MenuModel model = list[index];
              return InkWell(
                onTap: () {
                  onClick(model);
                },
                child: Container(
                  height: 51.h,
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _leftWidget(model),
                      AppMoreIcon(
                        height: 7.h,
                        isShowText: false,
                      )
                    ],
                  ),
                ),
              );
            }));
  }

  _leftWidget(MenuModel model) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppLocalImage(
          path: model.icon,
          width: 20.w,
        ),
        SizedBox(
          width: 13.w,
        ),
        Text(
          model.title,
          style: AppTheme()
              .textStyle(fontSize: 14.sp, color: AppTheme.colorTextDarkSecond),
        )
      ],
    );
  }
}
