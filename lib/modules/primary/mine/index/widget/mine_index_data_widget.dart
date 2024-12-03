import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/models/localmodel/menu_model.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/modules/primary/mine/index/mine_index_logic.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/icon/app_un_read_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///好友、访客等
class MineIndexDataWidget extends StatelessWidget {
  const MineIndexDataWidget({super.key, required this.logic});

  final MineIndexLogic logic;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 62.h,
        margin: EdgeInsets.only(bottom: 15.h),
        child: GridView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //水平子Widget之间间距
              crossAxisSpacing: 1,
              //垂直子Widget之间间距
              mainAxisSpacing: 1,
              //一行的Widget数量
              crossAxisCount: 3,
              //子Widget宽高比例
              childAspectRatio: (ScreenUtils.screenWidth / 3) / 62.h,
            ),
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              return AppStack(
                onTap: () {
                  _event(index);
                },
                fit: StackFit.expand,
                children: [
                  _unRead(index),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(
                        () => Text(
                          _count(index),
                          style: AppTheme().textStyle(
                              fontSize: 20.sp,
                              color: AppTheme.colorTextDarkSecond,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        _title(index),
                        style: AppTheme().textStyle(
                            fontSize: 14.sp, color: AppTheme.colorTextSecond),
                      )
                    ],
                  )
                ],
              );
            }));
  }

  ///未读数量
  _unRead(int index) {
    switch (index) {
      case 0:
        return Container();
      case 1:
        return Container();
      case 2:
        return (UserController.to.userInfo.value?.focusNewCount ?? 0) > 0
            ? Positioned(
                top: 0,
                right: 30.w,
                child: AppUnReadIcon(
                    number:
                        (UserController.to.userInfo.value?.focusNewCount ?? 0)))
            : Container();
    }
    return Container();
  }

  ///数量
  _count(int index) {
    switch (index) {
      case 0:
        return (UserController.to.userInfo.value?.friendCount ?? 0).toString();
      case 1:
        return (UserController.to.userInfo.value?.focusRoomCount ?? 0)
            .toString();
      case 2:
        return (UserController.to.userInfo.value?.accessCount ?? 0).toString();
    }
    return "";
  }

  ///标题
  _title(int index) {
    switch (index) {
      case 0:
        return "好友";
      case 1:
        return "关注直播间";
      case 2:
        return "客访";
    }
    return "";
  }

  ///事件
  _event(int index) {
    switch (index) {
      case 0:
        logic.onClickMenu(MenuModel.createEventModel(MineIndexMenuType.friend));
        break;
      case 1:
        logic.onClickMenu(
            MenuModel.createEventModel(MineIndexMenuType.followLive));
        break;
      case 2:
        logic.onClickMenu(MenuModel.createEventModel(MineIndexMenuType.visit));
        break;
    }
  }
}
