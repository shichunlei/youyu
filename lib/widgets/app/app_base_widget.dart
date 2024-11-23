import 'package:flutter/material.dart';

///点击
class _AppClick extends StatelessWidget {
  final Widget? child;

  ///GestureDetector
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;
  final GestureLongPressEndCallback? onLongPressEnd;
  final GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate;
  final GestureTapCancelCallback? onTapCancel;

  const _AppClick({
    super.key,
    this.onTapDown,
    this.onTapUp,
    this.onTap,
    this.onTapCancel,
    this.onLongPress,
    this.child,
    this.onLongPressEnd,
    this.onLongPressMoveUpdate,
  }) : super();

  Widget buildRealChild({List<Widget>? supportChildList}) {
    List<Widget> supportChildListTemp = supportChildList ?? [];
    if (supportChildListTemp.length > 1) throw UnsupportedError("仅支持1个child");
    return supportChildListTemp.isEmpty
        ? (child ?? const _AppEmptyWidget())
        : supportChildListTemp.first;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTap: onTap,
      onLongPress: onLongPress,
      onLongPressEnd: onLongPressEnd,
      onLongPressMoveUpdate: onLongPressMoveUpdate,
      onTapCancel: onTapCancel,
      child: buildRealChild(),
    );
  }
}

///容器
class AppContainer extends _AppClick {
  ///快捷属性
  final double radius;
  final double? topLeftRadius;
  final double? topRightRadius;
  final double? bottomRightRadius;
  final double? bottomLeftRadius;
  final Color solidColor;
  final Color strokeColor;
  final double? strokeWidth;
  final Color? gradientStartColor;
  final Color? gradientEndColor;
  final AlignmentGeometry gradientBegin;
  final AlignmentGeometry gradientEnd;
  final LinearGradient? gradient;

  ///Container
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip clipBehavior;
  final List<BoxShadow>? boxShadow;

  const AppContainer({
    super.key,
    //快捷属性
    this.radius = 0,
    this.topLeftRadius,
    this.topRightRadius,
    this.bottomRightRadius,
    this.bottomLeftRadius,
    this.solidColor = Colors.transparent,
    this.strokeColor = Colors.transparent,
    this.strokeWidth,
    this.gradientStartColor,
    this.gradientEndColor,
    this.gradientBegin = Alignment.centerLeft,
    this.gradientEnd = Alignment.centerRight,
    this.gradient,
    //Container
    this.margin,
    this.padding,
    this.color,
    this.decoration,
    this.width,
    this.height,
    this.constraints,
    this.alignment,
    this.foregroundDecoration,
    this.transform,
    this.transformAlignment,
    this.clipBehavior = Clip.none,
    this.boxShadow,
    super.child,
    //GestureDetector
    super.onTapDown,
    super.onTapUp,
    super.onTap,
    super.onTapCancel,
    super.onLongPress,
    super.onLongPressEnd,
    super.onLongPressMoveUpdate
  }) : super();

  @override
  Widget buildRealChild({List<Widget>? supportChildList}) {
    List<Widget> supportChildListTemp = supportChildList ?? [];
    if (supportChildListTemp.length > 1) throw UnsupportedError("仅支持1个child");
    Widget supportChildTemp = supportChildListTemp.isEmpty
        ? (child ?? const _AppEmptyWidget())
        : supportChildListTemp.first;
    Widget realChild = Container(
      alignment: alignment,
      padding: padding,
      decoration: buildDecoration(),
      foregroundDecoration: foregroundDecoration,
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
      child: supportChildTemp,
    );
    return super.buildRealChild(supportChildList: [realChild]);
  }

  ///创建Decoration逻辑
  Decoration buildDecoration() {
    return decoration ??
        BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(topLeftRadius ?? radius),
              topRight: Radius.circular(topRightRadius ?? radius),
              bottomRight: Radius.circular(bottomRightRadius ?? radius),
              bottomLeft: Radius.circular(bottomLeftRadius ?? radius),
            ),
            color: _color(),
            gradient: _gradient(),
            border: (null == strokeWidth)
                ? null
                : Border.all(color: strokeColor, width: strokeWidth ?? 0),
            boxShadow: boxShadow);
  }

  _color() {
    if (gradient != null) return null;
    return (null == color)
        ? (null != gradientStartColor ? null : solidColor)
        : color;
  }

  _gradient() {
    if (gradient != null) return gradient;
    return (null == gradientStartColor)
        ? null
        : LinearGradient(
            colors: [
              gradientStartColor ?? solidColor,
              gradientEndColor ?? solidColor
            ],
            begin: gradientBegin,
            end: gradientEnd,
          );
  }
}

///弹性
class _AppFlex extends AppContainer {
  ///Flex
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;
  final List<Widget> children;
  final Axis direction;

  const _AppFlex(
      {super.key,
      //Flex
      required this.direction,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.mainAxisSize = MainAxisSize.max,
      this.crossAxisAlignment = CrossAxisAlignment.center,
      this.textDirection,
      this.verticalDirection = VerticalDirection.down,
      this.textBaseline,
      this.children = const <Widget>[],
      //快捷属性
      super.radius = 0,
      super.topLeftRadius,
      super.topRightRadius,
      super.bottomRightRadius,
      super.bottomLeftRadius,
      super.solidColor = Colors.transparent,
      super.strokeColor = Colors.transparent,
      super.strokeWidth,
      super.gradientStartColor,
      super.gradientEndColor,
      super.gradientBegin = Alignment.centerLeft,
      super.gradientEnd = Alignment.centerRight,
      super.gradient,
      //Container
      super.margin,
      super.padding,
      super.color,
      super.decoration,
      super.width,
      super.height,
      super.constraints,
      super.alignment,
      super.foregroundDecoration,
      super.transform,
      super.transformAlignment,
      super.clipBehavior,
      //GestureDetector
      super.onTapDown,
      super.onTapUp,
      super.onTap,
      super.onTapCancel,
      super.onLongPress,
      super.boxShadow});

