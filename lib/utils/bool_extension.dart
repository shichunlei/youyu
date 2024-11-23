extension BoolSupport on bool {
  String toStr() {
    if (this == true) return "1";
    return "0";
  }

  int toInt() {
    if (this == true) return 1;
    return 0;
  }
}
