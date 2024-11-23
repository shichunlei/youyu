import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///离开弹窗
class LivePopClose extends StatelessWidget {
  const LivePopClose({super.key,
    required this.onPackUpRoom,
    required this.onReportRoom,
    required this.onLeaveRoom});

  final Function onPackUpRoom;
  final Function onReportRoom;
  final Function onLeaveRoom;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _itemWidget(AppResource().liveWindowBtn, '收起房间', () {
            Get.back();
            onPackUpRoom();
          }),
          _itemWidget(AppResource().liveReport, '举报', () {
            Get.back();
            onReportRoom();
          }),
          _itemWidget(AppResource().liveMoreClose, '退出房间', () {
            Get.back();
            onLeaveRoom();
          })
        ],
      ),
    );
  }

  _itemWidget(String img, String title, var onTap) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Column(
        children: [
          AppLocalImage(
            path: img,
            width: 51.w,
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            title,
            style: AppTheme().textStyle(
                fontSize: 12.sp, color: AppTheme.colorTextWhite),
          )
        ],
      ),
    );
  }
}
