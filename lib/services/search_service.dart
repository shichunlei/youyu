import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/utils/sp_utils.dart';

///搜索服务
class SearchService extends AppBaseController {
  static SearchService? _instance;

  factory SearchService() => _instance ??= SearchService._();

  SearchService._();

  final String _localKey = "search_key";
  List<String> keyWords = [];

  //获取历史数据
  getAllData() async {
    keyWords.clear();
    String values = await StorageUtils.getValue(_localKey);
    if (values.isNotEmpty) {
      keyWords.addAll(values.split(","));
    }
  }

  //记录插入
  insertKeyword(String keyword) async {
    if (keyWords.contains(keyword)) {
      keyWords.remove(keyword);
    }
    keyWords.insert(0, keyword);
    StorageUtils.setValue(_localKey, keyWords.join(","));
  }

  //清空所有
  clearAll() async {
    keyWords.clear();
    StorageUtils.setValue(_localKey, "");
  }
}
