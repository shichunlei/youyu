import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/material.dart';
import '../model/record_list_model.dart';

class WithDrawRecordIndexItem extends StatelessWidget {
  const WithDrawRecordIndexItem({super.key, required this.model});

  final RecordListModel model;

  @override
  Widget build(BuildContext context) {
    return AppColumn(
      padding: EdgeInsets.only(left: 15.w, right: 15.w),
      children: [
        SizedBox(
          height: 15.h,
        ),
        SizedBox(
          height: 65.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 10, child: _left()),
              Expanded(flex: 8, child: _right())
            ],
          ),
        ),
        SizedBox(
          height: 15.h,
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
            Text(
              model.title ?? "",
              style: TextStyle(fontSize: 16.sp, color: Colors.white),
            ),
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
        if (model.rightSubValue != null)
          SizedBox(
            height: 4.h,
          ),
        if (model.rightSubValue != null)
          Text(
            model.rightSubValue ?? "",
            textAlign: TextAlign.right,
            maxLines: 2,
            style: AppTheme().textStyle(fontSize: 12.sp, color: _stateColor()),
          )
      ],
    );
  }

  //(0 未处理 1 通过 2未通过)
  _stateColor() {
    switch (model.withDrawState) {
      case 0:
        return AppTheme.colorTextSecond;
      case 1:
        return AppTheme.colorMain;
      case 2:
        return AppTheme.colorRed;
    }
    return AppTheme.colorMain;
  }
}
