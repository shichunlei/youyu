import 'dart:convert';

import 'package:gif/gif.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/services/im/im_service.dart';
import 'package:youyu/services/im/model/ext/im_gif_model.dart';
import 'package:youyu/services/im/model/im_custom_message_mdoel.dart';
import 'package:youyu/services/im/model/im_msg_type.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/material.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';

import 'base/im_msg_base_widget.dart';

class IMMsgGifWidget extends IMMsgBaseWidget {
  const IMMsgGifWidget(
      {super.key,
      required super.message,
      required super.index,
      required super.logic});

  @override
  _IMMsgGifWidgetState<IMMsgGifWidget> createState() => _IMMsgGifWidgetState();
}

class _IMMsgGifWidgetState<T extends IMMsgGifWidget>
    extends IMMsgBaseWidgetState<IMMsgGifWidget>
    with SingleTickerProviderStateMixin {
  IMGifModel? gifModel;
  double width = 80.w;
  double padding = 12.w;

  GifController? _gifController;

  @override
  void initState() {
    super.initState();
    gifModel = IMCustomMessageModel<IMGifModel>.fromJson(
            IMMsgType.getTypeByType(widget.message.customElem?.desc ?? ""),
            jsonDecode(widget.message.customElem!.data!))
        .data;
    _gifController = GifController(vsync: this);
    _gifController?.addListener(() {
      //第二个动画结束
      if (_gifController?.status == AnimationStatus.completed || _gifController?.status == AnimationStatus.dismissed) {
        widget.message.localCustomInt = 1;
        IMService().setLocalCustomIntRes(widget.message.msgID ?? "", 1);
      }
    });
  }

  @override
  senderContent() {
    return AppRow(
      width: width,
      height: width,
      padding: EdgeInsets.all(padding),
      gradient: AppTheme().btnGradient,
      topLeftRadius: 6.w,
      topRightRadius: 6.w,
      bottomLeftRadius: 6.w,
      mainAxisSize: MainAxisSize.min,
      children: [_gifImage()],
    );
  }

  @override
  receiveContent() {
    return AppRow(
      width: width,
      height: width,
      padding: EdgeInsets.all(padding),
      color: AppTheme.colorTextWhite,
      topLeftRadius: 6.w,
      topRightRadius: 6.w,
      bottomRightRadius: 6.w,
      mainAxisSize: MainAxisSize.min,
      children: [_gifImage()],
    );
  }

  _gifImage() {
    if (gifModel?.isShowEnd == true) {
      if (widget.message.localCustomInt == 1) {
        return Flexible(
            child: AppLocalImage(
          path:
              AppResource.getGif("${gifModel?.name ?? ""}-end", format: "png"),
        ));
      } else {
        return Flexible(
            child: Gif(
          controller: _gifController,
          image: AssetImage(AppResource.getGif(gifModel?.name ?? "")),
          // fps: 30,
          duration: const Duration(seconds: 3),
          autostart: Autostart.once,
        ));
      }
    } else {
      return Flexible(
          child: Gif(
        controller: _gifController,
        image: AssetImage(AppResource.getGif(gifModel?.name ?? "")),
        // fps: 30,
        // duration: const Duration(seconds: 3),
        autostart: Autostart.loop,
      ));
    }
  }

  @override
  void dispose() {
    _gifController?.dispose();
    _gifController = null;
    super.dispose();
  }
}
