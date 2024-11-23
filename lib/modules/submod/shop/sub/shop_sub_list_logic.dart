import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/models/localmodel/item_title_model.dart';
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/models/shop_item.dart';
import 'package:youyu/models/shop_price_item.dart';
import 'package:youyu/modules/submod/shop/widget/dialog/shop_bug_dialog.dart';
import 'package:get/get.dart';
import 'package:youyu/router/router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ShopSubListLogic extends AppBaseController {
  late RefreshController subRefreshController;
  late TabModel tabModel;

  late Rx<ShopItem?> curItem;

  ///类型
  List<ItemTitleModel> classifyList = [
    ItemTitleModel(title: "茶豆购买"),
    // ItemTitleModel(title: "金币兑换"),
    // ItemTitleModel(title: "活动专属"),
    // ItemTitleModel(title: "爵位特权")
  ];

  //当前选中的classify
  ItemTitleModel? curClassify;

  ///列表
  List<ShopItem> dataList = [];

  fetchList() {
    curClassify = classifyList.first;
    setIsLoading = true;
    request(AppApi.shopListUrl, params: {"type": tabModel.id}).then((value) {
      dataList.clear();
      //设置数据
      List<dynamic> list = value.data;
      for (Map<String, dynamic> map in list) {
        ShopItem entity = ShopItem.fromJson(map);
        dataList.add(entity);
      }
      isNoData = dataList.isEmpty;
      setSuccessType();
    }).catchError((e) {
      setErrorType(e);
    });
  }

  //选择类型
  onClickClassify(ItemTitleModel model) {
    curClassify = model;
    setSuccessType();
  }

  //选择商品
  onClickShopItem(ShopItem itemModel) {
    curItem.value = itemModel;
    setSuccessType();
  }

  //点击购买
  buyShop({required Function onBuySuc}) async {
    if (curItem.value != null) {
      ShopPriceItem? priceItem = await Get.bottomSheet(ShopBuyDialog(
        item: curItem.value!,
      ));
      if (priceItem != null) {
        showCommit();
        request(AppApi.shopBugUrl, params: {"price_id": priceItem.id})
            .then((value) {
          ToastUtils.show("购买成功");
          if (priceItem.day == -1) {
            curItem.value?.state = 3;
          } else {
            curItem.value?.state = 2;
          }
          onBuySuc();
        });
      }
    }
  }

  ///去装扮
  onPushBag() {
    Get.toNamed(AppRouter().otherPages.bagRoute.name);
  }

  @override
  void reLoadData() {
    super.reLoadData();
    fetchList();
  }
}
