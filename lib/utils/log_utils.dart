import 'dart:developer';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(
    methodCount: 1,
    errorMethodCount: 8,
    colors: true,
    printEmojis: false,
    printTime: false,
  ),
);
class LogUtils {

  static void onPrint(dynamic message, {String tag = ""}) {
    print('$tag - $message');
  }

  static void onError(dynamic message, {String tag = ""}) {
    log('$tag - $message');
  }

  static void onInfo(dynamic message, {String tag = ""}) {
    log('$tag - $message');
  }
  
}
