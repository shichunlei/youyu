
import 'package:get/get.dart';

import '../widget/index_page_widget.dart';

class TabBarItem {
  TabBarItem(
      {required this.page,
      required String title,
      this.img,
      this.selImg,
      required this.isShowRed,
      this.width = 23,
      this.height = 23,
      this.imgMarginBottom = 4.5,
      this.imgMarginTop = 5}) {
    _title = title;
  }

  //页面
  final IndexWidget page;

  //名称
  late String _title;

  String title() => _title.tr;

  //图标
  final String? img;

  //点击后的图标
  final String? selImg;

  //图片宽
  final double width;

  //是否显示红点
  final bool isShowRed;

  //图片高
  final double height;

  //图片的marginTop
  final double imgMarginTop;

  //图片的marginBottom
  final double imgMarginBottom;
}
