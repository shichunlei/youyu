import 'dart:io';

import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/widgets/svga/simple_player_repeat.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:flutter/material.dart';

class LiveBgWidget extends StatefulWidget {
  const LiveBgWidget({super.key});

  @override
  State<LiveBgWidget> createState() => LiveBgWidgetState();
}

class LiveBgWidgetState extends State<LiveBgWidget> {
  LiveBackGroundType type = LiveBackGroundType.none;
  String? imageUrl;
  File? svgFile;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case LiveBackGroundType.image:
        return AppNetImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          fadeInDuration:  const Duration(milliseconds: 100),
          width: ScreenUtils.screenWidth,
          height: ScreenUtils.screenHeight,
          defaultWidget: _defaultBg(),
          errorWidget: _defaultBg(),
        );
      case LiveBackGroundType.svg:
        return SVGASimpleImageRepeat(
          file: svgFile,
        );
      default:
        return _defaultBg();
    }
  }

  //图片或者svg
  updateBackGround(LiveBackGroundType type, {String? imageUrl, File? svgFile}) {
    setState(() {
      this.type = type;
      if (type == LiveBackGroundType.image) {
        this.imageUrl = imageUrl;
      } else if (type == LiveBackGroundType.svg) {
        this.svgFile = svgFile;
      }
    });
  }

  _defaultBg() {
    return AppLocalImage(
      path: AppResource().liveDBg,
      fit: BoxFit.cover,
      width: ScreenUtils.screenWidth,
      height: ScreenUtils.screenHeight,
    );
  }
}
