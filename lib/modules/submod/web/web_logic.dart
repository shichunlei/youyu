import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/modules/submod/web/param/web_model.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as WebViewA;

class WebLogic extends AppBaseController {
  ///参数
  WebParam? webParam;

  ///web控制器
  WebViewA.InAppWebViewController? controller;

  @override
  void onClose() {
    super.onClose();
    controller = null;
  }
}
