import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/modules/live/index/live_index_logic.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/modules/live/common/message/live_message.dart';
import 'package:youyu/modules/live/common/widget/screen/tab/live_screen_tab_bar.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'list/live_screen_list_view.dart';
import 'live_screen_logic.dart';
import 'package:marquee/marquee.dart';

class LiveScreenWidget extends StatefulWidget {
  const LiveScreenWidget(
      {super.key,
      required this.onClickItem,
      required this.pageTag,
      required this.onClickUser,
      this.onClickLink});

  final Function(LiveMessageModel model) onClickItem;
  final Function(UserInfo userInfo) onClickUser;
  final Function? onClickLink;
  final String pageTag;

  @override
  State<LiveScreenWidget> createState() => LiveScreenWidgetState();
}

class LiveScreenWidgetState extends State<LiveScreenWidget> {
  late LiveScreenLogic logic = Get.find<LiveScreenLogic>(tag: widget.pageTag);

  @override
  void initState() {
    super.initState();
    Get.put<LiveScreenLogic>(LiveScreenLogic(), tag: widget.pageTag);
    logic.pageTag = widget.pageTag;
    logic.createTabs();
  }

  ///插入消息
  insertMessage(LiveMessageModel model) {
    logic.insertMessage(model);
  }

  ///清屏
  clearAllMessage() {
    logic.clearAllMessage();
  }

  ///处理遮罩
  processMaskType(LiveScreenMaskType maskType) {
    logic.processMaskType(maskType);
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      //先去掉
      if (LiveService().isOpenScreenTab)
        LiveScreenTabBar(
          tabs: logic.tabs,
          controller: logic.tabController,
        ),
      if (LiveService().isOpenScreenTab)
        SizedBox(
          height: 5.h,
        ),

      Expanded(
          child: Container(
              color: Colors.transparent,
              child: TabBarView(
                  physics: LiveService().isOpenScreenTab
                      ? const ClampingScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  controller: logic.tabController,
                  children: LiveService().isOpenScreenTab
                      ? _moreTab()
                      : _onlyOne()))),

      //todo 申请上麦

      // AppStack(
      //   onTap: () {
      //     if (widget.onClickLink != null) {
      //       widget.onClickLink!();
      //     }
      //   },
      //   width: double.infinity,
      //   height: 25.w + 16.w,
      //   padding: EdgeInsets.only(right: 15.w),
      //   children: [
      //     Positioned(
      //       top: 8.w,
      //       right: 0,
      //       child: AppLocalImage(
      //         path: AppResource().liveApplyWheat,
      //         width: 78.w,
      //         height: 25.w,
      //       ),
      //     ),
      //     Positioned(
      //         right: 1.w,
      //         top: 5.w,
      //         child: AppContainer(
      //           radius: 5.w,
      //           color: AppTheme.colorRed,
      //           width: 9.w,
      //           height: 9.w,
      //         ))
      //   ],
      // )

      //todo 一键全撩

      if (LiveIndexLogic.to.roomInfoObs.value?.typeName == '酒吧')
        AppStack(
          onTap: () {
            // if (widget.onClickLink != null) {
            //   widget.onClickLink!();
            // }
            List<UserInfo?> userlist = LiveIndexLogic.to.viewObs.onlineUserList;

            LiveIndexLogic.to.operation.onOperateBarGiveGift(
                gift: LiveIndexLogic.to.flirtGift, userlist: userlist);
          },
          width: double.infinity,
          height: 25.w + 16.w,
          padding: EdgeInsets.only(right: 15.w),
          children: [
            Positioned(
              top: 8.w,
              right: 0,
              child: AppLocalImage(
                path: AppResource().liveBarFlirtAll,
                width: 78.w,
                height: 25.w,
              ),
            ),
            // Positioned(
            //     right: 1.w,
            //     top: 5.w,
            //     child: AppContainer(
            //       radius: 5.w,
            //       color: AppTheme.colorRed,
            //       width: 9.w,
            //       height: 9.w,
            //     ))
          ],
        )
    ]);
  }

  _moreTab() {
    return [
      LiveScreenListPage(
        pageTag: widget.pageTag,
        tabModel: logic.tabs[0],
        onClickItem: widget.onClickItem,
        onClickUser: widget.onClickUser,
      ),
      LiveScreenListPage(
        pageTag: widget.pageTag,
        tabModel: logic.tabs[1],
        onClickItem: widget.onClickItem,
        onClickUser: widget.onClickUser,
      ),
      LiveScreenListPage(
        pageTag: widget.pageTag,
        tabModel: logic.tabs[2],
        onClickItem: widget.onClickItem,
        onClickUser: widget.onClickUser,
      )
    ];
  }

  _onlyOne() {
    return [
      LiveScreenListPage(
        pageTag: widget.pageTag,
        tabModel: logic.tabs[0],
        onClickItem: widget.onClickItem,
        onClickUser: widget.onClickUser,
      )
    ];
  }

  @override
  void dispose() {
    Get.delete<LiveScreenLogic>();
    super.dispose();
  }
}
