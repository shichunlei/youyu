extension StrSupport on String {
  ///转bool
  bool toBool() {
    if (this == "1") return true;
    return false;
  }

  ///是否包含小写字母
  bool hasLowerCase() {
    return contains(RegExp(r'[a-z]'));
  }

  ///是否包含大写字母
  bool hasUpperCase() {
    return contains(RegExp(r'[A-Z]'));
  }

  ///是否包含数字
  bool hasNumber() {
    return contains(RegExp(r'[0-9]'));
  }

  ///是否包含符号
  bool hasSymbol() {
    return contains(RegExp(r'[!@#\$%\^&\*()\[\]_\-/+,.?":{}|<>]'));
  }

  ///邮箱判断
  bool isEmail() {
    String regexEmail =
        "^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}\$";
    if (isEmpty) return false;
    return RegExp(regexEmail).hasMatch(this);
  }

  bool cnIsNumber() {
    final reg = RegExp(r'^-?[0-9.]+$');
    return reg.hasMatch(this);
  }

  /// 1、
  int cnToInt() {
    if (cnIsNumber() == true) {
      var result = int.parse(this).toInt();
      return result;
    }
    return 10000;
  }
}
