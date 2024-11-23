import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/material.dart';
import '../model/record_list_model.dart';

class RechargeRecordItem extends StatelessWidget {
  const RechargeRecordItem({super.key, required this.model});

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
          height: 55.h,
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
        Text(
          model.title ?? "",
          style: TextStyle(fontSize: 16.sp, color: Colors.white),
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
          style: TextStyle(fontSize: 18.sp, color: AppTheme.colorMain),
        ),
      ],
    );
  }
}
