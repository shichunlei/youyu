import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/user/user_info_widget.dart';
import 'package:youyu/widgets/user/user_tag_widget.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/gift.dart';
import 'package:youyu/modules/live/common/message/sub/live_gift_msg.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:flutter/material.dart';
import '../../../message/live_message.dart';
import 'config/live_msg_widget_config.dart';

///福袋礼物
class LiveMsgLuckGiftWidget extends StatelessWidget {
  const LiveMsgLuckGiftWidget(
      {super.key, required this.model, required this.onTap});

  final LiveMessageModel<LiveGiftMsg> model;
  final Function(LiveMessageModel<LiveGiftMsg> model) onTap;

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
          // _nameTagWidget(),
          // SizedBox(
          //   height: 5.h,
          // ),
          _giftWidget()
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

  _giftWidget() {
    return Container(
        constraints: BoxConstraints(
          minHeight: LiveMsgWidgetConfig.minHeight,
          maxWidth: LiveMsgWidgetConfig.maxWidth,
        ),
        padding: LiveMsgWidgetConfig.padding,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(LiveMsgWidgetConfig.radius)),
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
              TextSpan(
                text: "送给 ",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppTheme.colorMain,
                ),
              ),
              TextSpan(
                text: model.data?.receiver?.nickname,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppTheme.colorTextWhite,
                ),
              ),
              WidgetSpan(
                child: SizedBox(width: 8.w),
              ),
              // WidgetSpan(
              //   alignment: PlaceholderAlignment.middle,
              //   child: AppNetImage(
              //     fit: BoxFit.fitHeight,
              //     imageUrl: model.data?.gift?.image,
              //     width: 15.w,
              //   ),
              // ),
              // WidgetSpan(
              //   alignment: PlaceholderAlignment.middle,
              //   child: SizedBox(width: 4.w),
              // ),
              // TextSpan(
              //   text: 'x${model.data?.gift?.count ?? 0}.获得',
              //   style: TextStyle(
              //     fontSize: 12.sp,
              //     color: const Color(0xFF9E9E9E),
              //   ),
              // ),
              ...buildGifts(),
            ],
          ),
        ));
  }

  List<InlineSpan> buildGifts() {
    List<InlineSpan> list = [];
    List<Gift> giftList = model.data?.gift?.childList ?? [];
    for (int i = 0; i < giftList.length; i++) {
      Gift gift = giftList[i];
      list.add(
        // ${gift.name}(${gift.unitPrice})
        TextSpan(
          text: " ${gift.count ?? 0}个",
          style: TextStyle(
            fontSize: 12.sp,
            color: AppTheme.colorMain,
          ),
        ),
      );
      list.add(
        // ${gift.name}(${gift.unitPrice})
        TextSpan(
          text: gift.name,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.white,
          ),
        ),
      );
      list.add(
        TextSpan(
          text: "(${gift.unitPrice})",
          style: TextStyle(
            fontSize: 12.sp,
            color: AppTheme.colorMain,
          ),
        ),
      );
      list.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: AppNetImage(
            fit: BoxFit.fitHeight,
            imageUrl: gift.image,
            width: 15.w,
          ),
        ),
      );

      if (i < giftList.length - 1) {
        list.add(
          TextSpan(
            text: "，",
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF9E9E9E),
            ),
          ),
        );
      }
    }

    return list;
  }
}
