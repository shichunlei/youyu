import 'package:gif/gif.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';

import 'package:youyu/widgets/user/user_info_widget.dart';
import 'package:youyu/widgets/user/user_tag_widget.dart';
import 'package:youyu/modules/live/common/message/live_message.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/material.dart';
import '../../../message/sub/live_gif_msg.dart';
import 'config/live_msg_widget_config.dart';

///gif消息
class LiveMsgGifWidget extends StatefulWidget {
  const LiveMsgGifWidget({super.key, required this.model, required this.onTap});

  final LiveMessageModel<LiveGifMsg> model;
  final Function(LiveMessageModel<LiveGifMsg> model) onTap;

  @override
  State<LiveMsgGifWidget> createState() => _LiveMsgGifWidgetState();
}

class _LiveMsgGifWidgetState extends State<LiveMsgGifWidget>
    with SingleTickerProviderStateMixin {
  GifController? _gifController;

  @override
  void initState() {
    super.initState();
    _gifController = GifController(vsync: this);
    _gifController?.addListener(() {
      //第二个动画结束
      if (_gifController?.status == AnimationStatus.completed ||
          _gifController?.status == AnimationStatus.dismissed) {
        widget.model.data?.localCustomInt = 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      onTap: () {
        widget.onTap(widget.model);
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
                      tagList: widget.model.userInfo?.userTagList ?? [])),
              WidgetSpan(
                child: SizedBox(
                  width: 4.w,
                ),
              ),
              WidgetSpan(
                  child: UserInfoWidget(
                isHighFancyNum:
                    (widget.model.userInfo?.isHighFancyNum ?? false),
                name: widget.model.userInfo?.nickname ?? "",
                nameFontSize: 13.sp,
              ))
            ],
          )),
    );
  }

  ///内容
  _textWidget() {
    return Container(
        width: 80.w,
        height: 80.w,
        padding: LiveMsgWidgetConfig.padding,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(LiveMsgWidgetConfig.radius)),
          color: LiveMsgWidgetConfig.bgColor,
        ),
        child: _gifImage());
  }

  _gifImage() {
    if (widget.model.data?.isShowEnd == true) {
      if (widget.model.data?.localCustomInt == 1) {
        return AppLocalImage(
            path: AppResource.getGif("${widget.model.data?.name ?? ""}-end",
                format: "png"));
      } else {
        return Gif(
          controller: _gifController,
          image: AssetImage(AppResource.getGif(widget.model.data?.name ?? "")),
          // fps: 30,
          duration: const Duration(seconds: 3),
          autostart: Autostart.once,
        );
      }
    } else {
      return Gif(
        controller: _gifController,
        image: AssetImage(AppResource.getGif(widget.model.data?.name ?? "")),
        // fps: 30,
        // duration: const Duration(seconds: 3),
        autostart: Autostart.loop,
      );
    }
  }

  @override
  void dispose() {
    _gifController?.dispose();
    _gifController = null;
    super.dispose();
  }
}
