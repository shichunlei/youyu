import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/time_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/models/gift_record.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';
import 'package:youyu/widgets/app/other/app_segmentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'live_sub_gift_notice_logic.dart';

class LiveSubGiftNoticePage extends StatelessWidget {
  LiveSubGiftNoticePage({Key? key}) : super(key: key);

  final logic = Get.find<LiveSubGiftNoticeLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<LiveSubGiftNoticeLogic>(
      appBar: const AppTopBar(
        title: "礼物详情",
      ),
      childBuilder: (s) {
        return AppListSeparatedView(
          padding:
              EdgeInsets.only(top: 2.h, bottom: ScreenUtils.safeBottomHeight),
          controller: logic.refreshController,
          itemCount: logic.dataList.length,
          isOpenLoadMore: false,
          isOpenRefresh: false,
          separatorBuilder: (_, int index) {
            return AppSegmentation(
              height: 0.5.h,
              backgroundColor: AppTheme.colorLine,
            );
          },
          itemBuilder: (_, int index) {
            GiftRecord item = logic.dataList[index];
            return AppRow(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              height: 77.h,
              children: [
                AppNetImage(
                  imageUrl: item.image,
                  width: 50.w,
                  height: 50.w,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                    child: AppColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.userName ?? "",
                      style: AppTheme().textStyle(
                          fontSize: 14.sp,
                          color: AppTheme.colorTextWhite),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Text(
                      "送给 ${item.toUserName ?? ""}",
                      style: AppTheme().textStyle(
                          fontSize: 12.sp,
                          color: AppTheme.colorTextSecond),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Text(
                      "${item.giftName ?? ""} x${item.num ?? 0}",
                      style: AppTheme().textStyle(
                          fontSize: 12.sp,
                          color: AppTheme.colorTextSecond),
                    )
                  ],
                )),
                AppContainer(
                  margin: EdgeInsets.only(top: 10.h),
                  alignment: Alignment.topRight,
                  child: Text(
                    TimeUtils.displayTime(item.createTime ??
                        DateTime.now().millisecondsSinceEpoch ~/ 1000),
                    style: AppTheme().textStyle(
                        fontSize: 12.sp,
                        color: AppTheme.colorTextSecond),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }
}
