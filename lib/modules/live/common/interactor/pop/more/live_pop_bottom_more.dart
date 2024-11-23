import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/models/localmodel/menu_model.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/live/common/interactor/pop/more/live_pop_bottom_more_logic.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LivePopBottomMore extends StatefulWidget {
  const LivePopBottomMore(
      {super.key,
      required this.isOwner,
      required this.isManager,
      required this.isCloseAni,
      required this.isCloseScreen});

  //是否是主播
  final bool isOwner;

  //是否是管理
  final bool isManager;

  //是否关闭动效
  final bool isCloseAni;

  //是否关闭公屏
  final bool isCloseScreen;

  @override
  State<LivePopBottomMore> createState() => _LivePopBottomMoreState();
}

class _LivePopBottomMoreState extends State<LivePopBottomMore> {
  late LivePopBottomMoreLogic logic = Get.find<LivePopBottomMoreLogic>();

  @override
  void initState() {
    super.initState();
    Get.put<LivePopBottomMoreLogic>(LivePopBottomMoreLogic());
    logic.isManager = widget.isManager;
    logic.isOwner = widget.isOwner;
    logic.isCloseAni = widget.isCloseAni;
    logic.isCloseScreen = widget.isCloseScreen;
    logic.fetchData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppColumn(
      color: AppTheme.colorDarkBg,
      crossAxisAlignment: CrossAxisAlignment.center,
      topLeftRadius: 12.w,
      topRightRadius: 12.w,
      height: 230.h + ScreenUtils.safeBottomHeight,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      children: [
        Text(
          "更多",
          style:
              TextStyle(fontSize: 18.sp, color: AppTheme.colorTextWhite),
        ),
        SizedBox(
          height: 22.h,
        ),
        _list()
      ],
    );
  }

  _list() {
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //水平子Widget之间间距
          crossAxisSpacing: 8.w,
          //垂直子Widget之间间距
          mainAxisSpacing: 20.h,
          //一行的Widget数量
          crossAxisCount: 4,
          //子Widget宽高比例
          childAspectRatio: 60 / 50,
        ),
        itemCount: logic.list.length,
        itemBuilder: (BuildContext context, int index) {
          MenuModel model = logic.list[index];
          return AppColumn(
            onTap: () {
              Get.back(result: model);
            },
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppLocalImage(
                path: model.icon,
                width: 22.w,
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                model.title,
                style: AppTheme().textStyle(
                    fontSize: 14.sp, color: AppTheme.colorTextSecond),
              )
            ],
          );
        });
  }
}
