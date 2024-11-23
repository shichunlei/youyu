import 'package:flutter/material.dart';
class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX;    // X方向的偏移量
  double offsetY;    // Y方向的偏移量
  CustomFloatingActionButtonLocation(this.location, this.offsetX, this.offsetY);
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}

class NoneFloatingActionButtonAnimator extends FloatingActionButtonAnimator {
  double? _x;
  double? _y;

  @override
  Offset getOffset({required Offset begin, required Offset end, required double progress}) {
    _x = begin.dx +(end.dx - begin.dx)*progress ;
    _y = begin.dy +(end.dy - begin.dy)*progress;
    return Offset(_x ?? 0,_y ?? 0);
  }

  @override
  Animation<double> getScaleAnimation({required Animation<double> parent}) {
    return Tween<double>(begin: 1.0, end: 1.0).animate(parent);
  }

  @override
  Animation<double> getRotationAnimation({required Animation<double> parent}) {
    return Tween<double>(begin: 1.0, end: 1.0).animate(parent);
  }

}


