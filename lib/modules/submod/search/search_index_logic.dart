import 'package:youyu/widgets/app/app_default.dart';
import 'package:youyu/config/resource.dart';

import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/router/router.dart';
import 'package:youyu/services/search_service.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/dialog/app_tip_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SearchIndexLogic extends AppBaseController {
  TextEditingController searchController = TextEditingController();

  //搜索关键词
  String _keyword = "";

  @override
  void onInit() async {
    super.onInit();
    _fetchHistory();
  }

  ///获取搜索历史
  _fetchHistory() async {
    setIsLoading = true;
    setNoneType();
    await SearchService().getAllData();
    setIsLoading = false;
    if (SearchService().keyWords.isNotEmpty) {
      setSuccessType();
    } else {
      setEmptyType(
          defaultConfig: AppDefaultConfig(
              title: "暂无搜索历史", image: AppResource().empty));
    }
  }

  ///搜索
  search(String value) {
    if (value.isNotEmpty) {
      //判断是否和上次相同
      if (_keyword != value) {
        //设置keyword
        _keyword = value;
        //插入搜索值
        SearchService().insertKeyword(value);
      }
      //进入sub
      Get.toNamed(AppRouter().otherPages.searchSubRoute.name, arguments: value)
          ?.then((value) {
        setSuccessType();
      });
    }
  }

  ///清除历史
  clearHistory() {
    AppTipDialog().showTipDialog("提示", AppWidgetTheme.dark, msg: "是否删除历史记录",
        onCommit: () {
      _keyword = "";
      SearchService().clearAll();
      _fetchHistory();
    });
  }
}
