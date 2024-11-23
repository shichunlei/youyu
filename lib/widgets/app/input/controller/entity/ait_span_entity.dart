import 'package:flutter/material.dart';

class SpanEntity {
  int start=0;
  int end=0;
  String text="";
  String formatText="";
  Color? color=Colors.red;
  String id=DateTime.now().toIso8601String();

  SpanEntity(this.text, this.formatText, {this.color});


  bool contains(int selection) {
    return selection>start && selection<end;
  }

  int getAnchorPosition(int value) {
    if ((value - start) - (end - value) >= 0) {
      return end;
    } else {
      return start;
    }
  }

  bool isWrappedBy(int s, int e) {
    return (s > start && s < end) || (e > start && e < end);
  }

  void setOffset(int offset) {
    start = start+offset;
    end = end+offset;
    // print("text:${text},offset:${offset},start:${start},end:${end}");
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SpanEntity &&
        other.start == start &&
        other.end == end;
  }


}