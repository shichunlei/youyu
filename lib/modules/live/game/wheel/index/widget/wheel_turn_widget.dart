import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'dart:ui' as ui;
import 'dart:math';
import 'dart:typed_data';

import 'package:youyu/widgets/app/image/app_local_image.dart';

class WheelTurnWidget extends StatefulWidget {
  const WheelTurnWidget(
      {super.key, required this.images, required this.prices});

  final List<ui.Image> images;
  final List<String> prices;

  @override
  State<WheelTurnWidget> createState() => _WheelTurnWidgetState();
}

class _WheelTurnWidgetState extends State<WheelTurnWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  ui.Image? paoBgImg;
  double angle = 0;

  @override
  void initState() {
    super.initState();
    initConfig();
    _loadImage();
  }

  void initConfig() {
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // 定义动画持续时间
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.decelerate);
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset(); // 重置动画
      }
    });
  }

  void _loadImage() async {
    paoBgImg = await loadImageFromAssets('assets/game/wheel/ic_wheel_pao.png');
    setState(() {});
  }

  //读取 assets 中的图片
  Future<ui.Image>? loadImageFromAssets(String path) async {
    ByteData data = await rootBundle.load(path);
    return decodeImageFromList(data.buffer.asUint8List());
  }

  void drawClick() async {
    int res = Random().nextInt(8);
    angle = res * 360 / widget.prices.length;
    _controller.forward();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return Container();
    double width = ScreenUtils.screenWidth - 28.w;
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.bottomCenter,
        width: width,
        height: double.infinity,
        padding: const EdgeInsets.only(top: 0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 4.5.w),
              child: AppLocalImage(
                path: AppResource().gameWheelCircle1,
                width: width,
              ),
            ),
            _rotationTransition(width),
            AppLocalImage(
              path: AppResource().gameWheelCenter,
              width: 140.w,
              onTap: () {
                drawClick();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _rotationTransition(double width) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 5.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.ease,
        ),
      ),
      // turns: _animation,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            AppLocalImage(
              path: AppResource().gameWheelInnerCircle1,
              width: width - 35.w * 2,
            ),
            CustomPaint(
              size: Size(width - 35.5 * 2.w, width - 35.5 * 2.w),
              painter: SpinWheelPainter(
                  paoBgImg: paoBgImg!, images: widget.images, prices: widget.prices),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // 释放动画资源
    super.dispose();
  }
}

class SpinWheelPainter extends CustomPainter {
  ui.Image paoBgImg;
  List<ui.Image> images;
  List<String> prices;

  SpinWheelPainter(
      {required this.paoBgImg, required this.images, required this.prices});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;

    final double radius = size.width / 2;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    final int numSectors = prices.length; // 扇形数量
    final double sectorAngle = 2 * pi / numSectors; // 每个扇形的角度

    TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontSize: 11.sp,
    );

    //1度
    const double oneAngle = pi / 180;
    const double startAngle = -pi / 2 - oneAngle * 2; // -90 度就在最上面

    for (int i = 0; i < prices.length; i++) {
      final double currentStartAngle = startAngle + i * sectorAngle;
      final double currentSweepAngle = sectorAngle;
      paint.color = Colors.transparent; // 循环使用颜色数组
      // paint.color =
      //     i % 2 == 0 ? Colors.blue : const Color.fromRGBO(251, 232, 192, 1);

      canvas.drawArc(
        //center 中心点  radius 半径
        Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
        currentStartAngle,
        currentSweepAngle,
        true,
        paint,
      );

      // 旋转画布
      canvas.save();
      canvas.translate(centerX, centerY);
      canvas
          .rotate(currentStartAngle + currentSweepAngle / 2 + pi / 2); // 旋转45度
      canvas.translate(-centerX, -centerY);

      ///图片
      double imgWidth = 50.w;
      double imgHeight = 55.w;
      //气泡背景图
      final imageRect = Rect.fromLTWH(
        centerX - imgWidth / 2,
        centerY - radius * 0.7 - imgHeight + 12.w,
        imgWidth,
        imgHeight,
      );
      paintImage(
        canvas: canvas,
        rect: imageRect,
        image: paoBgImg,
        fit: BoxFit.fill,
        alignment: Alignment.center,
        repeat: ImageRepeat.noRepeat,
        flipHorizontally: false,
        filterQuality: FilterQuality.low,
      );

      if (images.isNotEmpty) {
        final imageRect = Rect.fromLTWH(
          centerX - imgWidth / 2,
          centerY - radius * 0.7 - imgHeight + 12.w,
          imgWidth,
          imgHeight,
        );
        paintImage(
          canvas: canvas,
          rect: imageRect,
          image: images[i],
          fit: BoxFit.fill,
          alignment: Alignment.center,
          repeat: ImageRepeat.noRepeat,
          flipHorizontally: false,
          filterQuality: FilterQuality.low,
        );
      }

      // ///名称
      // final String text = titles[i];
      // final TextPainter textPainter = TextPainter(
      //   text: TextSpan(
      //     text: text,
      //     style: textStyle,
      //   ),
      //   textAlign: TextAlign.center,
      //   textDirection: TextDirection.ltr,
      // );
      // textPainter.layout();
      // // 计算文字位置
      // final double textX = centerX - textPainter.width / 2;
      // final double textY = centerY - radius * 0.6;
      // // 绘制文字
      // textPainter.paint(canvas, Offset(textX, textY));

      ///价格
      final String text1 = prices[i];
      final TextPainter priceTextPainter = TextPainter(
        text: TextSpan(
          text: text1,
          style: textStyle,
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      priceTextPainter.layout();
      // 计算文字位置
      final double priceTextX = centerX - priceTextPainter.width / 2;
      final double priceTextY = centerY - radius * 0.6;
      // 绘制文字
      priceTextPainter.paint(canvas, Offset(priceTextX, priceTextY));
      // 恢复画布状态
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
