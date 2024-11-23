import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/material.dart';

class LevelFirstItem extends StatelessWidget {
  const LevelFirstItem({super.key});

  @override
  Widget build(BuildContext context) {
    return AppRow(
      topLeftRadius: 6.w,
      topRightRadius: 6.w,
      height: 42.h,
      color: const Color(0xFF1C2A21),
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      children: [
        Expanded(child: _text("等级")),
        Expanded(child: _text("经验值")),
        Expanded(child: _text("等级图标")),
      ],
    );
  }

  _text(String text) {
    return Center(
        child: Text(
      text,
      style: AppTheme().textStyle(fontSize: 14.sp, color: AppTheme.colorTextWhite),
    ));
  }
}
