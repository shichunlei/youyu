import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/widgets/user/user_info_widget.dart';
import 'package:youyu/widgets/user/user_tag_widget.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/live/common/message/live_message.dart';
import 'package:youyu/modules/live/common/message/sub/live_join_msg.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/material.dart';
import 'config/live_msg_widget_config.dart';

///加入房间
class LiveMsgJoinWidget extends StatelessWidget {
  const LiveMsgJoinWidget(
      {super.key, required this.model, required this.onTap});

  final LiveMessageModel<LiveJoinMsg> model;
  final Function(LiveMessageModel<LiveJoinMsg> model) onTap;

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
                            tagList: model.userInfo?.userTagList ?? [])),
                    WidgetSpan(
                      child: SizedBox(
                        width: 4.w,
                      ),
                    ),
                    WidgetSpan(
                        child: UserInfoWidget(
                          viewType: UserInfoViewType.light,
                      isHighFancyNum: (model.userInfo?.isHighFancyNum ?? false),
                      name: model.userInfo?.nickname ?? "",
                      nameFontSize: 13.sp,
                    )),
                    WidgetSpan(
                      child: SizedBox(
                        width: 4.w,
                      ),
                    ),
                    TextSpan(
                      text: "加入房间",
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
