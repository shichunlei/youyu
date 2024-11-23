import 'package:youyu/controllers/app_controller.dart';
import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';

import 'common_gift_desc_logic.dart';

class CommonGiftDescPage extends StatelessWidget {
  CommonGiftDescPage({Key? key}) : super(key: key);

  final logic = Get.find<CommonGiftDescLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<CommonGiftDescLogic>(
      appBar: const AppTopBar(title: "礼物说明"),
      childBuilder: (s) {
        return AppContainer(
          // radius: 8.h,
          color: AppTheme.colorDarkBg,
          // margin: EdgeInsets.only(
          //     left: 14.w,
          //     right: 14.w,
          //     top: 14.h,
          //     bottom: ScreenUtils.safeBottomHeight),
          padding: EdgeInsets.symmetric(vertical: 0.h),
          child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: s.dataList.length,
              itemBuilder: (context, index) {
                // ItemTitleModel model = s.dataList[index];
                // return AppColumn(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   alignment: Alignment.centerLeft,
                //   padding: EdgeInsets.symmetric(horizontal: 14.w),
                //   children: [
                //     AppRow(
                //       onTap: () {
                //         s.updateData(model);
                //       },
                //       height: 40.h,
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Expanded(
                //           child: Text(
                //             model.title,
                //             style: AppTheme().textStyle(
                //                 fontSize: 16.sp,
                //                 color: AppTheme.colorTextWhite),
                //           ),
                //         ),
                //         Icon(
                //           model.extra == true
                //               ? Icons.keyboard_arrow_up_outlined
                //               : Icons.keyboard_arrow_down_outlined,
                //           size: 20.w,
                //           color: AppTheme.colorTextSecond,
                //         )
                //       ],
                //     ),
                //     if (model.extra == true)
                //       Text(
                //         model.subTitle ?? "",
                //         maxLines: 10000,
                //         textAlign: TextAlign.left,
                //         style: AppTheme().textStyle(
                //             fontSize: 14.sp,
                //             color: AppTheme.colorTextSecond),
                //       )
                //   ],
                // );
                return AppNetImage(
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                  imageUrl: AppController.to.appInitData.value?.gift_describe,
                );
              }),
        );
      },
    );
  }
}
