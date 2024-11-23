import 'package:youyu/controllers/app_controller.dart';

class FormatUtil {


  ///获取系统id
  static int getRealId(String imId) {
    if (imId == "administrator") {
      return -99;
    }
    return int.parse(
        imId.replaceAll('${AppController.to.tencentUserPrefix}_', ''));
  }

  ///获取系统id通过会话
  static int getRealIdByConId(String conId) {
    return int.parse(
        conId.replaceAll('c2c_${AppController.to.tencentUserPrefix}_', ''));
  }

  ///获取会话id
  static String getImConId(String sysId) {
    return 'c2c_${AppController.to.tencentUserPrefix}_$sysId';
  }

  ///获取imID
  static String getImUserId(String sysId) {
    return '${AppController.to.tencentUserPrefix}_$sysId';
  }
}
