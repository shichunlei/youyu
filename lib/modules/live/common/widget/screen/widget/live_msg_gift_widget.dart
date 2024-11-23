import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/modules/live/common/message/live_message.dart';
import 'package:youyu/modules/live/common/message/sub/live_gift_msg.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:flutter/material.dart';
import 'config/live_msg_widget_config.dart';

///礼物
class LiveMsgGiftWidget extends StatelessWidget {
  const LiveMsgGiftWidget(
      {super.key,
      required this.model,
      required this.onTap,
      required this.onTapUser});

  final LiveMessageModel<LiveGiftMsg> model;
  final Function(LiveMessageModel<LiveGiftMsg> model) onTap;
  final Function(UserInfo userInfo) onTapUser;

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
                padding: LiveMsgWidgetConfig.padding,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(LiveMsgWidgetConfig.radius)),
                  color: LiveMsgWidgetConfig.bgColor,
                ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Text(
                          model.data?.sender?.nickname ?? "",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppTheme.colorTextWhite,
                          ),
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: SizedBox(width: 4.w),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Text(
                          '送给',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppTheme.colorMain,
                          ),
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: SizedBox(width: 4.w),
                      ),
                      ...buildNames(),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: SizedBox(width: 4.w),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Text(
                          '${model.data?.gift?.name}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppTheme.colorTextWhite,
                          ),
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: SizedBox(
                          width: 15.w,
                          child: Center(
                            child: AppNetImage(
                              imageUrl: model.data?.gift?.image,
                              width: 15.w,
                              defaultWidget: const SizedBox.shrink(),
                            ),
                          ),
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: SizedBox(width: 4.w),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Text(
                          'x${model.data?.gift?.count}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppTheme.colorTextWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ));
  }

  List<InlineSpan> buildNames() {
    List<InlineSpan> list = [];
    list.add(
      // WidgetSpan(
      //   alignment: PlaceholderAlignment.middle,
      //   child: AppGradientText(
      //     model.data?.receiver?.nickname ?? "",
      //     textAlign: TextAlign.left,
      //     gradient: AppTheme().lhGradient,
      //     style: AppTheme().textStyle(fontSize: 11.5.sp),
      //   ),
      // ),
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: AppContainer(
          onTap: () {
            if (model.data?.receiver != null) {
              onTapUser(model.data!.receiver!);
            }
          },
          child: Text(
            model.data?.receiver?.nickname ?? "",
            textAlign: TextAlign.left,
            style: AppTheme()
                .textStyle(fontSize: 11.5.sp, color: AppTheme.colorTextWhite),
          ),
        ),
      ),
    );
    return list;
  }
}
