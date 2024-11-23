import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/wallet/backpack/index/list/back_pack_order_list_logic.dart';
import 'package:youyu/modules/wallet/backpack/index/list/item/back_pack_order_item.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';
import 'package:youyu/widgets/app/other/app_segmentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackPackOrderListPage extends StatefulWidget {
  const BackPackOrderListPage({Key? key, required this.isIn}) : super(key: key);

  final bool isIn;

  @override
  State<BackPackOrderListPage> createState() => _BackPackOrderListPageState();
}

class _BackPackOrderListPageState extends State<BackPackOrderListPage> {
  late BackPackOrderListLogic logic =
      Get.put(BackPackOrderListLogic(), tag: widget.isIn ? "1" : "0");

  @override
  initState() {
    super.initState();
    Get.put(() => BackPackOrderListLogic(), tag: widget.isIn ? "1" : "0");
    logic.type = widget.isIn ? 2 : 1;
    logic.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return AppPage<BackPackOrderListLogic>(
        isUseScaffold: false,
        tag: widget.isIn ? "1" : "0",
        childBuilder: (s) {
          return AppColumn(
              topRightRadius: 6.w,
              topLeftRadius: 6.w,
              width: double.infinity,
              height: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 14.sp),
              color: AppTheme.colorDarkBg,
              children: [
                Expanded(child: AppListSeparatedView(
                  itemCount: s.dataList.length,
                  padding: EdgeInsets.zero,
                  controller: s.refreshController,
                  isOpenRefresh: true,
                  isOpenLoadMore: true,
                  isNoData: logic.isNoData,
                  onRefresh: () {
                    s.pullRefresh();
                  },
                  onLoad: () {
                    s.loadMore();
                  },
                  separatorBuilder: (_, int index) {
                    return AppSegmentation(
                      height: 1.h,
                    );
                  },
                  itemBuilder: (_, int index) {
                    return BackPackOrderItem(
                      model: s.dataList[index],
                    );
                  },
                ))
              ]);
        });
  }
}
