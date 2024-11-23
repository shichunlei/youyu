import 'dart:ui';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/widgets/app/app_loading.dart';
import 'package:youyu/widgets/create/live_create_logic.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/input/app_normal_input.dart';
import 'package:youyu/widgets/app/list/app_wrap_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveCreateDialog extends StatefulWidget {
  const LiveCreateDialog({super.key});

  @override
  State<LiveCreateDialog> createState() => _LiveCreateDialogState();
}

class _LiveCreateDialogState extends State<LiveCreateDialog> {
  final TextEditingController _controller = TextEditingController();

  late LiveCreateLogic logic = Get.find<LiveCreateLogic>();

  int _typeId = -1;

  @override
  void initState() {
    super.initState();
    Get.put<LiveCreateLogic>(LiveCreateLogic());
    Future.delayed(const Duration(milliseconds: 100), () => logic.fetchList());
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: AppColumn(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            padding: EdgeInsets.only(
                left: 14.w,
                right: 14.w,
                top: 20.h,
                bottom: 22.h + ScreenUtils.safeBottomHeight),
            color: const Color(0x99181818),
            topRightRadius: 12.w,
            topLeftRadius: 12.w,
            children: [
              // 名称
              Text(
                "房间名称",
                style: AppTheme().textStyle(
                    fontSize: 16.sp, color: const Color(0xFF9E9E9E)),
              ),
              SizedBox(
                height: 15.h,
              ),
              //输入
              AppNormalInput(
                  backgroundColor: const Color(0xFF000000),
                  height: 37.h,
                  fontSize: 14.sp,
                  controller: _controller,
                  textColor: AppTheme.colorTextWhite,
                  onChanged: (s) {},
                  placeHolder: "请输入房间名称"),
              SizedBox(
                height: 19.h,
              ),
              //分类列表
              GetBuilder<LiveCreateLogic>(builder: (s) {
                if (LiveService().liveClassNameList.isEmpty) {
                  return logic.isLoadFailed
                      ? InkWell(
                          onTap: () {
                            logic.fetchList();
                          },
                          child: Text(
                            '加载失败,点击重试',
                            style: AppTheme().textStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF9E9E9E)),
                          ))
                      : SizedBox(
                          height: 111.h,
                          child: const AppLoading(
                              hasNavBar: false, isCanTouch: false),
                        );
                }
                return AppWrapList(
                  isMultiple: false,
                  isSingleHigh: true,
                  list: LiveService().liveClassNameList,
                  onClickItem: (int index, String value) {
                    _typeId = LiveService().liveClassList[index].id;
                  },
                  onMultipleClick: (List<int> ins) {},
                );
              }),
              SizedBox(
                height: 19.h,
              ),
              //点击
              AppColorButton(
                margin: EdgeInsets.only(left: 15.w, right: 15.w),
                titleColor: const Color(0xFF000000),
                title: "创建直播间",
                fontSize: 18.sp,
                bgGradient: AppTheme().btnGradient,
                height: 46.h,
                onClick: () {
                  if (_controller.text.isEmpty) {
                    ToastUtils.show("请输入房间名称");
                    return;
                  }
                  if (_typeId == -1) {
                    ToastUtils.show("请选择房间类型");
                    return;
                  }
                  Get.back(result: {'name': _controller.text, 'type_id': _typeId});
                },
              ),
            ],
          )),
    );
  }
}
