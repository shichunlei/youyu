import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_round_container.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';

///公告弹窗
class LivePopNotice extends StatelessWidget {
  const LivePopNotice(
      {super.key,
      required this.offset,
      required this.size,
      required this.notice});

  final Offset offset;
  final Size size;
  final String notice;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: 22.w,
          right: 22.w,
          top: offset.dy - ScreenUtils.statusBarHeight + 22.h + 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: offset.dx),
            alignment: Alignment.centerLeft,
            child: AppLocalImage(
              path: AppResource().liveWhiteSz,
              width: 10.w,
            ),
          ),
          AppRoundContainer(
              borderRadius: BorderRadius.all(Radius.circular(6.w)),
              constraints: BoxConstraints(minHeight: 131.h, maxHeight: 200.h),
              padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 15.w),
              bgColor: const Color(0xCCFFFFFF),
              child: _list())
        ],
      ),
    );
  }
  _list() {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '房间公告',
            style: AppTheme().textStyle(
                fontSize: 14.sp,
                color: const Color(0xFF000000)),
          ),
          SizedBox(
            height: 14.h,
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              notice,
              maxLines: 999,
              style: AppTheme().textStyle(
                  fontSize: 12.sp,
                  color: AppTheme.colorTextPrimary),
            ),
          )
        ],
      ),
    );
  }
}
