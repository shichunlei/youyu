import 'package:youyu/models/localmodel/image_model.dart';
import 'package:youyu/widgets/svga/simple_player_repeat.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:flutter/material.dart';
import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:get/get.dart';
import 'live_setting_room_bg_logic.dart';

///房间背景
class LiveSettingRoomBgPop extends StatefulWidget {
  const LiveSettingRoomBgPop({super.key, required this.title, this.curUrl, this.roomId});

  final int? roomId;
  final String? curUrl;
  final String title;

  @override
  State<LiveSettingRoomBgPop> createState() => _LiveSettingRoomBgPopState();
}

class _LiveSettingRoomBgPopState extends State<LiveSettingRoomBgPop> {
  late LiveSettingRoomBgLogic logic = Get.find<LiveSettingRoomBgLogic>();

  @override
  void initState() {
    super.initState();
    Get.put<LiveSettingRoomBgLogic>(LiveSettingRoomBgLogic());
    logic.curUrl = widget.curUrl;
    logic.roomId = widget.roomId;
    logic.fetchList();
  }

  @override
  Widget build(BuildContext context) {
    return AppColumn(
      width: double.infinity,
      height: 448.h,
      radius: 10.w,
      margin: EdgeInsets.symmetric(horizontal: 25.w),
      color: AppTheme.colorDarkBg,
      mainAxisAlignment: MainAxisAlignment.start,
      padding: EdgeInsets.symmetric(horizontal: 33.w, vertical: 14.h),
      children: [
        Text(
          widget.title,
          style: AppTheme().textStyle(
              fontSize: 16.sp, color: AppTheme.colorTextWhite),
        ),
        SizedBox(
          height: 23.h,
        ),
        Expanded(
            child: AppPage<LiveSettingRoomBgLogic>(
          isUseScaffold: false,
          childBuilder: (s) {
            return Column(
              children: [
                _list(),
                SizedBox(
                  height: 33.h,
                ),
                AppColorButton(
                  margin: EdgeInsets.only(left: 35.w, right: 35.w),
                  titleColor: AppTheme.colorTextWhite,
                  title: "确定",
                  fontSize: 18.sp,
                  bgGradient: AppTheme().btnGradient,
                  height: 56.h,
                  onClick: () async {
                    bool isSuc = await logic.onUpdateBg();
                    Get.back(result: isSuc);
                  },
                ),
              ],
            );
          },
        ))
      ],
    );
  }

  _list() {
    double listWidth = (ScreenUtils.screenWidth - (25 + 33) * 2.w);
    return SizedBox(
      height: listWidth + 12.h,
      child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //水平子Widget之间间距
            crossAxisSpacing: 6.w,
            //垂直子Widget之间间距
            mainAxisSpacing: 10.w,
            //一行的Widget数量
            crossAxisCount: 3,
            //子Widget宽高比例
            childAspectRatio: 1,
          ),
          itemCount: logic.imageList.length,
          itemBuilder: (BuildContext context, int index) {
            ImageModel model = logic.imageList[index];
            return AppStack(
              fit: StackFit.expand,
              onTap: () {
                setState(() {
                  logic.selModel = model;
                });
              },
              radius: 8.w,
              strokeWidth: 2.w,
              strokeColor: logic.selModel?.imageId == model.imageId
                  ? AppTheme.colorMain
                  : Colors.transparent,
              children: [
                (model.ext as String).contains(".svga")
                    ? SVGASimpleImageRepeat(
                        resUrl: model.imageUrl,
                        fit: BoxFit.cover,
                      )
                    : AppNetImage(
                        radius: BorderRadius.all(Radius.circular(8.w)),
                        fit: BoxFit.cover,
                        imageUrl: model.imageUrl,
                      )
              ],
            );
          }),
    );
  }
}
