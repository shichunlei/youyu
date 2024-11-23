import 'package:flutter/material.dart';
///渐变文字
class AppGradientText extends StatelessWidget {
  const AppGradientText(this.data,
      {super.key, required this.gradient, this.style, this.textAlign = TextAlign.left});

  final String data;
  final Gradient gradient;
  final TextStyle? style;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return gradient.createShader(Offset.zero & bounds.size);
      },
      child: Text(
        data,
        textAlign: textAlign,
        style: (style == null)
            ? const TextStyle(color: Colors.white)
            : style?.copyWith(color: Colors.white),
      ),
    );
  }
}
