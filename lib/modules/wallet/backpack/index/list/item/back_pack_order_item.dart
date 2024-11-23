import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/wallet/backpack/index/list/model/back_pack_order_model.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:flutter/material.dart';

class BackPackOrderItem extends StatelessWidget {
  const BackPackOrderItem({super.key, required this.model});

  final BackPackOrderModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15.w, right: 15.w),
      child: Column(
        children: [
          SizedBox(
            height: 15.h,
          ),
          SizedBox(
            height: 55.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 10, child: _left()),
                AppNetImage(
                  imageUrl: model.image,
                  width: 46.w,
                  height: 46.w,
                )
              ],
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          Container(
            color: AppTheme.colorLine,
            height: 0.5.h,
          )
        ],
      ),
    );
  }

  _left() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              model.title ?? "",
              style: TextStyle(fontSize: 16.sp, color: Colors.white),
            ),
            if (model.exTitle != null)
              Expanded(
                  child: ShaderMask(
                shaderCallback: (rect) {
                  return const LinearGradient(
                    colors: [Color(0xFFFF7676), Color(0xFFFCCA1A)],
                  ).createShader(rect);
                },
                child: Text(
                  model.exTitle ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold),
                ),
              ))
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          model.time ?? "",
          style: AppTheme().textStyle(
              fontSize: 12.sp, color: AppTheme.colorTextSecond),
        )
      ],
    );
  }
}
