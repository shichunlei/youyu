extension NumSupport on num {

  ///显示数量的统一规则
  String showNum() {
    if (this > 999 && this < 9999) {
      return "${(this / 1000.0).toStringAsFixed(1)}k";
    } else if (this > 9999 && this < 999999) {
      return "${(this / 10000.0).toStringAsFixed(1)}w";
    } else if (this > 999999) {
      return "100w+";
    }
    return toString();
  }
}
