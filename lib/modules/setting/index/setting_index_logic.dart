import 'package:youyu/utils/cache_utils.dart';
import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/models/localmodel/item_title_model.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:get/get.dart';
import 'package:youyu/router/router.dart';
import 'package:path_provider/path_provider.dart';

enum SettingIndexItemType {
  account,
  privacy,
  clearCache,
  checkVersion,
  writeOff
}

class SettingIndexLogic extends AppBaseController {
  ItemTitleModel cacheItem =
      ItemTitleModel(type: SettingIndexItemType.clearCache, title: "清除缓存");

  List<ItemTitleModel> itemList = [];

  @override
  void onInit() {
    super.onInit();
    itemList.addAll([
      ItemTitleModel(type: SettingIndexItemType.account, title: "账号安全"),
      ItemTitleModel(type: SettingIndexItemType.privacy, title: "隐私设置"),
      cacheItem,
      ItemTitleModel(type: SettingIndexItemType.checkVersion, title: "检查更新"),
      ItemTitleModel(type: SettingIndexItemType.writeOff, title: "注销账号"),
    ]);
    _getCacheSize();
  }

  ///获取缓存大小
  _getCacheSize() async {
    final tempDir = await getTemporaryDirectory();
    double cache = await CacheUtils.getTotalSizeOfFilesInDir(tempDir);
    cacheItem.subTitle = CacheUtils.renderSize(cache);
    setSuccessType();
  }

  //点击事件
  onClick(ItemTitleModel model) {
    switch (model.type) {
      case SettingIndexItemType.account:
        Get.toNamed(AppRouter().settingPages.setAccountRoute.name);
        break;
      case SettingIndexItemType.privacy:
        Get.toNamed(AppRouter().settingPages.setPrivacyRoute.name);
        break;
      case SettingIndexItemType.clearCache:
        _clearCache();
        break;
      case SettingIndexItemType.checkVersion:
        Get.toNamed(AppRouter().settingPages.setCheckUpdateRoute.name);
        break;
      case SettingIndexItemType.writeOff:
        Get.toNamed(AppRouter().settingPages.setWriteOffRoute.name);
        break;
    }
  }

  _clearCache() async {
    try {
      final tempDir = await getTemporaryDirectory();
      showCommit(msg: "正在清除...");
      await CacheUtils.requestPermission(tempDir);
      hiddenCommit();
      ToastUtils.show("清除成功");
      _getCacheSize();
    } catch (err) {
      hiddenCommit();
      ToastUtils.show("清除失败");
    }
  }
}
