import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'dart:ui' as ui;
import 'dart:math';
import 'dart:typed_data';

import 'package:youyu/widgets/app/image/app_local_image.dart';

class WheelTurnWidget extends StatefulWidget {
  const WheelTurnWidget({super.key});

  @override
  State<WheelTurnWidget> createState() => _WheelTurnWidgetState();
}

class _WheelTurnWidgetState extends State<WheelTurnWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<ui.Image> _images = [];
  List<String> titles = [];
  List<String> prices = [];

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
    ui.Image? img =
        await loadImageFromAssets('assets/game/wheel/ic_wheel_pao.png');
    for (int x = 0; x < 8; x++) {
      titles.add('T_$x');
      prices.add('P_$x');
      _images.add(img!);
    }
    setState(() {});
  }

  //读取 assets 中的图片
  Future<ui.Image>? loadImageFromAssets(String path) async {
    ByteData data = await rootBundle.load(path);
    return decodeImageFromList(data.buffer.asUint8List());
  }

  void drawClick() async {
    int res = Random().nextInt(8);
    angle = res * 360 / _images.length;
    _controller.forward();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_images.isEmpty) return Container();
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
            _bgWidget(width),
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

  _bgWidget(double width) {
    return AppStack(
      alignment: Alignment.center,
      children: [
        AppLocalImage(
          path: AppResource().gameWheelCircle1,
          width: width,
        ),
      ],
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
      child: Transform.rotate(
        angle: angle * -(3.141592653589793 / 180), // 将角度转换为弧度
        child: Center(
          child: AppStack(
            alignment: Alignment.center,
            children: [
              AppLocalImage(
                path: AppResource().gameWheelInnerCircle1,
                width: width - 35.5 * 2.w,
              ),
              CustomPaint(
                size: Size(width - 35.5 * 2.w, width - 35.5 * 2.w),
                painter: SpinWheelPainter(
                    titles: titles, images: _images, prices: prices),
              )
            ],
          ),
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
  List<String> titles;
  List<ui.Image> images;
  List<String> prices;

  SpinWheelPainter(
      {required this.titles, required this.images, required this.prices});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;

    final double radius = size.width / 2;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    final int numSectors = titles.length; // 扇形数量
    final double sectorAngle = 2 * pi / numSectors; // 每个扇形的角度

    TextStyle textStyle = const TextStyle(
      color: Colors.red,
      fontSize: 12,
    );

    const double startAngle = 197 * pi / 180; // 15度的弧度值

    for (int i = 0; i < titles.length; i++) {
      final double currentStartAngle = startAngle + i * sectorAngle + 1;
      final double currentSweepAngle = sectorAngle;
      paint.color = Colors.transparent; // 循环使用颜色数组
      // i % 2 == 0
      //     ? Colors.blue
      //     : const Color.fromRGBO(251, 232, 192, 1)
      canvas.drawArc(
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
      double img_width = 40;
      if (images.isNotEmpty) {
        final imageRect = Rect.fromLTWH(
          centerX - img_width / 2,
          centerY - radius * 0.7 - img_width,
          img_width,
          img_width,
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

      // 添加文字
      final String text = titles[i];
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: textStyle,
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      // 计算文字位置
      final double textX = centerX - textPainter.width / 2;
      final double textY = centerY - radius * 0.6;

      // 绘制文字
      textPainter.paint(canvas, Offset(textX, textY));

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
      final double priceTextY = centerY - radius * 0.5;

      // 绘制文字
      priceTextPainter.paint(canvas, Offset(priceTextX, priceTextY));

      canvas.restore(); // 恢复画布状态
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
