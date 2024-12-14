import 'package:youyu/modules/primary/message/message/list/widget/im_msg_red_widget.dart';
import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/widgets/app/app_loading.dart';
import 'package:youyu/widgets/other/expanded_viewport.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/primary/message/message/list/widget/im_msg_audio_widget.dart';
import 'package:youyu/modules/primary/message/message/list/widget/im_msg_gift_widget.dart';
import 'package:youyu/modules/primary/message/message/list/widget/im_msg_image_widget.dart';
import 'package:youyu/modules/primary/message/message/list/widget/im_msg_text_widget.dart';
import 'package:youyu/services/im/model/im_msg_type.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_round_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'message_chat_list_logic.dart';
import 'widget/im_msg_gif_widget.dart';

///聊天内容
class MessageChatListWidget extends StatefulWidget {
  const MessageChatListWidget(
      {super.key, required this.userId, this.tag, required this.nickName});

  final int userId;
  final String? tag;
  final String nickName;

  @override
  State<MessageChatListWidget> createState() => _MessageChatListWidgetState();
}

class _MessageChatListWidgetState extends State<MessageChatListWidget> {
  late MessageChatListLogic logic =
      Get.find<MessageChatListLogic>(tag: widget.tag);

  @override
  void initState() {
    super.initState();
    Get.put<MessageChatListLogic>(MessageChatListLogic(), tag: widget.tag);
    logic.userId = widget.userId;
    logic.nickName = widget.nickName;
    logic.getHistoryMsg(true);
  }

  @override
  Widget build(BuildContext context) {
    logic.context ??= context;
    return _content();
  }

  _content() {
    return AppStack(
      margin: EdgeInsets.symmetric(horizontal: 18.w),
      alignment: Alignment.topCenter,
      children: [
        Listener(
          onPointerMove: logic.onPointerMove,
          child: NotificationListener(
            child: ScrollConfiguration(
              behavior: const ScrollBehavior(),
              child: Scrollable(
                axisDirection: AxisDirection.up,
                physics: const BouncingScrollPhysics(),
                controller: logic.scrollController,
                viewportBuilder: (context, position) {
                  return ExpandedViewport(
                    offset: position,
                    axisDirection: AxisDirection.up,
                    slivers: [
                      SliverExpanded(),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (c, msgIndex) {
                            if (msgIndex == logic.dataList.length) {
                              return _topLoadMore();
                            }

                            V2TimMessage message = logic.dataList[msgIndex];
                            if (message.textElem != null) {
                              ///text
                              return IMMsgTextWidget(
                                key: UniqueKey(),
                                message: message,
                                index: msgIndex,
                                logic: logic,
                              );
                            } else if (message.imageElem != null) {
                              ///image
                              return IMMsgImageWidget(
                                key: UniqueKey(),
                                message: message,
                                index: msgIndex,
                                logic: logic,
                              );
                            } else if (message.soundElem != null) {
                              ///audio
                              return IMMsgAudioWidget(
                                key: UniqueKey(),
                                message: message,
                                index: msgIndex,
                                logic: logic,
                              );
                            } else if (message.customElem != null) {
                              if (message.customElem?.desc ==
                                  IMMsgType.gift.type) {
                                ///gift
                                return IMMsgGiftWidget(
                                  key: UniqueKey(),
                                  message: message,
                                  index: msgIndex,
                                  logic: logic,
                                );
                              } else if (message.customElem?.desc ==
                                  IMMsgType.gif.type) {
                                ///gift
                                return IMMsgGifWidget(
                                  key: ObjectKey(message.msgID ?? ""),
                                  message: message,
                                  index: msgIndex,
                                  logic: logic,
                                );
                              } else if (message.customElem?.desc ==
                                  IMMsgType.red.type) {
                                return IMMsgRedWidget(
                                  key: UniqueKey(),
                                  message: message,
                                  index: msgIndex,
                                  logic: logic,
                                );
                              }
                            }
                            return SizedBox(
                              height: 44.h,
                              child: Center(
                                child: Text(
                                  '未知消息',
                                  style: AppTheme().textStyle(
                                      fontSize: 14.sp,
                                      color: AppTheme.colorTextSecond),
                                ),
                              ),
                            );
                          },
                          childCount: logic.dataList.length + 1,
                          addAutomaticKeepAlives: true,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            onNotification: (ScrollNotification scrollNotification) {
              logic.onScrollViewDidScroll(scrollNotification);
              return true;
            },
          ),
        ),
        Positioned(
            bottom: 10.h,
            child: Obx(() => Opacity(
                  opacity: logic.isShowNewMsgTip.value ? 1 : 0,
                  child: AppRoundContainer(
                      alignment: Alignment.center,
                      onTap: () {
                        logic.hiddenTip();
                      },
                      padding: EdgeInsets.only(
                          left: 9.w, right: 9.w, top: 4.h, bottom: 4.h),
                      bgColor: const Color(0xFF4D6F40),
                      child: Text(
                        '有新消息',
                        style: AppTheme().textStyle(
                            fontSize: 14.sp, color: AppTheme.colorTextWhite),
                      )),
                ))),
        Obx(() => logic.isChatLoading.value
            ? const AppLoading(hasNavBar: false)
            : const SizedBox.shrink())
      ],
    );
  }

  _topLoadMore() {
    return SizedBox(
      height: 16.w,
      child: Center(
        child: !logic.isLoaded
            ? SizedBox(
                width: 10.w,
                height: 10.w,
                child: VisibilityDetector(
                    key: const Key("roomLoadmore"),
                    onVisibilityChanged: (VisibilityInfo info) {
                      if (info.visibleFraction > 0 && !logic.isLoading) {
                        logic.getHistoryMsg(false);
                      }
                    },
                    child: Obx(
                      () => logic.isShowMoreLoading.value
                          ? CircularProgressIndicator(
                              color: AppTheme.colorMain,
                              strokeWidth: 2.w,
                            )
                          : const SizedBox.shrink(),
                    )),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<MessageChatListLogic>(tag: widget.tag);
    super.dispose();
  }
}
