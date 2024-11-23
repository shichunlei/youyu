import 'package:youyu/models/localmodel/image_model.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:flutter/material.dart';
import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:get/get.dart';

import 'live_setting_room_cover_logic.dart';

///房间封面
class LiveSettingRoomCoverPop extends StatefulWidget {
  const LiveSettingRoomCoverPop(
      {super.key, required this.title, required this.avatar});

  final String title;
  final String avatar;

  @override
  State<LiveSettingRoomCoverPop> createState() =>
      _LiveSettingRoomCoverPopState();
}

class _LiveSettingRoomCoverPopState extends State<LiveSettingRoomCoverPop> {
  late LiveSettingRoomCoverLogic logic = Get.find<LiveSettingRoomCoverLogic>();

  @override
  void initState() {
    super.initState();
    Get.put<LiveSettingRoomCoverLogic>(LiveSettingRoomCoverLogic());
    logic.imageModel = ImageModel(imageUrl: widget.avatar);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppPage<LiveSettingRoomCoverLogic>(
      isUseScaffold: false,
      bodyHeight: 250.h,
      childBuilder: (s) {
        return AppColumn(
          height: 250.h,
          radius: 10.w,
          margin: EdgeInsets.symmetric(horizontal: 25.w),
          color: AppTheme.colorDarkBg,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          padding: EdgeInsets.symmetric(horizontal: 33.w, vertical: 14.h),
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                widget.title,
                style: AppTheme().textStyle(
                    fontSize: 16.sp, color: AppTheme.colorTextWhite),
              ),
            ),
            SizedBox(
              height: 23.h,
            ),
            (logic.imageModel == null)
                ? AppLocalImage(
                    onTap: () {
                      logic.onClickAdd();
                    },
                    path: AppResource().imgAdd,
                    width: 74.w,
                    height: 74.w,
                  )
                : AppNetImage(
                    onTap: () {
                      logic.onClickAdd();
                    },
                    imageUrl: logic.imageModel?.imageUrl ?? "",
                    width: 74.w,
                    height: 74.w,
                    fit: BoxFit.cover,
                    defaultWidget: AppTheme().defaultImage(
                        radius: 4.w,
                        width: 74.w,
                        height: 74.w,
                        color: AppTheme.colorTextPrimary),
                  ),
            SizedBox(
              height: 33.h,
            ),
            AppColorButton(
              margin: EdgeInsets.only(left: 15.w, right: 15.w),
              titleColor: AppTheme.colorTextWhite,
              title: "完成",
              fontSize: 18.sp,
              bgGradient: AppTheme().btnGradient,
              height: 56.h,
              onClick: () async {
                bool isSuc = await logic.onUpdateCover();
                Get.back(result: isSuc);
              },
            ),
          ],
        );
      },
    );
  }
}
