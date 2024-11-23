import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/models/localmodel/item_title_model.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/icon/app_more_icon.dart';
import 'package:flutter/material.dart';

class SettingIndexItem extends StatelessWidget {
  const SettingIndexItem({super.key, required this.model});

  final ItemTitleModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54.h,
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      child: Column(
        children: [
          Expanded(child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                model.title,
                style: AppTheme().textStyle(
                    fontSize: 14.sp, color: AppTheme.colorTextSecond),
              ),
              const Expanded(child: SizedBox()),
              Text(
                model.subTitle ?? "",
                style: AppTheme().textStyle(
                    fontSize: 12.sp, color: AppTheme.colorTextDark),
              ),
              SizedBox(width: 10.w,),
              AppMoreIcon(
                height: 7.h,
                isShowText: false,
              )
            ],
          )),
          Container(color: const Color(0x0D000000),height: 1.sp,)
        ],
      ),
    );
  }
}
