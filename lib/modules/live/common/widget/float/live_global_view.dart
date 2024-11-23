import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:youyu/services/trtc/trtc_service.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:im_animations/im_animations.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LiveGlobalView extends StatefulWidget {
  const LiveGlobalView({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  State<LiveGlobalView> createState() => _LiveGlobalViewState();
}

class _LiveGlobalViewState extends State<LiveGlobalView> {
  double defaultCapsuleX = 5;
  double defaultTopOffset = 300;

  double? l;
  double? r;
  double y = 20;

  double get minTop {
    return MediaQuery.of(context).padding.top;
  }

  double get maxTop {
    return 1 * ScreenUtils.screenHeight -
        MediaQuery.of(context).padding.bottom -
        90.w;
  }

  bool isMoving = false;

  @override
  void initState() {
    l = defaultCapsuleX;
    y = defaultTopOffset;
    setState(() {});
    super.initState();
  }

  onDragEnd(DraggableDetails detail) {
    isMoving = false;
    if (detail.offset.dx > (0.5.sw - 75.w)) {
      r = defaultCapsuleX;
      l = null;
    } else {
      l = defaultCapsuleX;
      r = null;
    }
    if (detail.offset.dy < minTop) {
      y = minTop;
    } else if (detail.offset.dy > maxTop) {
      y = maxTop;
    } else {
      y = detail.offset.dy;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          widget.child,
          Obx(() {
            Widget card = buildCard(context);
            return LiveService().isShowGlobalCard.value
                ? Positioned(
                    top: y,
                    left: l,
                    right: r,
                    child: Draggable(
                      onDragEnd: onDragEnd,
                      // onDragUpdate: (_)=>setState(() {isMoving = true;}),
                      onDragStarted: () => setState(() {
                        isMoving = true;
                      }),
                      feedback: card,
                      child: GestureDetector(
                        onTap: () {
                          LiveService().pushToLive(
                              TRTCService().currentRoomInfo.value?.id,
                              TRTCService().currentRoomInfo.value?.groupId);
                        },
                        child: !isMoving ? card : const SizedBox(),
                      ),
                    ),
                  )
                : const SizedBox();
          })
        ],
      ),
    );
  }

  Container buildCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 5),
      decoration: BoxDecoration(
        gradient: AppTheme().btnGradient,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              offset: const Offset(-2, 2),
              blurRadius: 5,
              color: Colors.black.withOpacity(0.5))
        ],
      ),
      height: 40.w,
      child: Row(
        children: [
          SizedBox(
            width: 30.w,
            child: Rotate(
              rotationsPerMinute: 30,
              repeat: true,
              child: TRTCService().currentRoomInfo.value?.avatar?.isNotEmpty ==
                      true
                  ? AppCircleNetImage(
                      imageUrl:
                          TRTCService().currentRoomInfo.value?.avatar ?? "",
                      size: 30.w,
                      defaultWidget: const SizedBox.shrink(),
                    )
                  : const SizedBox(),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          SizedBox(
            height: 16.w,
            child: const LoadingIndicator(
              indicatorType: Indicator.audioEqualizer,
              colors: [Colors.white],
              strokeWidth: 2.0,
              pathBackgroundColor: null,
            ),
          ),
          IconButton(
            onPressed: () async {
              //下麦
              // if (TRTCService().currentSeatState != null) {
              //   await TRTCService().sendOnWheatChange(
              //       position: TRTCService().currentSeatState!.position);
              // }
              LiveService().isShowGlobalCard.value = false;
              TRTCService().leaveRoom();
            },
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
