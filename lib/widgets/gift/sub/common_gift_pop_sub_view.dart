import 'package:card_swiper/card_swiper.dart';

import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/gift.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'common_gift_pop_sub_logic.dart';

class CommonGiftPopSubPage extends StatefulWidget {
  const CommonGiftPopSubPage({Key? key, required this.tab, required this.onTap, required this.tabIndex})
      : super(key: key);
  final TabModel<List<Gift>> tab;
  final int tabIndex;
  final Function(Gift gift, int giftTypeId) onTap;

  @override
  State<CommonGiftPopSubPage> createState() => _CommonGiftPopSubPageState();
}

class _CommonGiftPopSubPageState extends State<CommonGiftPopSubPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late CommonGiftPopSubLogic logic =
      Get.find<CommonGiftPopSubLogic>(tag: widget.tab.id.toString());

  final SwiperController _swiperController = SwiperController();

  @override
  void initState() {
    super.initState();
    Get.put<CommonGiftPopSubLogic>(CommonGiftPopSubLogic(),
        tag: widget.tab.id.toString());
    logic.tabModel = widget.tab;
    logic.tabIndex = widget.tabIndex;
    logic.fetchGiftList((Gift dGift) {
      widget.onTap(dGift, logic.tabModel.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppPage<CommonGiftPopSubLogic>(
      tag: widget.tab.id.toString(),
      backgroundColor: Colors.transparent,
      childBuilder: (s) {
        return NotificationListener<ScrollNotification>(
          child: Swiper(
              loop: false,
              controller: _swiperController,
              pagination: logic.giftList.length > 1
                  ? SwiperPagination(
                      // 分页指示器
                      alignment: Alignment.bottomCenter,
                      // 位置 Alignment.bottomCenter 底部中间
                      margin: EdgeInsets.fromLTRB(0, 0.h, 0, 0),
                      // 距离调整
                      builder: DotSwiperPaginationBuilder(
                          // 指示器构建
                          space: 3.5.w,
                          // 点之间的间隔
                          size: 5.w,
                          // 没选中时的大小
                          activeSize: 5.w,
                          // 选中时的大小
                          color: Colors.grey,
                          // 没选中时的颜色
                          activeColor: AppTheme.colorTextWhite))
                  : null,
              outer: true,
              itemBuilder: (context, index) {
                return _giftSubList(
                  logic.giftList[index],
                );
              },
              itemCount: logic.giftList.length),
          onNotification: (ScrollNotification scrollNotification) {
            return handleNotification(scrollNotification);
          },
        );
      },
    );
  }

  Widget _giftSubList(List<Gift> list) {
    return GridView.builder(
        key: ValueKey(widget.tab.id),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 15.w, right: 15.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //水平子Widget之间间距
          crossAxisSpacing: 10.w,
          //垂直子Widget之间间距
          mainAxisSpacing: 4.h,
          //一行的Widget数量
          crossAxisCount: 4,
          //子Widget宽高比例
          childAspectRatio: 11 / 9.6,
        ),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          Gift gift = list[index];
          return GetBuilder<CommonGiftPopSubLogic>(
              tag: widget.tab.id.toString(),
              builder: (s) {
                return Obx(() => AppColumn(
                      mainAxisAlignment: MainAxisAlignment.center,
                      strokeWidth: 1.w,
                      radius: 8.w,
                      strokeColor: logic.selectedGiftId.value == gift.id
                          ? AppTheme.colorMain
                          : Colors.transparent,
                      onTap: () {
                        logic.selectedGiftId.value = gift.id ?? 0;
                        widget.onTap(gift, widget.tab.id);
                      },
                      children: [
                        AppNetImage(
                          width: double.infinity,
                          height: 33.h,
                          imageUrl: gift.image,
                          fit: BoxFit.contain,
                          defaultWidget: const SizedBox.shrink(),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          gift.name,
                          style: AppTheme().textStyle(
                              fontSize: 11.sp,
                              color: AppTheme.colorTextWhite),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Opacity(
                          opacity: 0.7,
                          child: Text(
                            "${gift.unitPrice}茶豆",
                            style: AppTheme().textStyle(
                                fontSize: 10.sp,
                                color: AppTheme.colorTextWhite),
                          ),
                        )
                      ],
                    ));
              });
        });
  }

  bool handleNotification(ScrollNotification notification) {
    return true;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    Get.delete<CommonGiftPopSubLogic>(tag: widget.tab.id.toString());
    super.dispose();
  }
}
