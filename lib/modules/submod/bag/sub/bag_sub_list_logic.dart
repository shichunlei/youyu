import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/models/shop_item.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BagSubListLogic extends AppBaseController {
  late RefreshController subRefreshController;
  late TabModel tabModel;

  ///列表
  List<ShopItem> dataList = [];

  //当前选中的item
  Rx<ShopItem?> curItem = Rx(null);

  fetchList() {
    setIsLoading = true;
    request(AppApi.userDressUpUrl, params: {"type": tabModel.id})
        .then((value) {
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

  //选择商品
  onClickShopItem(ShopItem itemModel) {
    curItem.value = itemModel;
    setSuccessType();
  }

  //点击装扮
  onDressUp({required Function onSetSuc}) async {
    if (curItem.value != null) {
      showCommit();
      request(AppApi.userSetDressUpUrl,
          params: {"id": curItem.value?.id}).then((value) {
        if (curItem.value?.isSet == 1) {
          ToastUtils.show("取消成功");
          curItem.value?.isSet = 0;
        } else {
          for (ShopItem item in dataList) {
            item.isSet = 0;
          }
          ToastUtils.show("保存成功");
          curItem.value?.isSet = 1;
        }
        curItem.value = null;
        onSetSuc();
      });
    }
  }

  @override
  void reLoadData() {
    super.reLoadData();
    fetchList();
  }
}
