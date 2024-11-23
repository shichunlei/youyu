import 'dart:async';
import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/modules/live/common/message/live_message.dart';
import 'package:youyu/modules/live/common/message/sub/live_announcement_msg.dart';
import 'package:youyu/modules/live/common/message/sub/live_gift_msg.dart';
import 'package:youyu/modules/live/common/message/sub/live_group_at_msg.dart';
import 'package:youyu/modules/live/common/message/sub/live_join_msg.dart';
import 'package:youyu/modules/live/common/message/sub/live_leave_msg.dart';
import 'package:youyu/modules/live/common/message/sub/live_manager_msg.dart';
import 'package:youyu/modules/live/common/message/sub/live_text_msg.dart';
import 'package:youyu/modules/live/common/widget/screen/widget/live_msg_announcement_widget.dart';
import 'package:youyu/modules/live/common/widget/screen/widget/live_msg_at_widget.dart';
import 'package:youyu/modules/live/common/widget/screen/widget/live_msg_gift_luck_widget.dart';
import 'package:youyu/modules/live/common/widget/screen/widget/live_msg_gift_widget.dart';
import 'package:youyu/modules/live/common/widget/screen/widget/live_msg_join_widget.dart';
import 'package:youyu/modules/live/common/widget/screen/widget/live_msg_leave_widget.dart';
import 'package:youyu/modules/live/common/widget/screen/widget/live_msg_manager_widget.dart';
import 'package:youyu/modules/live/common/widget/screen/widget/live_msg_text_widget.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:youyu/services/trtc/trtc_service.dart';
import 'package:youyu/widgets/app/app_round_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'live_screen_list_logic.dart';

class LiveScreenListPage extends StatefulWidget {
  const LiveScreenListPage(
      {Key? key,
      required this.tabModel,
      required this.onClickItem,
      required this.pageTag,
      required this.onClickUser})
      : super(key: key);
  final TabModel tabModel;
  final String pageTag;
  final Function(LiveMessageModel model) onClickItem;
  final Function(UserInfo userInfo) onClickUser;

  @override
  State<LiveScreenListPage> createState() => LiveScreenListPageState();
}

