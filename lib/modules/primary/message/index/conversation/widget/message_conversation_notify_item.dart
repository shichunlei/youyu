import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/app_controller.dart';
import 'package:youyu/controllers/conversation_controller.dart';
import 'package:youyu/services/im/model/im_msg_type.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/icon/app_un_read_icon.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../message_conversation_logic.dart';

///系统/通知会话通知item
class MessageConversationNotifyItem extends StatelessWidget {
  const MessageConversationNotifyItem(
      {super.key, required this.logic, required this.msgType});

  final MessageConversationLogic logic;
  final IMMsgType msgType;

  @override
  Widget build(BuildContext context) {
    return AppRow(
      onTap: () {
        ConversationController.to.onClickCustomConversation(msgType);
      },
      padding: EdgeInsets.fromLTRB(13.w, 10.h, 9.w, 10.h),
      color: Colors.transparent,
      children: [_itemHeader(), _itemContent()],
    );
  }

  _itemHeader() {
    return Stack(
      children: [
        AppLocalImage(
          path: msgType == IMMsgType.officialNotice
              ? AppResource().msgOfficialNotice
              : AppResource().msgOfficialSystem,
          width: 48.w,
          height: 48.w,
        ),
        Obx(
          () => _unReadCount() > 0
              ? Positioned(
                  right: 0,
                  child: AppUnReadIcon(
                    number: _unReadCount(),
                  ),
                )
              : const SizedBox(),
        )
      ],
    );
  }

  _unReadCount() {
    if (msgType == IMMsgType.officialSystem) {
      return AppController.to.sysUnReadCount.value;
    } else {
      return AppController.to.noticeUnReadCount.value;
    }
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
              Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    msgType == IMMsgType.officialNotice ? "官方公告" : "系统通知",
                    textAlign: TextAlign.left,
                    style: AppTheme().textStyle(
                        fontSize: 14.sp, color: AppTheme.colorTextWhite),
                  )),
              // 时间
              Text(
                "",
                style: AppTheme().textStyle(
                    fontSize: 10.sp, color: AppTheme.colorTextSecond),
              )
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          Text("点击查看",
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
