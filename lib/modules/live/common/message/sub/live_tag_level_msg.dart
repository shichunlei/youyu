import 'package:flutter/material.dart';

class LiveTagLevelMsg {
  LiveTagLevelMsg({required this.tagName, required this.tagImage});

  final String tagName;
  final String tagImage;
  final LinearGradient? tagBgGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
    colors: [Color(0xFFD9440D), Color(0xFFFF9E94)],
  );
}
