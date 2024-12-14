import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/conversation_controller.dart';
import 'package:youyu/modules/index/widget/index_page_widget.dart';
import 'package:youyu/modules/primary/message/index/widget/message_tab_bar.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/widgets/top_bg/top_ba.dart';
import '../../index/message_index_logic.dart';
import 'contact/message_contact_view.dart';
import 'conversation/message_conversation_view.dart';
import 'package:youyu/widgets/page_life_state.dart';

class MessageIndexPage extends IndexWidget {
  const MessageIndexPage({Key? key}) : super(key: key);

  @override
  State<MessageIndexPage> createState() => _MessageIndexPageState();

  @override
  void onTabTap({param}) {}
}

class _MessageIndexPageState extends PageLifeState<MessageIndexPage>
    with AutomaticKeepAliveClientMixin {
  final logic = Get.find<MessageIndexLogic>();

  final GlobalKey<MessageTabBarState> tabBarKey =
      GlobalKey<MessageTabBarState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppPage<MessageIndexLogic>(
      topBg: const TopBgCommon(),
      backgroundColor: AppTheme.colorPinkWhiteBg,
      resizeToAvoidBottomInset: false,
      appBar: MessageTabBar(
        logic: logic,
        key: tabBarKey,
        onClickClearUnRead: () {
          ConversationController.to.onClickClearUnRead();
        },
      ),
      childBuilder: (s) {
        return NotificationListener<ScrollNotification>(
          child: TabBarView(
              controller: logic.tabController,
              children: logic.tabs.map((e) {
                if (e.id == 0) {
                  return const MessageConversationPage();
                } else {
                  return const MessageContactPage();
                }
              }).toList()),
          onNotification: (ScrollNotification scrollNotification) {
            // 监听实时更新，迅速动画，TabController监听有效的是ScrollEndNotification
            if (scrollNotification is ScrollUpdateNotification &&
                scrollNotification.depth == 0) {
              // 一般页面都是左右滚动
              if (scrollNotification.metrics.axisDirection ==
                  AxisDirection.right) {
                // 滚动百分比，0.0-1.0
                double progress = scrollNotification.metrics.pixels /
                    scrollNotification.metrics.maxScrollExtent;
                double unit = 1.0 / logic.tabs.length;
                int index = progress ~/ unit;
                tabBarKey.currentState?.updateIndex(index);
              }
            }
            return true;
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void onPagePause() {}

  @override
  void onPageResume() {}
}
