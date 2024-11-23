import 'dart:ui';

import 'package:get/get.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/models/gift.dart';
import 'package:youyu/modules/live/common/interactor/pop/gift/set/live_gift_logic.dart';
import 'package:youyu/modules/live/index/live_index_logic.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/material.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';

///酒吧设置礼物弹窗
class LivePopGift extends StatefulWidget {
  const LivePopGift({
    super.key,
  });

  @override
  State<LivePopGift> createState() => LivePopGiftState();
}

class LivePopGiftState extends State<LivePopGift>
    with SingleTickerProviderStateMixin {
  final logic = Get.put(LiveGiftLogic());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: AppColumn(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            width: double.infinity,
            padding: EdgeInsets.only(top: 10.h),
            color: const Color(0x99181818),
            topRightRadius: 12.w,
            topLeftRadius: 12.w,
            children: [
              Column(
                children: [
                  Text('选择专属才艺礼物',
                      style: AppTheme().textStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                      )),
                  SizedBox(
                    height: 30.h,
                  ),
                  _relationList(LiveGiftLogic.giftList)
                ],
              ),
              Padding(
                padding: EdgeInsets.all(20.h),
                child: AppColorButton(
                  title: '确定',
                  width: 326.w,
                  height: 56.h,
                  titleColor: AppTheme.colorTextWhite,
                  bgGradient: AppTheme().btnGradient,
                  // bgColor: Colors.transparent,
                  onClick: () {
                    LiveIndexLogic.to.operation
                        .onOperateBarGiftSet(logic.selectIndex.value);
                    print(logic.selectIndex.value);
                  },
                ),
              )
            ],
          )),
    );
  }

  Widget _relationList(List<Gift?> list) {
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 15.w, right: 15.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //水平子Widget之间间距
          crossAxisSpacing: 13.w,
          //垂直子Widget之间间距
          mainAxisSpacing: 13.h,
          //一行的Widget数量
          crossAxisCount: 3,
          //子Widget宽高比例
          childAspectRatio: 1 / 1,
        ),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          // RelationType gift = list[index];
          return Obx(() {
            bool isSelected = logic.selectIndex.value == list[index]!.id;

            return AppContainer(
              strokeColor: isSelected ? AppTheme.colorMain : Colors.transparent,
              strokeWidth: 1.w,
              // gradient: isSelected ? AppTheme().btnGradient : null,
              // width: 76.w,
              // height: 41.h,
              color: Colors.black.withOpacity(0.4),
              onTap: () {
                logic.selectIndex.value = list[index]!.id;
              },
              radius: 7.w,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 14.h),
                    child: AppNetImage(
                      width: double.infinity,
                      height: 33.h,
                      imageUrl: list[index]!.image,
                      fit: BoxFit.contain,
                      defaultWidget: const SizedBox.shrink(),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Center(
                      child: Text(list[index]!.name,
                          style: AppTheme().textStyle(
                              fontSize: 17.sp, color: Colors.white))),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppLocalImage(
                        path: AppResource().coin2,
                        width: 9.w,
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Text(
                        "${list[index]!.unitPrice}",
                        style: AppTheme().textStyle(
                            fontSize: 10.sp, color: AppTheme.colorTextWhite),
                      ),
                    ],
                  )
                ],
              ),
            );
          });
        });
  }
}
