import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/widgets/user/user_info_widget.dart';
import 'package:youyu/widgets/user/user_tag_widget.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/live/common/message/live_message.dart';
import 'package:youyu/modules/live/common/message/sub/live_text_msg.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/material.dart';
import 'config/live_msg_widget_config.dart';
import 'package:youyu/utils/color_utils.dart';
///会话消息
class LiveMsgTextWidget extends StatelessWidget {
  const LiveMsgTextWidget(
      {super.key, required this.model, required this.onTap});

  final LiveMessageModel<LiveTextMsg> model;
  final Function(LiveMessageModel<LiveTextMsg> model) onTap;

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
          _nameTagWidget(),
          SizedBox(
            height: 5.h,
          ),
          _textWidget()
        ],
      ),
    );
  }

  ///用户信息
  _nameTagWidget() {
    return Container(
      constraints: BoxConstraints(
        minHeight: LiveMsgWidgetConfig.minHeight,
        maxWidth: LiveMsgWidgetConfig.maxWidth,
      ),
      child: RichText(
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          text: TextSpan(
            children: [
              //标签
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
                isHighFancyNum: (model.userInfo?.isHighFancyNum ?? false),
                name: model.userInfo?.nickname ?? "",
                nameFontSize: 13.sp,
              ))
            ],
          )),
    );
  }

  ///内容
  _textWidget() {
    Color textColor = const Color(0xFFFFFFFF);
    Color? levelColor = ColorUtils.string2Color(model.userInfo?.userVal?.levelColour);
    if (levelColor != null) {
      textColor = levelColor;
    }
    return Container(
        padding: LiveMsgWidgetConfig.padding,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(LiveMsgWidgetConfig.radius)),
          color: LiveMsgWidgetConfig.bgColor,
        ),
        constraints: BoxConstraints(
          minHeight: LiveMsgWidgetConfig.minHeight,
          maxWidth: LiveMsgWidgetConfig.maxWidth,
        ),
        child: Text(
          model.data?.text ?? "",
          maxLines: 99999,
          style: AppTheme().textStyle(fontSize: 12.sp, color: textColor),
        ));
  }
}
