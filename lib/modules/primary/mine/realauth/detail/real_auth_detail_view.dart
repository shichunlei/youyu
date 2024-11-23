import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'real_auth_detail_logic.dart';

class RealAuthDetailPage extends StatelessWidget {
  RealAuthDetailPage({Key? key}) : super(key: key);

  final logic = Get.find<RealAuthDetailLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<RealAuthDetailLogic>(
      appBar: const AppTopBar(
        title: "实名认证",
      ),
      childBuilder: (s) {
        return AppColumn(
          margin: EdgeInsets.all(15.w),
          width: double.infinity,
          height: 140.h,
          gradient: AppTheme().btnGradient,
          radius: 10.w,
          padding: EdgeInsets.only(left: 15.w, right: 15.w),
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "已实名认证",
                  style: AppTheme().textStyle(
                      fontSize: 18.sp, color: AppTheme.colorTextPrimary),
                ),
                Text(
                  "信息安全保障中",
                  style: AppTheme().textStyle(
                      fontSize: 12.sp, color: AppTheme.colorTextPrimary),
                )
              ],
            ),
            Expanded(
                child: Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "姓名：${logic.name.value} ",
                          style: AppTheme().textStyle(
                              fontSize: 14.sp,
                              color: AppTheme.colorTextDark),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Text(
                          "身份证号：${logic.idNum}",
                          style: AppTheme().textStyle(
                              fontSize: 14.sp,
                              color: AppTheme.colorTextDark),
                        ),
                        SizedBox(
                          height: 20.h,
                        )
                      ],
                    )))
          ],
        );
      },
    );
  }
}
