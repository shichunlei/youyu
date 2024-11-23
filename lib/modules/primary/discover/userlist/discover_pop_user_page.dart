import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/widgets/tabbar/curve_tab_bar.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/primary/discover/userlist/sub/discover_pop_user_view.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_round_container.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

///用户列表
class DiscoverPopUserPage extends StatefulWidget {
  const DiscoverPopUserPage({super.key, required this.mentionUserIds, required this.mentionUserNames});

  final List<String> mentionUserIds;
  final List<String> mentionUserNames;

  @override
  State<DiscoverPopUserPage> createState() => _DiscoverPopUserPageState();
}

class _DiscoverPopUserPageState extends State<DiscoverPopUserPage>
    with SingleTickerProviderStateMixin {
  ///tab
  late TabController tabController;
  List<TabModel> tabs = [
    TabModel(id: 3, name: "好友"),
    TabModel(id: 1, name: "关注"),
    TabModel(id: 2, name: "粉丝"),
  ];

  ///选择的id
  RxList<String> selUserIds = <String>[].obs;
  RxList<String> selUserNames = <String>[].obs;

  ///ref
  List<GlobalKey<DiscoverPopUserSubPageState>> keys = [
    GlobalKey<DiscoverPopUserSubPageState>(),
    GlobalKey<DiscoverPopUserSubPageState>(),
    GlobalKey<DiscoverPopUserSubPageState>(),
  ];

  ///当前索引
  int curIndex = 0;

  @override
  void initState() {
    super.initState();
    selUserIds.addAll(widget.mentionUserIds);
    selUserNames.addAll(widget.mentionUserNames);
    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(() {
      if (curIndex != tabController.index) {
        keys[tabController.index].currentState?.updateUI();
      }
      curIndex = tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppRoundContainer(
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.w), topRight: Radius.circular(12.w)),
        bgColor: AppTheme.colorDarkBg,
        height: 588.h,
        child: AppStack(
          children: [
            Column(children: [
              SizedBox(
                width: double.infinity,
                height: 68.h,
                child: CurveTabBar(
                  tabs: tabs,
                  fontSize: 14.sp,
                  tabController: tabController,
                  labelPadding: EdgeInsets.only(left: 8.w, right: 8.w),
                  indicatorPadding:
                      EdgeInsets.only(top: 25.h, left: 2.w, right: 2.w),
                  isScrollable: false,
                ),
              ),
              Expanded(
                  child: Container(
                      color: Colors.transparent,
                      child: TabBarView(
                          controller: tabController,
                          children: tabs.mapIndexed((index, e) {
                            return DiscoverPopUserSubPage(
                                key: keys[index],
                                tabModel: e,
                                selUserIds: selUserIds,
                                selUserNames:selUserNames);
                          }).toList()))),
            ]),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Obx(
                  () => AppContainer(
                      color: AppTheme.colorDarkBg,
                      child: Opacity(
                        opacity: selUserIds.isNotEmpty ? 1 : 0.5,
                        child: AppColorButton(
                          margin: EdgeInsets.only(
                              left: 25.w,
                              right: 25.w,
                              top: 8.h,
                              bottom: 8.h + ScreenUtils.safeBottomHeight),
                          title: "确认",
                          titleColor: AppTheme.colorTextWhite,
                          bgGradient: AppTheme().btnGradient,
                          height: 50.h,
                          onClick: () {
                            if (selUserIds.isNotEmpty) {
                              Get.back(result: {
                                'ids':selUserIds,
                                "names":selUserNames
                              });
                            }
                          },
                        ),
                      )),
                ))
          ],
        ));
  }
}
