import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/live/common/message/sub/live_leave_msg.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/material.dart';
import '../../../message/live_message.dart';
import 'config/live_msg_widget_config.dart';

///离开房间
class LiveMsgLeaveWidget extends StatelessWidget {
  const LiveMsgLeaveWidget(
      {super.key, required this.model, required this.onTap});

  final LiveMessageModel<LiveLeaveMsg> model;
  final Function(LiveMessageModel<LiveLeaveMsg> model) onTap;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      onTap: () {
        onTap(model);
      },
      margin: EdgeInsets.only(bottom: LiveMsgWidgetConfig.marginBottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              minHeight: LiveMsgWidgetConfig.minHeight,
              maxWidth: LiveMsgWidgetConfig.maxWidth,
            ),
            child: RichText(
                text: TextSpan(
              text: model.userInfo?.nickname,
              style: AppTheme().textStyle(
                  color: AppTheme.colorTextWhite, fontSize: 12.sp),
              children: <TextSpan>[
                TextSpan(
                    style: AppTheme().textStyle(
                        color: const Color(0xFF767676), fontSize: 12.sp),
                    text: "  离开房间"),
              ],
            )),
          )
        ],
      ),
    );
  }
}
