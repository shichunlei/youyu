import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/live/common/message/live_message.dart';
import 'package:youyu/modules/live/common/message/sub/live_announcement_msg.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/material.dart';
import 'config/live_msg_widget_config.dart';
///进入欢迎语
class LiveMsgAnnouncementWidget extends StatelessWidget {
  const LiveMsgAnnouncementWidget({super.key, required this.model, required this.onTap});

  final LiveMessageModel<LiveAnnounceMentMsg> model;
  final Function(LiveMessageModel<LiveAnnounceMentMsg>model)onTap;

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
              padding: LiveMsgWidgetConfig.padding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.circular(LiveMsgWidgetConfig.radius)),
                color: LiveMsgWidgetConfig.bgColor,
              ),
              constraints: BoxConstraints(
                minHeight: LiveMsgWidgetConfig.minHeight,
                maxWidth: LiveMsgWidgetConfig.maxWidth,
              ),
              child: Text(
                model.data?.text ?? "",
                maxLines: 99999,
                style: AppTheme().textStyle(
                    fontSize: 12.sp, color: const Color(0xFFC6E958)),
              ))
        ],
      ),
    );
  }
}
