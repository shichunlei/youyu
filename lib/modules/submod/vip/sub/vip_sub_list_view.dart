import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/modules/submod/vip/sub/widget/vip_more_widget.dart';
import 'package:youyu/modules/submod/vip/sub/widget/vip_pay_type_widget.dart';
import 'package:youyu/modules/submod/vip/sub/widget/vip_price_widget.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'vip_sub_list_logic.dart';

class VipSubListPage extends StatefulWidget {
  const VipSubListPage({Key? key, required this.tabModel}) : super(key: key);

  final TabModel<bool> tabModel;

  @override
  State<VipSubListPage> createState() => _VipSubListPageState();
}

class _VipSubListPageState extends State<VipSubListPage> {
  late VipSubListLogic logic =
      Get.find<VipSubListLogic>(tag: widget.tabModel.id.toString());

  @override
  void initState() {
    super.initState();
    Get.put<VipSubListLogic>(VipSubListLogic(),
        tag: widget.tabModel.id.toString());
    logic.tabModel = widget.tabModel;
    logic.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return AppPage<VipSubListLogic>(
      tag: widget.tabModel.id.toString(),
      childBuilder: (s) {
        return AppContainer(
          margin: EdgeInsets.only(top: 13.h),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: 4,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    //价格
                    return VipPriceWidget(
                      list: logic.priceList,
                      selModel: logic.selPriceModel,
                      onClickPrice: logic.onClickPrice,
                      isSVip: logic.tabModel.customExtra ?? false,
                    );
                  case 1:
                    //支付方式
                    return VipPayTypeWidget(
                      list: logic.typeList,
                      selModel: logic.selTypeModel,
                      onClickType: logic.onClickType,
                    );
                  case 2:
                    //更多
                    return VipMoreWidget(
                        list: (logic.tabModel.customExtra ?? false)
                            ? logic.moreSVipList
                            : logic.moreVipList);
                }
                return Container();
              }),
        );
      },
    );
  }
}
