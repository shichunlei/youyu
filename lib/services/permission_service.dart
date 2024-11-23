import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/dialog/app_tip_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

///权限服务
class PermissionService {
  static PermissionService? _instance;

  factory PermissionService() => _instance ??= PermissionService._();

  PermissionService._();

  ///麦克风权限
  Future<PermissionStatus> checkMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (status != PermissionStatus.granted) {
      // 权限未授予，需要请求权限
      status = await _requestMicrophonePermission();
      if (status != PermissionStatus.granted) {
        AppTipDialog().showTipDialog("提示", AppWidgetTheme.dark,
            msg: "是否进入系统设置开启？", commitBtn: "确定", onCommit: () {
          // 用户拒绝了权限请求，可以引导用户前往设置页面
          // 这里可以调用 `openAppSettings()` 函数
          openAppSettings();
        }, onCancel: () {
          //...
        });
      }
      return status;
    } else {
      // 已经有权限
      return status;
    }
  }

  _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status;
  }
}