class LiveScreenListPageState extends State<LiveScreenListPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late LiveScreenListLogic logic = Get.find<LiveScreenListLogic>(
      tag: widget.tabModel.id.toString() + widget.pageTag);

  Animation? stopTween;

  @override
  void initState() {
    super.initState();
    setState(() {});
    Future.delayed(const Duration(milliseconds: 50), () {
      if (logic.scrollController.hasClients) {
        logic.scrollController
            .jumpTo(logic.scrollController.position.maxScrollExtent);
      }
    });
    logic.onScrollUpdate = _onScrollUpdate();

    ///遮罩动画
    logic.maskController = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this)
      ..addListener(() {
        setState(() {});
      });

    stopTween = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: logic.maskController!,
      curve: Curves.easeIn,
    ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    logic.context ??= context;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Listener(
          onPointerMove: logic.onPointerMove,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 18.w),
            child: NotificationListener(
              child: ScrollConfiguration(
                  behavior: const ScrollBehavior(),
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      if (logic.maskType == LiveScreenMaskType.normal) {
                        return _normalShader(bounds);
                      } else {
                        return _moreShader(bounds);
                      }
                    },
                    blendMode: BlendMode.dstIn,
                    child: Scrollable(
                      physics: const BouncingScrollPhysics(),
                      controller: logic.scrollController,
                      viewportBuilder: (context, position) {
                        int count = 0;

                        ///消息item加载
                        switch (widget.tabModel.id) {
                          case 0:
                            count = TRTCService().allScreenList.length;
                            break;
                          case 1:
                            count = TRTCService().chatScreenList.length;
                            break;
                          case 2:
                            count = TRTCService().giftScreenList.length;
                            break;
                        }
                        return Viewport(
                          offset: position,
                          axisDirection: AxisDirection.down,
                          slivers: [
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (c, msgIndex) {
                                  LiveMessageModel? model;

                                  ///消息item加载
                                  switch (widget.tabModel.id) {
                                    case 0:
                                      model =
                                          TRTCService().allScreenList[msgIndex];
                                      break;
                                    case 1:
                                      model = TRTCService()
                                          .chatScreenList[msgIndex];
                                      break;
                                    case 2:
                                      model = TRTCService()
                                          .giftScreenList[msgIndex];
                                      break;
                                  }
                                  switch (model?.type ?? LiveMessageType.text) {
                                    case LiveMessageType.topSpace:
                                      //用来占位
                                      return SizedBox(
                                        height: 14.h,
                                      );
                                    case LiveMessageType.announcement:
                                      return LiveMsgAnnouncementWidget(
                                        key: UniqueKey(),
                                        model: model as LiveMessageModel<
                                            LiveAnnounceMentMsg>,
                                        onTap: widget.onClickItem,
                                      );
                                    case LiveMessageType.text:
                                      return LiveMsgTextWidget(
                                        key: UniqueKey(),
                                        model: model
                                            as LiveMessageModel<LiveTextMsg>,
                                        onTap: widget.onClickItem,
                                      );
                                    case LiveMessageType.groupAt:
                                      return LiveMsgAtWidget(
                                        key: UniqueKey(),
                                        model: model
                                            as LiveMessageModel<LiveGroupAtMsg>,
                                        onTap: widget.onClickItem,
                                      );
                                    case LiveMessageType.join:
                                      return LiveMsgJoinWidget(
                                        key: UniqueKey(),
                                        model: model
                                            as LiveMessageModel<LiveJoinMsg>,
                                        onTap: widget.onClickItem,
                                      );
                                    case LiveMessageType.leave:
                                      return LiveMsgLeaveWidget(
                                        key: UniqueKey(),
                                        model: model
                                            as LiveMessageModel<LiveLeaveMsg>,
                                        onTap: widget.onClickItem,
                                      );
                                    case LiveMessageType.gift:
                                      return LiveMsgGiftWidget(
                                        key: UniqueKey(),
                                        model: model
                                            as LiveMessageModel<LiveGiftMsg>,
                                        onTap: widget.onClickItem,
                                        onTapUser: (UserInfo userInfo) {
                                          widget.onClickUser(userInfo);
                                        },
                                      );
                                    case LiveMessageType.luckGift:
                                      return LiveMsgLuckGiftWidget(
                                        key: UniqueKey(),
                                        model: model
                                            as LiveMessageModel<LiveGiftMsg>,
                                        onTap: widget.onClickItem,
                                      );
                                    case LiveMessageType.manager:
                                      return LiveMsgManagerWidget(
                                        key: UniqueKey(),
                                        model: model
                                            as LiveMessageModel<LiveManagerMsg>,
                                        onTap: widget.onClickItem,
                                      );
                                    default:
                                      return Container();
                                  }
                                },
                                childCount: count,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )),
              onNotification: (ScrollNotification scrollNotification) {
                logic.onScrollViewDidScroll(scrollNotification);
                return true;
              },
            ),
          ),
        ),
        Positioned(
            bottom: 10.h,
            child: Obx(() => Opacity(
                  opacity: logic.isShowNewMsgTip.value ? 1 : 0,
                  child: AppRoundContainer(
                      alignment: Alignment.center,
                      onTap: () {
                        if (logic.isShowNewMsgTip.value) {
                          logic.isShowNewMsgTip.value = false;
                          logic.scrollController.jumpTo(
                              logic.scrollController.position.maxScrollExtent);
                        }
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
      ],
    );
  }

  _onScrollUpdate() {}

  _normalShader(bounds) {
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromRGBO(0, 0, 0, 0),
        Color.fromRGBO(0, 0, 0, 1),
      ],
    ).createShader(Rect.fromLTRB(0, 0, bounds.width, 18.h));
  }

  _moreShader(bounds) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: const [
        Color.fromRGBO(0, 0, 0, 0),
        Color.fromRGBO(0, 0, 0, 0.05),
        Color.fromRGBO(0, 0, 0, 0.05),
        Color.fromRGBO(0, 0, 0, 1),
      ],
      stops: [
        (stopTween?.value ?? 0) * 0.2,
        (stopTween?.value ?? 0) * 0.5,
        (stopTween?.value ?? 0) * 0.7,
        (stopTween?.value ?? 0) * 1.0
      ],
    ).createShader(Rect.fromLTRB(0, 0, bounds.width, _maskHeight()));
  }

  _maskHeight() {
    switch (logic.maskType) {
      case LiveScreenMaskType.short:
        return 70.h;
      case LiveScreenMaskType.middle:
        return 70.h + (stopTween?.value ?? 0) * (85 - 70).h;
      case LiveScreenMaskType.long:
        return 80.h + (stopTween?.value ?? 0) * (140 - 80).h;
      case LiveScreenMaskType.normal:
        return 0.h;
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    logic.maskController?.dispose();
    super.dispose();
  }
}
