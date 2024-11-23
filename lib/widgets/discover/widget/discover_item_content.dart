import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/widgets/discover/sub/discover_audio_url_widget.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/discover_item.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:flutter/material.dart';

import '../discover_item.dart';

class DisCoverItemContentWidget extends StatelessWidget {
  const DisCoverItemContentWidget(
      {super.key,
      required this.model,
      required this.index,
      required this.ref,
      this.onClickImage,
      required this.padding,
      required this.marginLR});

  final DiscoverItem? model;
  final int index;
  final DisCoverItemRef ref;
  final EdgeInsetsGeometry padding;
  final double marginLR;

  //点击图片
  final Function(DiscoverItem? model, int imageIndex, String itemTag)?
      onClickImage;

  @override
  Widget build(BuildContext context) {
    return AppColumn(
      width: double.infinity,
      crossAxisAlignment: CrossAxisAlignment.start,
      padding: padding,
      children: [
        if (model?.content?.isNotEmpty == true) _textWidget(),
        if (model?.content?.isNotEmpty == true &&
            model?.audio?.isNotEmpty == true)
          SizedBox(
            height: 10.h,
          ),
        ///语音
        if (model?.audio?.isNotEmpty == true)
          DiscoverAudioUrlWidget(model:model),
        if (model?.images?.isNotEmpty == true)
          SizedBox(
            height: 10.h,
          ),
        if (model?.images?.isNotEmpty == true) _imagesWidget(model?.images ?? [])
      ],
    );
  }

  ///文字
  _textWidget() {
    return Text(
      model?.content ?? "",
      maxLines: 1000,
      style: AppTheme().textStyle(fontSize: 12.sp, color: AppTheme.colorTextWhite),
    );
  }

  ///图片
  _imagesWidget(List<String> list) {
    if (list.length == 1) {
      return _heroImage(
        list,
        0,
        fit: BoxFit.contain,
        alignment: Alignment.topLeft,
        width: 250.w,
        height: 168.h,
        radius: BorderRadius.zero
      );
    } else {
      double itemWidth =
          ScreenUtils.screenWidth - padding.horizontal - marginLR * 2;
      double itemHeight = 214.h;
      double leftWidth = (itemWidth - 10.w) / 3 * 2;
      double rightWidth = (itemWidth - 10.w) / 3;
      double rightHeight = (itemHeight - 10.w) / 2;
      return AppRow(
        width: itemWidth,
        height: itemHeight,
        children: [
          _heroImage(list, 0, width: leftWidth, height: itemHeight,radius: BorderRadius.circular(10.w)),
          SizedBox(
            width: 10.w,
          ),
          AppColumn(
            children: [
              _heroImage(list, 1, width: rightWidth, height: rightHeight,radius: BorderRadius.circular(10.w)),
              SizedBox(
                height: 10.w,
              ),
              list.length > 2
                  ? _heroImage(list, 2, width: rightWidth, height: rightHeight,radius: BorderRadius.circular(10.w))
                  : const Expanded(child: SizedBox.shrink()),
            ],
          )
        ],
      );
    }
  }

  ///hero image
  _heroImage(List<String> list, int index,
      {double? width,
      double? height,
      BoxFit? fit,
      Alignment? alignment,
      required BorderRadius radius}) {
    String url = list[index];
    return Hero(
        tag: "$ref-${this.index}-$url-$index",
        child: AppNetImage(
          width: width,
          height: height,
          alignment: alignment,
          onTap: () {
            if (onClickImage != null) {
              onClickImage!(model, index, "$ref-${this.index}-$url");
            }
          },
          imageUrl: url,
          radius: radius,
          fit: fit ?? BoxFit.cover,
          defaultWidget: AppTheme().defaultNewImage(
              radius: 10.w, color: AppTheme.colorDarkLightBg),
        ));
  }
}
