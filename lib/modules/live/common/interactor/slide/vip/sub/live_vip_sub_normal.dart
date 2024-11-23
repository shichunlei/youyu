import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/live/common/message/sub/live_vip_msg.dart';
import 'package:flutter/material.dart';

import '../../../../message/live_message.dart';

class LiveVipSubNormal extends StatelessWidget {
  const LiveVipSubNormal({super.key, required this.model,});

  final LiveMessageModel<LiveVipMsg> model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 12.w, right: 12.w),
      margin: EdgeInsets.only(left: 27.w, right: 27.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(99.h),
          border: Border.all(
            width: 1.w,
            color: (model.data?.isSVip ?? false)
                ? const Color(0xFFFFAAA5)
                : const Color(0xFFFFA034),
          ),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.0, 1.0],
            colors: [Color(0xFF494949), Color(0xFF000000)],
          ),
          image: DecorationImage(
              image: AssetImage(AppResource().liveVipBg),
              fit: BoxFit.contain)),
      width: double.infinity,
      height: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "恭喜",
                  style: AppTheme().textStyle(fontSize: 14.sp, color: _textColor()),
                ),
                Flexible(
                  child: Text(
                    model.userInfo?.nickname ?? "",
                    style: AppTheme().textStyle(fontSize: 14.sp, color: _textColor()),
                  ),
                ),
                Text(
                  "开通${(model.data?.isSVip ?? false) ? "SVIP" : "VIP"}会员",
                  style: AppTheme().textStyle(fontSize: 14.sp, color: _textColor()),
                ),
              ],
            ),
          ),
          // AppLocalImage(
          //   path: model.data.isSVip
          //       ? AppResource().svip
          //       : AppResource().vip,
          //   width: 44.w,
          // )
        ],
      ),
    );
  }

  _textColor() {
    return (model.data?.isSVip ?? false)
        ? const Color(0xFFFE694B)
        : const Color(0xFFFFE8AE);
  }
}
