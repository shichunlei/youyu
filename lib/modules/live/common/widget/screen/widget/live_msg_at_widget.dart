import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/widgets/user/user_info_widget.dart';
import 'package:youyu/widgets/user/user_tag_widget.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/modules/live/common/message/live_message.dart';
import 'package:youyu/modules/live/common/message/sub/live_group_at_msg.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/material.dart';
import 'config/live_msg_widget_config.dart';

///at会话消息
class LiveMsgAtWidget extends StatelessWidget {
  const LiveMsgAtWidget({super.key, required this.model, required this.onTap});

  final LiveMessageModel<LiveGroupAtMsg> model;
  final Function(LiveMessageModel<LiveGroupAtMsg> model) onTap;

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
      child: RichText(maxLines: 99999, text: TextSpan(children: buildTexts())),
    );
  }

  List<TextSpan> buildTexts() {
    List<TextSpan> list = [];
    List<UserInfo> userList = model.data?.atUsers ?? [];
    for (int i = 0; i < userList.length; i++) {
      UserInfo userInfo = userList[i];
      list.add(
        TextSpan(
          style: AppTheme().textStyle(color: AppTheme.colorMain, fontSize: 15),
          text: "@${userInfo.nickname}",
        ),
      );
    }
    list.add(
      TextSpan(
          style: AppTheme().textStyle(fontSize: 12.sp, color: const Color(0xFFBD17AF)),
          text: "  ${model.data?.text ?? ""}"),
    );

    return list;
  }
}
