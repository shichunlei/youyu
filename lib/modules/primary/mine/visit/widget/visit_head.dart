import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/models/localmodel/item_title_model.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/material.dart';

class VisitHead extends StatelessWidget {
  const VisitHead({super.key, required this.countList});

  final List<ItemTitleModel> countList;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
        height: 75.w,
        radius: 6.w,
        color: AppTheme.colorDarkBg,
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
              childAspectRatio: ((ScreenUtils.screenWidth - 30.w) / 3) / 74.w,
            ),
            itemCount: countList.length,
            itemBuilder: (BuildContext context, int index) {
              ItemTitleModel model = countList[index];
              return AppColumn(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    model.subTitle ?? "",
                    style: AppTheme().textStyle(
                        fontSize: 14.sp, color: AppTheme.colorTextWhite),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    model.title,
                    style: AppTheme().textStyle(
                        fontSize: 14.sp,
                        color: AppTheme.colorTextSecond),
                  )
                ],
              );
            }));
  }
}