  @override
  Widget buildRealChild({List<Widget>? supportChildList}) {
    List<Widget> supportChildListTemp = supportChildList ?? [];
    supportChildListTemp =
        supportChildListTemp.isEmpty ? children : supportChildListTemp;
    Widget realChild = Flex(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      clipBehavior: Clip.none,
      children: children,
    );
    return super.buildRealChild(supportChildList: [realChild]);
  }
}

///行
class AppRow extends _AppFlex {
  const AppRow(
      {super.key,
      //Flex
      super.mainAxisAlignment = MainAxisAlignment.start,
      super.mainAxisSize = MainAxisSize.max,
      super.crossAxisAlignment = CrossAxisAlignment.center,
      super.textDirection,
      super.verticalDirection = VerticalDirection.down,
      super.textBaseline,
      super.children = const <Widget>[],
      //快捷属性
      super.radius = 0,
      super.topLeftRadius,
      super.topRightRadius,
      super.bottomRightRadius,
      super.bottomLeftRadius,
      super.solidColor = Colors.transparent,
      super.strokeColor = Colors.transparent,
      super.strokeWidth,
      super.gradientStartColor,
      super.gradientEndColor,
      super.gradientBegin = Alignment.centerLeft,
      super.gradientEnd = Alignment.centerRight,
      super.gradient,
      //Container
      super.margin,
      super.padding,
      super.color,
      super.decoration,
      super.width,
      super.height,
      super.constraints,
      super.alignment,
      super.foregroundDecoration,
      super.transform,
      super.transformAlignment,
      super.clipBehavior,
      //GestureDetector
      super.onTapDown,
      super.onTapUp,
      super.onTap,
      super.onTapCancel,
      super.onLongPress,
      super.boxShadow})
      : super(direction: Axis.horizontal);
}

///列
class AppColumn extends _AppFlex {
  const AppColumn(
      {super.key,
      //Flex
      super.mainAxisAlignment = MainAxisAlignment.start,
      super.mainAxisSize = MainAxisSize.max,
      super.crossAxisAlignment = CrossAxisAlignment.center,
      super.textDirection,
      super.verticalDirection = VerticalDirection.down,
      super.textBaseline,
      super.children = const <Widget>[],
      //快捷属性
      super.radius = 0,
      super.topLeftRadius,
      super.topRightRadius,
      super.bottomRightRadius,
      super.bottomLeftRadius,
      super.solidColor = Colors.transparent,
      super.strokeColor = Colors.transparent,
      super.strokeWidth,
      super.gradientStartColor,
      super.gradientEndColor,
      super.gradientBegin = Alignment.centerLeft,
      super.gradientEnd = Alignment.centerRight,
      super.gradient,
      //Container
      super.margin,
      super.padding,
      super.color,
      super.decoration,
      super.width,
      super.height,
      super.constraints,
      super.alignment,
      super.foregroundDecoration,
      super.transform,
      super.transformAlignment,
      super.clipBehavior,
      //GestureDetector
      super.onTapDown,
      super.onTapUp,
      super.onTap,
      super.onTapCancel,
      super.onLongPress,
      super.boxShadow})
      : super(direction: Axis.vertical);
}

///帧布局
class AppStack extends AppContainer {
  ///Stack
  final TextDirection? textDirection;
  final StackFit? fit;
  final List<Widget> children;

  const AppStack(
      {
        //Stack
        Key? key,
        super.alignment,
        super.width,
        super.height,
        this.textDirection,
        this.fit,
        super.clipBehavior = Clip.hardEdge,
        this.children = const <Widget>[],
        //快捷属性
        super.radius = 0,
        super.topLeftRadius,
        super.topRightRadius,
        super.bottomRightRadius,
        super.bottomLeftRadius,
        super.solidColor = Colors.transparent,
        super.strokeColor = Colors.transparent,
        super.strokeWidth,
        super.gradientStartColor,
        super.gradientEndColor,
        super.gradientBegin = Alignment.centerLeft,
        super.gradientEnd = Alignment.centerRight,
        //Container
        super.margin,
        super.padding,
        super.color,
        super.decoration,
        super.constraints,
        super.transform,
        //GestureDetector
        super.onTapDown,
        super.onTapUp,
        super.onTap,
        super.onTapCancel,
        super.onLongPress,
        super.onLongPressEnd,
        super.onLongPressMoveUpdate})
      : super(key: key);

  @override
  Widget buildRealChild({List<Widget>? supportChildList}) {
    List<Widget> supportChildListTemp = supportChildList ?? [];
    supportChildListTemp = supportChildListTemp.isEmpty ? children : supportChildListTemp;
    Widget realWidget = Stack(
      alignment: alignment ?? AlignmentDirectional.topStart,
      textDirection: textDirection,
      fit: fit ?? StackFit.loose,
      clipBehavior: clipBehavior,
      children: supportChildListTemp,
    );
    return super.buildRealChild(supportChildList: [realWidget]);
  }
}

///空视图
class _AppEmptyWidget extends StatelessWidget {
  const _AppEmptyWidget();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
