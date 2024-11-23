import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/models/my_getuserinfo.dart';

import 'live_link_owner_invite_logic.dart';

class LiveLinkOwnerInvitePage extends StatefulWidget {
  const LiveLinkOwnerInvitePage(
      {super.key, required this.tabModel, required this.roomId, required this.onlineUserList});

  final TabModel tabModel;
  final int roomId;
  final List<UserInfo> onlineUserList;

  @override
  State<LiveLinkOwnerInvitePage> createState() => _LiveLinkOwnerInvitePageState();
}

class _LiveLinkOwnerInvitePageState extends State<LiveLinkOwnerInvitePage> {

  final logic = Get.put(LiveLinkOwnerInviteLogic());

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
