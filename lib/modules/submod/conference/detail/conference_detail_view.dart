import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/utils/number_ext.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'conference_detail_logic.dart';

class ConferenceDetailPage extends StatelessWidget {
  ConferenceDetailPage({Key? key}) : super(key: key);

  final logic = Get.find<ConferenceDetailLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<ConferenceDetailLogic>(
      appBar: AppTopBar(
          title: "公会",
          rightAction: (logic.state.value == 1 || logic.state.value == 4 || logic.state.value == 5)
              ? AppContainer(
                  width: 40.w,
                  height: 40.h,
                  onTap: () {
                    logic.leaveConference();
                  },
                  child: Center(
                    child: AppLocalImage(
                      height: 18.h,
                      width: 18.w,
                      path: AppResource().more,
                    ),
                  ),
                )
              : null),
      childBuilder: (s) {
        return AppColumn(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          children: [
            SizedBox(
              height: 8.h,
            ),
            _topWidget(),
            SizedBox(
              height: 70.h,
            ),
            Obx(() {
              if (logic.state.value == 0) {
                return AppColorButton(
                  titleColor: AppTheme.colorTextWhite,
                  title: "申请加入",
                  fontSize: 18.sp,
                  bgGradient: AppTheme().btnGradient,
                  height: 56.h,
                  onClick: () {
                    logic.applyConference();
                  },
                );
              } else if (logic.state.value == 2) {
                return AppColorButton(
                  margin: EdgeInsets.only(left: 35.w, right: 35.w),
                  titleColor: AppTheme.colorTextWhite,
                  title: "取消申请",
                  fontSize: 18.sp,
                  bgGradient: AppTheme().btnGradient,
                  height: 56.h,
                  onClick: () {
                    logic.cancelConference();
                  },
                );
              } else {
                return const SizedBox.shrink();
              }
            })
          ],
        );
      },
    );
  }

  _topWidget() {
    return AppRow(
      radius: 6.w,
      color: AppTheme.colorDarkBg,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      height: 102.h,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppNetImage(
          width: 70.w,
          height: 70.w,
          imageUrl: logic.item.logo,
          radius: BorderRadius.circular(10.h),
        ),
        SizedBox(
          width: 15.h,
        ),
        Expanded(child: _centerWidget()),
      ],
    );
  }

  _centerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          logic.item.name ?? "",
          style: AppTheme().textStyle(
              fontSize: 14.sp,
              color: AppTheme.colorTextWhite,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 5.h,
        ),
        Text(
          "团结一致，共同努力。",
          style: AppTheme().textStyle(
              fontSize: 12.sp, color: AppTheme.colorTextSecond),
        ),
        SizedBox(
          height: 5.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                AppLocalImage(
                  path: AppResource().manLogo,
                  width: 8.w,
                ),
                SizedBox(
                  width: 3.w,
                ),
                Text(
                  (logic.item.userNum ?? 0).showNum(),
                  style: AppTheme().textStyle(
                      fontSize: 12.sp, color: const Color(0xFFD8D8D8)),
                )
              ],
            ),
            SizedBox(
              width: 16.w,
            ),
            Text(
              "ID:${logic.item.userNum}",
              style: AppTheme().textStyle(
                  fontSize: 12.sp, color: AppTheme.colorTextSecond),
            )
          ],
        )
      ],
    );
  }
}
