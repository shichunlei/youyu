import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/material.dart';
import '../model/record_list_model.dart';

class CoinRecordIndexItem extends StatelessWidget {
  const CoinRecordIndexItem({super.key, required this.model});

  final RecordListModel model;

  @override
  Widget build(BuildContext context) {
    return AppColumn(
      height: 55.h + 15.h + 15.5.h,
      padding: EdgeInsets.only(left: 15.w, right: 15.w),
      children: [
        Expanded(
          child: SizedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 12, child: _left()),
                Expanded(flex: 8, child: _right())
              ],
            ),
          ),
        ),
        Container(
          color: AppTheme.colorLine,
          height: 0.5.h,
        )
      ],
    );
  }

  _left() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
                child: Text(
              model.title ?? "",
              maxLines: 2,
              style: TextStyle(fontSize: 16.sp, color: Colors.white,overflow: TextOverflow.ellipsis),
            )),
            if (model.exTitle != null)
              Expanded(
                  child: ShaderMask(
                shaderCallback: (rect) {
                  return const LinearGradient(
                    colors: [Color(0xFFFF7676), Color(0xFFFCCA1A)],
                  ).createShader(rect);
                },
                child: Text(
                  model.exTitle ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme().textStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.colorTextWhite),
                ),
              ))
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          model.time ?? "",
          style: AppTheme().textStyle(
              fontSize: 12.sp, color: AppTheme.colorTextSecond),
        )
      ],
    );
  }

  _right() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          model.rightValue ?? "",
          style: TextStyle(
              fontSize: 18.sp,
              color: model.isIn ? AppTheme.colorMain : Colors.white),
        ),
      ],
    );
  }
}
