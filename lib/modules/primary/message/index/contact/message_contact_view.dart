import 'package:youyu/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'message_contact_logic.dart';
import 'sub/message_contact_sub_view.dart';
import 'widget/message_contact_tab_bar.dart';

class MessageContactPage extends StatefulWidget {
  const MessageContactPage({Key? key}) : super(key: key);

  @override
  State<MessageContactPage> createState() => _MessageContactPageState();
}

class _MessageContactPageState extends State<MessageContactPage>
    with AutomaticKeepAliveClientMixin {

  final logic = Get.put(MessageContactLogic());
  final GlobalKey<MessageContactState> tabBarKey =
      GlobalKey<MessageContactState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        SizedBox(
          height: 5.h,
        ),

        ///tabBar
        MessageContactTabBar(
          key: tabBarKey,
          tabs: logic.tabs,
          controller: logic.tabController,
          onClickTab: (int index) {
            logic.tabController.index = index;
          },
        ),
        ///sub page
        Expanded(
            child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: logic.tabController,
                children: logic.tabs.map((e) {
                  return MessageContactSubPage(
                    key: ValueKey(e.id.toString() + e.name),
                    tabModel: e,
                  );
                }).toList()))
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
