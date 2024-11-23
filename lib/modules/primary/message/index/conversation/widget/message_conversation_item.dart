import 'dart:convert';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/time_utils.dart';

import 'package:youyu/widgets/user/user_avatar_state_widget.dart';
import 'package:youyu/widgets/user/user_info_widget.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/conversation_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/utils/format_utils.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';

///会话item
class MessageConversationItem extends StatefulWidget {
  const MessageConversationItem(
      {super.key,
      required this.conversation,
      required this.index,
      required this.onClickConversation});

  final int index;
  final V2TimConversation conversation;
  final Function(V2TimConversation conversation) onClickConversation;

  @override
  State<MessageConversationItem> createState() =>
      _MessageConversationItemState();
}

class _MessageConversationItemState extends State<MessageConversationItem>
    with TickerProviderStateMixin {
  UserInfo? userInfo;

  @override
  void initState() {
    super.initState();
    if (widget.conversation.customData?.isNotEmpty == true) {
      var map = jsonDecode(widget.conversation.customData!);
      userInfo = UserInfo.fromJson(map);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Slidable(
        groupTag: "1",
        key: ValueKey(widget.index),
        endActionPane: ActionPane(
          extentRatio: 0.25,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) async {
                ConversationController.to.delConversation(widget.index);
              },
              backgroundColor: AppTheme.colorRed,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: '删除',
            )
          ],
        ),
        child: AppRow(
          onTap: () async {
            widget.onClickConversation(widget.conversation);
          },
          padding: EdgeInsets.fromLTRB(13.w, 10.h, 9.w, 10.h),
          color: Colors.transparent,
          children: [_itemHeader(), _itemContent()],
        ),
      ),
    );
  }

  _itemHeader() {
    return UserAvatarStateWidget(
      avatar: widget.conversation.faceUrl ?? '',
      size: 48.w,
      unreadCount: widget.conversation.unreadCount ?? 0,
      userInfo: userInfo ?? UserInfo(id:FormatUtil.getRealId(widget.conversation.userID??"0")),
    );
  }

  _itemContent() {
    return Expanded(
      flex: 1,
      child: AppColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        margin: EdgeInsets.fromLTRB(10.w, 0, 0, 0),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UserInfoWidget(
                isHighFancyNum: false,
                name: widget.conversation.showName ?? '',
              ),
              // 时间
              Text(
                TimeUtils.displayTime(
                    (widget.conversation.lastMessage?.timestamp ?? 0)),
                style: AppTheme().textStyle(
                    fontSize: 10.sp, color: AppTheme.colorTextSecond),
              )
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
              ConversationController.to
                  .displayText(msg: widget.conversation.lastMessage),
              softWrap: true,
              maxLines: 1,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: AppTheme().textStyle(
                  fontSize: 12.sp, color: AppTheme.colorTextSecond)),
        ],
      ),
    );
  }
}
