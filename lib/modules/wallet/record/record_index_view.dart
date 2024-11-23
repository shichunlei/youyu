import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/modules/wallet/index/wallet_index_logic.dart';
import 'package:youyu/modules/wallet/record/item/coin_record_index_item.dart';
import 'package:youyu/modules/wallet/record/item/recharge_record_item.dart';
import 'package:youyu/modules/wallet/record/item/withdraw_record_item.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';
import 'package:youyu/widgets/app/other/app_segmentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'record_index_logic.dart';

///充值记录 & 提现记录 & 茶豆明细 & 钻石明细
class RecordIndexPage extends StatefulWidget {
  const RecordIndexPage({Key? key}) : super(key: key);

  @override
  State<RecordIndexPage> createState() => _RecordIndexPageState();
}

class _RecordIndexPageState extends State<RecordIndexPage> {
  final logic = Get.find<RecordIndexLogic>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppPage<RecordIndexLogic>(
      appBar: AppTopBar(
        title: logic.menuModel?.title ?? "",
      ),
      childBuilder: (s) {
        return AppColumn(
          padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 15.w),
          children: [
            AppRow(
              onTap: () {
                logic.showTimePicker();
              },
              margin: EdgeInsets.only(top: 15.h),
              width: double.infinity,
              height: 44.h,
              decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(6.w)),
              padding: EdgeInsets.only(left: 15.w, right: 15.w),
              children: [
                Text(
                  logic.time,
                  style: TextStyle(
                      fontSize: 16.sp, color: const Color(0xFF666666)),
                ),
                Icon(
                  Icons.expand_more,
                  color: const Color(0xFF666666),
                  size: 15.w,
                )
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
           Expanded(child:  Container(
               width: double.infinity,
               decoration: BoxDecoration(
                   color: const Color(0xFF1E1E1E),
                   borderRadius: BorderRadius.circular(6.w)),
               child: AppListSeparatedView(
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
                     height: 14.h,
                   );
                 },
                 itemBuilder: (_, int index) {
                   switch (logic.menuModel?.type as WalletListType) {
                     case WalletListType.rechargeRecord:
                       return RechargeRecordItem(
                         model: s.dataList[index],
                       );
                     case WalletListType.withdrawRecord:
                       return WithDrawRecordIndexItem(
                         model: s.dataList[index],
                       );

                     default:
                       return CoinRecordIndexItem(
                         model: s.dataList[index],
                       );
                   }
                 },
               )))
          ],
        );
      },
    );
  }
}
