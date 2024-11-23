import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/modules/live/common/widget/ml/widget/live_claer_charm_user.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveClearCharmSheet extends StatefulWidget {
  const LiveClearCharmSheet(
      {super.key, required this.users});

  final List<UserInfo> users;

  @override
  State<LiveClearCharmSheet> createState() => _LiveClearCharmSheetState();
}

class _LiveClearCharmSheetState extends State<LiveClearCharmSheet> {
  List<UserInfo> selUsers = [];

  //有效用户数量
  int allCount = 0;

  //是否全选
  bool isSelAll = false;

  @override
  void initState() {
    super.initState();
    for (UserInfo value in widget.users) {
      if (value.id != -1) {
        allCount++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppColumn(
      color: AppTheme.colorDarkBg,
      width: double.infinity,
      height: 295.w + ScreenUtils.safeBottomHeight,
      topRightRadius: 22.w,
      topLeftRadius: 22.w,
      padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          top: 20.w,
          bottom: 20.w + ScreenUtils.safeBottomHeight),
      children: [
        Expanded(
            child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //水平子Widget之间间距
                  crossAxisSpacing: 1,
                  //垂直子Widget之间间距
                  mainAxisSpacing: 1,
                  //一行的Widget数量
                  crossAxisCount: 5,
                  //子Widget宽高比例
                  childAspectRatio: 52 / 75,
                ),
                itemCount: widget.users.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  UserInfo userInfo;
                  if (index < 9) {
                    userInfo = widget.users[index];
                  } else {
                    userInfo = UserInfo(id: -1);
                  }
                  return LiveClearCharmUserItem(
                      isSelAll: isSelAll,
                      isSelected: selUsers.contains(userInfo),
                      onTap: () {
                        if (index == 9) {
                          selUsers.clear();
                          if (!isSelAll) {
                            for (UserInfo user in widget.users) {
                              if (user.id != -1) {
                                selUsers.add(user);
                              }
                            }
                          }
                          isSelAll = !isSelAll;
                          setState(() {});
                        } else {
                          if (userInfo.id != -1) {
                            setState(() {
                              if (selUsers.contains(userInfo)) {
                                selUsers.remove(userInfo);
                              } else {
                                selUsers.add(userInfo);
                              }
                              if (selUsers.length == allCount) {
                                isSelAll = true;
                              } else {
                                isSelAll = false;
                              }
                            });
                          }
                        }
                      },
                      index: index,
                      user: userInfo);
                })),
        AppColorButton(
          margin: EdgeInsets.only(left: 15.w, right: 15.w),
          titleColor: AppTheme.colorTextWhite,
          title: "清空",
          fontSize: 18.sp,
          bgGradient: AppTheme().btnGradient,
          height: 56.h,
          onClick: () async {
            if (selUsers.isNotEmpty) {
              Get.back(result: selUsers);
            } else {
              ToastUtils.show("请选择要清空魅力值的人");
            }
          },
        ),
      ],
    );
  }
}
