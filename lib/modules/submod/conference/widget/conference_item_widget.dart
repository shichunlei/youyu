import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/conference.dart';
import 'package:youyu/utils/number_ext.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:flutter/material.dart';

class ConferenceItemWidget extends StatelessWidget {
  const ConferenceItemWidget(
      {super.key, required this.item, required this.onClickItem});

  final ConferenceItem item;
  final Function onClickItem;

  @override
  Widget build(BuildContext context) {
    return AppRow(
      onTap: () {
        onClickItem();
      },
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      height: 55.h,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppNetImage(
          width: 50.w,
          height: 50.w,
          imageUrl: item.logo,
          radius: BorderRadius.circular(10.h),
        ),
        SizedBox(
          width: 10.h,
        ),
        Expanded(child: _centerWidget()),
        _rightWidget()
      ],
    );
  }

  _centerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          item.name ?? "",
          style: AppTheme().textStyle(
              fontSize: 14.sp,
              color: AppTheme.colorTextWhite,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 3.h,
        ),
        Text(
          "团结一致，共同努力。",
          style: AppTheme().textStyle(
              fontSize: 12.sp, color: AppTheme.colorTextSecond),
        )
      ],
    );
  }

  _rightWidget() {
    return Row(
      children: [
        AppLocalImage(path: AppResource().manLogo, width: 8.w,),
        SizedBox(width: 3.w,),
        Text((item.userNum ?? 0).showNum(), style: AppTheme().textStyle(
            fontSize: 12.sp, color: const Color(0xFFD8D8D8)),)
      ],
    );
  }
}
