import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/models/user_level.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:flutter/material.dart';

class LevelItem extends StatelessWidget {
  const LevelItem({super.key, required this.model, required this.index});

  final UserLevel model;
  final int index;

  @override
  Widget build(BuildContext context) {
    int exp = (model.minExp ?? 0);
    if (exp > 999) {
      exp = (model.minExp ?? 0) ~/ 1000;
    }

    return AppRow(
      height: 42.h,
      color: index % 2 == 0
          ? AppTheme.colorDarkBg
          : AppTheme.colorBg,
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      children: [
        Expanded(child: _text("${model.minLevel}-${model.maxLevel}")),
        Expanded(
            child: _text(
                "$exp${(model.minExp ?? 0) ~/ 1000 > 0 ? "k" : ""}-${(model.maxExp ?? 0) ~/ 1000}k")),
        Expanded(
            child: Center(
          child: _levelWidget(),
        ))
      ],
    );
  }

  _text(String text) {
    return Center(
        child: Text(
      text,
      style: AppTheme().textStyle(fontSize: 12.sp, color: AppTheme.colorTextSecond),
    ));
  }

  _levelWidget() {
    return SizedBox(
      width: double.infinity,
      child: Align(
        child: AppStack(
          width: 40.w,
          fit: StackFit.loose,
          alignment: Alignment.centerRight,
          children: [
            AppNetImage(
              imageUrl: model.img,
              width: 36.w,
              height: 20.w,
            ),
            Container(
              padding: EdgeInsets.only(
                  right: (model.maxLevel.toString()).length >= 3 ? 2.w : 5.w),
              child: Text(
                (model.maxLevel ?? 0).toString(),
                style: AppTheme().textStyle(
                    fontSize: 9.sp, color: AppTheme.colorTextWhite),
              ),
            )
          ],
        ),
      ),
    );
  }
}
