import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_round_container.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:flutter/material.dart';

import '../model/common_gift_pop_model.dart';

class CommonGiftUserItem extends StatelessWidget {
  const CommonGiftUserItem(
      {super.key,
      required this.isSelected,
      required this.model,
      this.width,
      this.height,
      required this.isSingleUser});

  final double? width;
  final double? height;
  final bool isSelected;
  final GiftUserPositionInfo? model;
  final bool isSingleUser;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          AppCircleNetImage(
            borderColor:
                isSelected ? AppTheme.colorMain : Colors.transparent,
            imageUrl: model?.user.avatar,
            size: 32.w,
            borderWidth: 1.w,
          ),
          if (!isSingleUser)
            Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: AppRoundContainer(
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.center,
                  bgColor: isSelected
                      ? AppTheme.colorMain
                      : const Color(0xFFD8D8D8),
                  child: Text(
                    (model?.position == 0) ? "主持" : "${model?.position}",
                    style: AppTheme().textStyle(
                        fontSize: 8.sp, color: const Color(0xFF000000)),
                  )),
            )
        ],
      ),
    );
  }
}
