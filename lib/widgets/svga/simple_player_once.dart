import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:svgaplayer_flutter/parser.dart';
import 'package:svgaplayer_flutter/player.dart';

class SVGASimpleImageOnce extends StatefulWidget {
  final String? resUrl;
  final String? assetsName;
  final BoxFit? fit;
  final File? file;
  final Function onAniEnd;

  const SVGASimpleImageOnce(
      {Key? key,
      this.resUrl,
      this.assetsName,
      this.fit,
      this.file,
      required this.onAniEnd})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SVGASimpleImageOnceState();
  }
}

class SVGASimpleImageOnceState extends State<SVGASimpleImageOnce>
    with SingleTickerProviderStateMixin {
  SVGAAnimationController? animationController;

  //动画是否结束
  bool isAniEnd = false;

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
          ..forward();

        animationController?.addListener(() {
          if (animationController?.isCompleted == true) {
            isAniEnd = true;
            widget.onAniEnd();
          }
        });
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
