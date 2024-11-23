import 'package:youyu/utils/screen_utils.dart';
import 'package:card_swiper/card_swiper.dart';

import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/submod/user/nobility/model/nobility_page_model.dart';
import 'package:youyu/modules/submod/user/nobility/nobility_logic.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:flutter/material.dart';

class NobilityBanner extends StatelessWidget {
  const NobilityBanner({super.key, required this.logic});

  final NobilityLogic logic;

  @override
  Widget build(BuildContext context) {
    double imageW = (ScreenUtils.screenWidth - 46.w * 2) * 1.15;
    double imageH = imageW.imgHeight(const Size(852, 491));
    return SizedBox(
      height: imageH,
      child: Swiper(
        scrollDirection: Axis.horizontal,
        // 横向
        itemCount: logic.tabs.length,
        autoplay: false,
        loop: false,
        viewportFraction: 0.8,
        scale: 0.9,
        controller: logic.tzController,
        onIndexChanged: (index) {
          logic.swiperTouchIndex(index);
        },
        // 自动翻页
        itemBuilder: (BuildContext context, int index) {
          TabModel<NobilityPageModel> model = logic.tabs[index];
          return Container(
            margin: EdgeInsets.only(left: 14.w, right: 14.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.w),
              child: AppStack(
                width: imageW,
                height: imageH,
                children: [
                  AppLocalImage(
                    path: AppResource().nobilityBg,
                    height: imageH,
                    width: imageW,
                  ),
                  _itemContent(model)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _itemContent(TabModel<NobilityPageModel> model) {
    String curText;
    if ((logic.curModel?.exp ?? 0) > 999) {
      curText = "${((logic.curModel?.exp ?? 0) / 1000).toStringAsFixed(1)}k";
    } else {
      curText = (logic.curModel?.exp ?? 0).toString();
    }
    return AppRow(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: AppColumn(
          padding: EdgeInsets.only(top: 32.h, left: 18.w),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.customExtra?.nobility.name ?? "",
              style: AppTheme().textStyle(
                  fontSize: 18.sp, color: const Color(0xFFFFDB86)),
            ),
            SizedBox(
              height: 25.h,
            ),
            //进度条
            _textOrProgress(model.customExtra),
          ],
        )),
        AppColumn(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppNetImage(
              imageUrl: model.customExtra?.nobility.img ?? "",
              width: 105.w,
            ),
            SizedBox(height: 4.h,),
            Text(
              '保级还需$curText',
              style: AppTheme().textStyle(
                  fontSize: 12.sp, color: AppTheme.colorTextSecond),
            ),
            SizedBox(height: 30.h,)
          ],
        )
      ],
    );
  }

  _textOrProgress(NobilityPageModel? model) {
    if ((logic.curModel?.exp ?? 0) < (model?.nobility.exp ?? 0)) {
      String needText;
      int diff = (model?.nobility.exp ?? 0) - (logic.curModel?.exp ?? 0);
      if (diff > 999) {
        needText = "${(diff / 1000).toStringAsFixed(1)}k";
      } else {
        needText = diff.toString();
      }
      return AppColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        margin: EdgeInsets.only(right: 28.w),
        children: [
          SizedBox(height: 8.h,child: ClipRRect(
            // 边界半径（`borderRadius`）属性，圆角的边界半径。
            borderRadius: BorderRadius.all(Radius.circular(10.h)),
            child: LinearProgressIndicator(
              value: (logic.curModel?.exp ?? 0) / (model?.nobility.exp ?? 0),
              backgroundColor: const Color(0xFF353536),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFFFDB86),
              ),
            ),
          ),),
          SizedBox(height: 6.h,),
          Text(
            '升级还需$needText',
            style: AppTheme().textStyle(
                fontSize: 12.sp, color: AppTheme.colorTextSecond),
          )
        ],
      );
    }
    return Text(
      '您已拥有更高等级的爵位',
      style: AppTheme().textStyle(fontSize: 13.sp, color: const Color(0xFFCECECE)),
    );
  }
}
