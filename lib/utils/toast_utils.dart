import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  ToastUtils._();

  static show(String? msgStr) {
    if (msgStr == null) return;
    Fluttertoast.showToast(
      msg: msgStr,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: const Color(0xFF2C2C2C),
      webBgColor: "linear-gradient(to right, #2C2C2C, #2C2C2C)",
      textColor: Colors.white,
      webPosition : "center",
      fontSize: 16,
    );
  }

}
