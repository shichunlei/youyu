import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:youyu/widgets/app/app_loading.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/list/app_wrap_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///房间类型
class LiveSettingRoomTypePop extends StatefulWidget {
  const LiveSettingRoomTypePop(
      {super.key, required this.title, this.defaultData});

  final String title;
  final Map<String, dynamic>? defaultData;

  @override
  State<LiveSettingRoomTypePop> createState() => _LiveSettingRoomTypePopState();
}

class _LiveSettingRoomTypePopState extends State<LiveSettingRoomTypePop> {
  bool isLoadFailed = false;
  Map<String, dynamic>? _typeData;

  @override
  void initState() {
    super.initState();
    _typeData = widget.defaultData;
    fetchList();
  }

  fetchList() async {
    try {
      await LiveService().fetchLiveClsList();
      setState(() {});
    } catch (e) {
      isLoadFailed = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppColumn(
      mainAxisSize: MainAxisSize.min,
      radius: 10.w,
      margin: EdgeInsets.symmetric(horizontal: 27.w),
      color: AppTheme.colorDarkBg,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 14.h),
      children: [
        Center(
          child: Text(
            widget.title,
            style: AppTheme().textStyle(
                fontSize: 16.sp, color: AppTheme.colorTextWhite),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        _typeList(),
        SizedBox(
          height: 20.h,
        ),
        AppColorButton(
          margin: EdgeInsets.only(left: 35.w, right: 35.w),
          titleColor: AppTheme.colorTextWhite,
          title: "完成",
          fontSize: 18.sp,
          bgGradient: AppTheme().btnGradient,
          height: 56.h,
          onClick: () {
            Get.back(result: _typeData);
          },
        ),
      ],
    );
  }

  _typeList() {
    if (LiveService().liveClassNameList.isEmpty) {
      return isLoadFailed
          ? InkWell(
              onTap: () {
                fetchList();
              },
              child: Text(
                '加载失败,点击重试',
                style: AppTheme().textStyle(
                    fontSize: 14.sp, color: const Color(0xFF9E9E9E)),
              ))
          : SizedBox(
              height: 111.h,
              child: const AppLoading(hasNavBar: false, isCanTouch: false),
            );
    }
    return AppWrapList(
      isMultiple: false,
      isSingleHigh: true,
      multipleDefaultList: [widget.defaultData?['name']],
      list: LiveService().liveClassNameList,
      onClickItem: (int index, String value) {
        _typeData = {
          'id': LiveService().liveClassList[index].id,
          'name': LiveService().liveClassList[index].name
        };
      },
    );
  }
}
