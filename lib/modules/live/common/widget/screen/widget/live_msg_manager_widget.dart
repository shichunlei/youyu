import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/widgets/user/user_info_widget.dart';
import 'package:youyu/widgets/user/user_tag_widget.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/live/common/message/live_message.dart';
import 'package:youyu/modules/live/common/message/sub/live_manager_msg.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/material.dart';
import 'config/live_msg_widget_config.dart';

///管理消息
class LiveMsgManagerWidget extends StatelessWidget {
  const LiveMsgManagerWidget(
      {super.key, required this.model, required this.onTap});

  final LiveMessageModel<LiveManagerMsg> model;
  final Function(LiveMessageModel<LiveManagerMsg> model) onTap;

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
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                text: TextSpan(
                  children: [
                    WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: UserTagWidget(
                            tagList: model.data?.userInfo?.userTagList ?? [])),
                    WidgetSpan(
                      child: SizedBox(
                        width: 4.w,
                      ),
                    ),
                    WidgetSpan(
                        child: UserInfoWidget(
                      isHighFancyNum: (model.data?.userInfo?.isHighFancyNum ?? false),
                      name: model.data?.userInfo?.nickname ?? "",
                      nameFontSize: 13.sp,
                    )),
                    WidgetSpan(
                      child: SizedBox(
                        width: 4.w,
                      ),
                    ),
                    TextSpan(
                      text: "成为管理员",
                      style: AppTheme().textStyle(
                          fontSize: 12.sp, color: AppTheme.colorMain),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
