import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:svgaplayer_flutter/parser.dart';
import 'package:svgaplayer_flutter/player.dart';

class SVGASimpleImageExt extends StatefulWidget {
  final String? resUrl;
  final String? assetsName;
  final BoxFit? fit;
  final File? file;

  const SVGASimpleImageExt({Key? key, this.resUrl, this.assetsName, this.fit, this.file})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SVGASimpleImageExtState();
  }
}

class _SVGASimpleImageExtState extends State<SVGASimpleImageExt>
    with SingleTickerProviderStateMixin {
  SVGAAnimationController? animationController;

  @override
  void initState() {
    super.initState();
    animationController = SVGAAnimationController(vsync: this);
    Future? decode;
    if (widget.resUrl != null) {
      decode = SVGAParser.shared.decodeFromURL(widget.resUrl!);
    } else if (widget.assetsName != null) {
      decode = SVGAParser.shared.decodeFromAssets(widget.assetsName!);
    } else if (widget.file != null) {
      File file = widget.file!;
      if (file.existsSync() == true) {
        Uint8List bytes = file.readAsBytesSync();
        decode = SVGAParser.shared.decodeFromBuffer(bytes);
      }
    }
    decode?.then((videoItem) {
      if (mounted && animationController != null) {
        animationController!
          ..videoItem = videoItem
          ..repeat();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (animationController == null) {
      return Container();
    }
    return SVGAImage(
      animationController!,
      fit: widget.fit ?? BoxFit.contain,
    );
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }
}
