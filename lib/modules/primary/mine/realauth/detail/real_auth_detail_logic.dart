import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:get/get.dart';

class RealAuthDetailLogic extends AppBaseController {
  var name = ''.obs;
  final _idNum = ''.obs;

  String get idNum {
    if (_idNum.value.length > 2) {
      return _idNum.value
          .replaceRange(1, _idNum.value.length - 1, '*************');
    }
    return _idNum.value;
  }

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  _loadData() {
    request(AppApi.userRealInfoUrl).then((value) {
      if (value.data != null) {
        name.value = value.data['name'];
        _idNum.value = value.data['id_num'];
      }
    }).catchError((e) {
      setErrorType(e);
    });
  }

  @override
  void reLoadData() {
    super.reLoadData();
    _loadData();
  }
}
