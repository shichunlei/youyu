import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/primary/message/message/list/widget/base/im_msg_base_menu.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:youyu/utils/time_utils.dart';

import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/modules/primary/message/message/list/message_chat_list_logic.dart';
import 'package:youyu/utils/format_utils.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';

class IMMsgBaseWidget extends StatefulWidget {
  static double itemMaxWidth =
      ScreenUtils.screenWidth - (20 * 2 + 48 + 10 + 10 + 48).w;

  static double imageHeight = 140.w;

  const IMMsgBaseWidget({
    super.key,
    this.isShowName = false,
    required this.message,
    required this.index,
    required this.logic,
  });

  final MessageChatListLogic logic;

  ///索引
  final int index;

  ///是否显示昵称
  final bool isShowName;

  ///数据
  final V2TimMessage message;

  @override
  State<IMMsgBaseWidget> createState() => IMMsgBaseWidgetState();
}

class IMMsgBaseWidgetState<T extends StatefulWidget>
    extends State<IMMsgBaseWidget> {
  final CustomPopupMenuController _menuController = CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {
    return AppColumn(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isShowTime()) _timeWidget(),
        isMe() ? _senderWidget() : _receiveWidget(),
        SizedBox(
          height: 15.h,
        )
      ],
    );
  }

  ///发送端
  _senderWidget() {
    return AppRow(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      width: double.infinity,
      mainAxisSize: MainAxisSize.min,
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      children: [
        AppColumn(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomPopupMenu(
              verticalMargin: 2.h,
              controller: _menuController,
              menuBuilder: _buildLongPressMenu,
              barrierColor: Colors.transparent,
              pressType: PressType.longPress,
              child: senderContent(),
            ),
            SizedBox(
              height: 6.h,
            ),
            Text(
              (widget.message.isPeerRead ?? false) ? "已读" : "未读",
              style: AppTheme().textStyle(
                  fontSize: 11.sp,
                  color: (widget.message.isPeerRead ?? false)
                      ? AppTheme.colorTextSecond
                      : AppTheme.colorRed),
            )
          ],
        ),
        SizedBox(
          width: 5.w,
        ),
        AppCircleNetImage(
          imageUrl: widget.message.faceUrl,
          size: 48.h,
        ),
      ],
    );
  }

  //子类处理
  senderContent() {
    return const SizedBox.shrink();
  }

  ///接收端
  _receiveWidget() {
    return AppRow(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      width: double.infinity,
      mainAxisSize: MainAxisSize.min,
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      children: [
        AppCircleNetImage(
          imageUrl: widget.message.faceUrl,
          size: 48.h,
        ),
        SizedBox(
          width: 5.w,
        ),
        CustomPopupMenu(
            menuBuilder: _buildLongPressMenu,
            controller: _menuController,
            barrierColor: Colors.transparent,
            pressType: PressType.longPress,
            child: receiveContent())
      ],
    );
  }

  //子类处理
  receiveContent() {
    return const SizedBox.shrink();
  }

  ///menu
  Widget _buildLongPressMenu() {
    return IMMsgBaseMenu(
      message: widget.message,
      isShowCopyMenu: _isShowCopyMenu(),
      onHideMenu: () {
        _menuController.hideMenu();
      }, logic: widget.logic,
    );
  }

  ///时间控件
  _timeWidget() {
    return SizedBox(
      height: 40.h,
      child: Center(
        child: Text(
          TimeUtils.ucTimeAgo((widget.message.timestamp ?? 0) * 1000),
          style: AppTheme().textStyle(
              fontSize: 12.sp, color: AppTheme.colorTextSecond),
        ),
      ),
    );
  }

  ///判断
  //时间判断
  _isShowTime() {
    if (widget.index < widget.logic.dataList.length - 1) {
      V2TimMessage before = widget.logic.dataList[widget.index + 1];
      DateTime timestamp1 = DateTime.fromMillisecondsSinceEpoch(
          (widget.message.timestamp ?? 0) * 1000);
      DateTime timestamp2 =
          DateTime.fromMillisecondsSinceEpoch((before.timestamp ?? 0) * 1000);
      Duration difference = timestamp1.difference(timestamp2);
      int seconds = difference.inSeconds;
      if (seconds >= 60 * 5) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  //是否是自己
  isMe() {
    return widget.message.sender ==
        FormatUtil.getImUserId(UserController.to.id.toString());
  }

  //是否具有长按事件
  _isShowCopyMenu() {
    if (widget.message.textElem != null) {
      return true;
    }
    return false;
  }
}
