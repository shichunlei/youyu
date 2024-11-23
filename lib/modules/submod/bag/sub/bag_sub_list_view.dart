import 'package:youyu/config/resource.dart';
import 'package:youyu/utils/screen_utils.dart';

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
import 'bag_sub_list_logic.dart';

class BagSubListPage extends StatefulWidget {
  const BagSubListPage(
      {Key? key,
      required this.tabModel,
      required this.curItem,
      required this.onRefreshTop})
      : super(key: key);
  final TabModel tabModel;
  final Rx<ShopItem?> curItem;
  final Function onRefreshTop;

  @override
  State<BagSubListPage> createState() => _BagSubListPageState();
}

class _BagSubListPageState extends State<BagSubListPage>
    with AutomaticKeepAliveClientMixin {
  late BagSubListLogic logic =
      Get.find<BagSubListLogic>(tag: widget.tabModel.id.toString());

  @override
  void initState() {
    super.initState();
    Get.put<BagSubListLogic>(BagSubListLogic(),
        tag: widget.tabModel.id.toString());
    logic.tabModel = widget.tabModel;
    logic.curItem = widget.curItem;
    logic.subRefreshController = RefreshController();
    logic.fetchList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppPage<BagSubListLogic>(
      tag: widget.tabModel.id.toString(),
      childBuilder: (s) {
        return Obx(() => AppColumn(
              children: [
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
    return AppColumn(
      width: double.infinity,
      alignment: Alignment.topCenter,
      color: AppTheme.colorDarkLightBg,
      height: 76.h + ScreenUtils.safeBottomHeight,
      children: [
        AppColorButton(
            height: 56.h,
            margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h),
            onClick: () {
              logic.onDressUp(onSetSuc: () {
                setState(() {});
              });
            },
            padding: EdgeInsets.zero,
            fontSize: 14.sp,
            title: logic.curItem.value?.isSet == 1 ? '取消装扮' : "保存装扮",
            titleColor: AppTheme.colorTextWhite,
            bgGradient: AppTheme().shopBtnGradient)
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
