import 'package:youyu/config/resource.dart';
import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/models/localmodel/item_title_model.dart';
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/shop_item.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:youyu/widgets/app/list/app_grid_separated_view.dart';
import 'package:youyu/widgets/app/other/app_load_footer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'shop_sub_list_logic.dart';

class ShopSubListPage extends StatefulWidget {
  const ShopSubListPage(
      {Key? key,
      required this.tabModel,
      required this.curItem,
      required this.onRefreshTop})
      : super(key: key);
  final TabModel tabModel;
  final Rx<ShopItem?> curItem;
  final Function onRefreshTop;

  @override
  State<ShopSubListPage> createState() => _ShopSubListPageState();
}

class _ShopSubListPageState extends State<ShopSubListPage>
    with AutomaticKeepAliveClientMixin {
  late ShopSubListLogic logic =
      Get.find<ShopSubListLogic>(tag: widget.tabModel.id.toString());

  @override
  void initState() {
    super.initState();
    Get.put<ShopSubListLogic>(ShopSubListLogic(),
        tag: widget.tabModel.id.toString());
    logic.curItem = widget.curItem;
    logic.tabModel = widget.tabModel;
    logic.subRefreshController = RefreshController();
    logic.fetchList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppPage<ShopSubListLogic>(
      tag: widget.tabModel.id.toString(),
      childBuilder: (s) {
        return Obx(() => AppColumn(
              children: [
                AppContainer(
                  width: double.infinity,
                  height: 7.h,
                  color: AppTheme.colorDarkBg,
                ),
                _top(),
                AppContainer(
                  width: double.infinity,
                  height: 10.h,
                  color: AppTheme.colorDarkBg,
                ),
                Expanded(child: _list()),
                logic.curItem.value != null ? _bottom() : Container()
              ],
            ));
      },
    );
  }

  ///顶部
  _top() {
    return AppContainer(
        padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 7.h),
        color: AppTheme.colorDarkBg,
        alignment: Alignment.centerLeft,
        height: (26 + 7 * 2).h,
        child: ListView.separated(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              ItemTitleModel model = logic.classifyList[index];
              return AppContainer(
                onTap: () {
                  logic.onClickClassify(model);
                },
                alignment: Alignment.center,
                radius: 99.w,
                color: model == logic.curClassify
                    ? const Color(0xFFEBE2FF)
                    : AppTheme.colorTextWhite,
                width: 72.w,
                height: 26.h,
                child: Text(
                  model.title,
                  style: AppTheme().textStyle(
                      fontSize: 12.sp,
                      color: model == logic.curClassify
                          ? const Color(0xFF612ADA)
                          : AppTheme.colorTextDark),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                width: 10.w,
              );
            },
            itemCount: logic.classifyList.length));
  }

  ///列表
  _list() {
    return AppGridSeparatedView(
      shrinkWrap: true,
      padding: EdgeInsets.all(15.w),
      controller: logic.subRefreshController,
      itemCount: logic.dataList.length,
      isOpenRefresh: false,
      isOpenLoadMore: false,
      footer: AppLoadMoreFooter.getFooter(isEmptyData: logic.isNoData),
      itemBuilder: (_, int index) {
        ShopItem itemModel = logic.dataList[index];
        return AppColumn(
          onTap: () {
            logic.onClickShopItem(itemModel);
            widget.onRefreshTop();
          },
          mainAxisAlignment: MainAxisAlignment.center,
          color: AppTheme.colorDarkBg,
          radius: 10.w,
          strokeWidth: 1.w,
          strokeColor: itemModel == logic.curItem.value
              ? const Color(0xFF612ADA)
              : AppTheme.colorDarkBg,
          children: [
            if (logic.tabModel.id == 5)
              AppStack(
                children: [
                  AppLocalImage(path: AppResource().fancyNumberBg, width: 97.h),
                  Positioned(
                    top: 0,
                    left: 15.w,
                    right: 0,
                    bottom: 0,
                    child: Center(
                      child: Text(
                        itemModel.fancyNumber ?? "",
                        style: AppTheme().textStyle(
                            fontSize: 12.sp, color: AppTheme.colorTextWhite),
                      ),
                    ),
                  )
                ],
              )
            else
              AppNetImage(
                imageUrl: itemModel.image,
                width: 70.w,
                height: 70.w,
              ),
            SizedBox(
              height: 6.h,
            ),
            Text(
              itemModel.title ?? "",
              style: AppTheme()
                  .textStyle(fontSize: 14.sp, color: AppTheme.colorTextWhite),
            )
          ],
        );
      },
      //水平子Widget之间间距
      crossAxisSpacing: 8.w,
      //垂直子Widget之间间距
      mainAxisSpacing: 8.h,
      //一行的Widget数量
      crossAxisCount: 3,
      //子Widget宽高比例
      childAspectRatio: 110 / 130,
      isNoData: logic.isNoData,
      onRefresh: logic.pullRefresh,
      onLoad: logic.loadMore,
    );
  }

  ///底部
  _bottom() {
    //1 可以购买 2 已经有了可以再次购买续时长 3 买了永久的了 不可以再买了
    if (logic.curItem.value?.state == 1) {
      return AppColumn(
        width: double.infinity,
        alignment: Alignment.topCenter,
        color: AppTheme.colorDarkLightBg,
        height: 76.h + ScreenUtils.safeBottomHeight,
        children: [
          Opacity(
            opacity:
                (logic.curItem.value?.price?.isNotEmpty == true) ? 1.0 : 0.6,
            child: AppColorButton(
                height: 56.h,
                margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h),
                onClick: () {
                  if (logic.curItem.value?.price?.isNotEmpty == true) {
                    logic.buyShop(onBuySuc: () {
                      setState(() {});
                    });
                  }
                },
                padding: EdgeInsets.zero,
                fontSize: 14.sp,
                title: (logic.curItem.value?.price?.isNotEmpty == true)
                    ? '金币购买'
                    : "不可购买",
                titleColor: AppTheme.colorTextWhite,
                bgGradient: AppTheme().shopBtnGradient),
          )
        ],
      );
    } else {
      return AppColumn(
        width: double.infinity,
        alignment: Alignment.topCenter,
        color: AppTheme.colorDarkLightBg,
        height: 76.h + ScreenUtils.safeBottomHeight + 40.h,
        children: [
          AppContainer(
            onTap: () {
              logic.onPushBag();
            },
            height: 40.h,
            child: Center(
              child: Text(
                '去装扮 >',
                style: AppTheme()
                    .textStyle(fontSize: 14.sp, color: AppTheme.colorRed),
              ),
            ),
          ),
          Opacity(
            opacity: 0.6,
            child: AppColorButton(
                height: 56.h,
                margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h),
                padding: EdgeInsets.zero,
                fontSize: 14.sp,
                title: "您已拥有",
                titleColor: AppTheme.colorTextWhite,
                bgGradient: AppTheme().shopBtnGradient),
          )
        ],
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
