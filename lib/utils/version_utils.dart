import 'dart:io';

import 'package:youyu/utils/platform_utils.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class VersionUtils {
  /// 获取大小
  /// kbSize 单位kb
  static String getTargetSize(double kbSize) {
    if (kbSize <= 0) {
      return "";
    } else if (kbSize < 1024) {
      return "${kbSize.toStringAsFixed(1)}KB";
    } else if (kbSize < 1048576) {
      return "${(kbSize / 1024).toStringAsFixed(1)}MB";
    } else {
      return "${(kbSize / 1048576).toStringAsFixed(1)}GB";
    }
  }

  ///获取下载缓存路径
  static Future<String> getDownloadDirPath() async {
    Directory? directory = PlatformUtils.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory?.path ?? "";
  }

  ///根据更新信息获取apk安装文件
  static Future<File> getApkFileByUpdateEntity(
      String appAndroidUrl, String currentVersionCode) async {
    String appName = getApkNameByDownloadUrl(appAndroidUrl);
    String dirPath = await getDownloadDirPath();
    return File("$dirPath/${currentVersionCode.toString()}/$appName");
  }

  ///根据下载地址获取文件名
  static String getApkNameByDownloadUrl(String downloadUrl) {
    if (downloadUrl.isEmpty) {
      return "temp_${_currentTimeMillis()}.apk";
    } else {
      String appName = downloadUrl.substring(downloadUrl.lastIndexOf("/") + 1);
      if (!appName.endsWith(".apk")) {
        appName = "temp_${_currentTimeMillis()}.apk";
      }
      return appName;
    }
  }

  ///当前时间戳
  static int _currentTimeMillis() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  ///获取应用版本号
  static Future<String> getVersionCode() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  ///获取应用build版本号
  static Future<String> getBuildCode() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }


  ///获取应用包名
  static Future<String> _getPackageName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }

  /// 安装apk
  static void installAPP(String uri) async {
    if (PlatformUtils.isAndroid) {
      String packageName = await _getPackageName();
      InstallPlugin.installApk(uri, appId: packageName);
    } else {
      InstallPlugin.gotoAppStore(uri);
    }
  }
}
