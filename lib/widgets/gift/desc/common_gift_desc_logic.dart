import 'package:youyu/models/localmodel/item_title_model.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/config/api.dart';

class CommonGiftDescLogic extends AppBaseController {
  List<ItemTitleModel> dataList = [];

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  _loadData() {
    setIsLoading = true;
    request(AppApi.commonArticleUrl, params: {'classify_id': 1})
        .then((value) {
      List<dynamic> list = value.data;
      for (Map<String, dynamic> map in list) {
        ItemTitleModel entity =
            ItemTitleModel(title: map['title'], subTitle: map['content']);
        dataList.add(entity);
      }
      setSuccessType();
    });
  }

  updateData(ItemTitleModel model) {
    bool isExpand = model.extra != null ? (model.extra as bool) : false;
    model.extra = !isExpand;
    setSuccessType();
  }

  @override
  void reLoadData() {
    super.reLoadData();
    _loadData();
  }
}
