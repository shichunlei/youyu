import 'package:youyu/utils/screen_utils.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'launch_logic.dart';

class LaunchPage extends StatelessWidget {
  LaunchPage({Key? key}) : super(key: key);

  final logic = Get.find<LaunchLogic>();

  final AssetImage image = AssetImage(AppResource().splash);

  @override
  Widget build(BuildContext context) {
    precacheImage(image, context);
    return Container(
      color: AppTheme.colorDarkBg,
      width: ScreenUtils.screenWidth,
      height: ScreenUtils.screenHeight,
      child: Image(
        image: image,
        fit: BoxFit.cover,
        gaplessPlayback: true,
        width: ScreenUtils.screenWidth,
        height: ScreenUtils.screenHeight,
      ),
    );
  }
}
