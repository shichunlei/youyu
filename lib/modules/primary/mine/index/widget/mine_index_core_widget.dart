import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/models/localmodel/menu_model.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_round_container.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';

///核心功能区
class MineIndexCoreIndex extends StatelessWidget {
  const MineIndexCoreIndex({super.key, required this.list, required this.onClick});

  final List<MenuModel> list;
  final Function(MenuModel model) onClick;

  @override
  Widget build(BuildContext context) {
    return AppRoundContainer(
        alignment: Alignment.center,
        height: 77.h,
        borderRadius: BorderRadius.all(Radius.circular(8.w)),
        bgColor: AppTheme.colorDarkBg,
        margin: EdgeInsets.only(left: 14.w, right: 14.w),
        child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //水平子Widget之间间距
              crossAxisSpacing: 1,
              //垂直子Widget之间间距
              mainAxisSpacing: 1,
              //一行的Widget数量
              crossAxisCount: 3,
              //子Widget宽高比例
              childAspectRatio: ((ScreenUtils.screenWidth - 30.w) / 3) / 77.h,
            ),
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              MenuModel model = list[index];
              return InkWell(onTap: () {
                onClick(model);
              },child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppLocalImage(
                    path: model.icon,
                    width: 28.w,
                    height: 28.w,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    model.title,
                    style: AppTheme().textStyle(
                        fontSize: 12.sp, color: AppTheme.colorTextWhite),
                  )
                ],
              ),);
            }));
  }
}
