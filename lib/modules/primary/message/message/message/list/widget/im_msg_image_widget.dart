import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/router/router.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'base/im_msg_base_widget.dart';

///图片item
class IMMsgImageWidget extends IMMsgBaseWidget {
  const IMMsgImageWidget(
      {super.key, required super.message, required super.index, required super.logic});

  @override
  _IMMsgImageWidgetState<IMMsgImageWidget> createState() =>
      _IMMsgImageWidgetState();
}

class _IMMsgImageWidgetState<T extends IMMsgImageWidget>
    extends IMMsgBaseWidgetState<IMMsgImageWidget> {
  @override
  senderContent() {
    return AppContainer(
      radius: 12.w,
      strokeWidth: 1.w,
      strokeColor: AppTheme.colorMain,
      child: _imageWidget(),
    );
  }

  @override
  receiveContent() {
    return AppContainer(
      radius: 12.w,
      strokeWidth: 1.w,
      strokeColor: AppTheme.colorTextWhite,
      child: _imageWidget(),
    );
  }

  _imageWidget() {
    String url = '';
    int width = 50.w.toInt();
    int height = 50.w.toInt();
    if (widget.message.imageElem != null &&
        widget.message.imageElem?.imageList?.isNotEmpty == true) {
      url = widget.message.imageElem!.imageList![0]!.url!;
      width = widget.message.imageElem!.imageList![0]!.width!;
      height = widget.message.imageElem!.imageList![0]!.height!;
    }
    if (width > IMMsgBaseWidget.itemMaxWidth) {
      height = height ~/ (width / IMMsgBaseWidget.itemMaxWidth);
      width = IMMsgBaseWidget.itemMaxWidth.toInt();
    }
    if (height > IMMsgBaseWidget.imageHeight) {
      width =
          width ~/ (height.toDouble() / IMMsgBaseWidget.imageHeight.toDouble());
      height = IMMsgBaseWidget.imageHeight.toInt();
    }
    return Hero(
        tag: "${widget.message.msgID ?? ''}-0",
        child: AppNetImage(
          onTap: () {
            Get.toNamed(AppRouter().otherPages.bigImageRoute.name,
                arguments: {
                  "index": 0,
                  "list": [url],
                  "itemTag": widget.message.msgID ?? '',
                });
          },
          imageUrl: url,
          radius: BorderRadius.circular(12.w),
          width: width.toDouble(),
          height: height.toDouble(),
        ));
  }
}
