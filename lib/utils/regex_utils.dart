import 'package:flutter/services.dart';

class RegexUtils {

   ///只能输入文字/字母/数字
   allowWordLetterOrNum() => FilteringTextInputFormatter.allow(RegExp(
       "[\u4e00-\u9fa5]"));

   ///只能输入字母和数字
   allowLetterOrNum() => FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]|[0-9.]"));

   ///只能输入数字
   allowNum() => FilteringTextInputFormatter.allow(RegExp("[0-9]"));

}