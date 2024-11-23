import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

///导航栏
class LiveConversationNavBar extends StatefulWidget {
  static const double _space = 8;
  static final double _actionWidth = (ScreenUtils.navbarHeight + _space);

  const LiveConversationNavBar(
      {Key? key,
        this.title = ' ',
        this.titleColor,
        this.backgroundColor,
        this.rightAction,
        this.hideBackArrow = false,
        this.backImg,
        this.extraHeight = 0,
        this.onTapBack,
        this.actionExtraWidth = 0,
        this.leftPadding,
        this.isBackToDismissKeyboard = true,
        this.rightPadding,
        this.onTapRight,
        this.topRadius,
        required this.height})
      : super(key: key);

  //标题
  final String title;

  //标题颜色
  final Color? titleColor;

  //背景
  final Color? backgroundColor;

  //返回图片
  final String? backImg;

  //是否隐藏返回按钮
  final bool? hideBackArrow;

  //额外高度
  final double extraHeight;

  //额外宽度
  final double actionExtraWidth;

  //右边按钮
  final Widget? rightAction;

  //左右padding
  final double? leftPadding;
  final double? rightPadding;

  //顶部圆角
  final double? topRadius;

  //事件
  final Function? onTapBack;
  final Function? onTapRight;

  final bool isBackToDismissKeyboard;

  final double height;

  @override
  State<LiveConversationNavBar> createState() => LiveConversationNavBarState();
}

class LiveConversationNavBarState extends State<LiveConversationNavBar> {
  String? title;

  @override
  void initState() {
    super.initState();
    title = widget.title;
  }

  ///更新title
  updateTitle({String? newTitle}) {
    setState(() {
      title = newTitle ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppRow(
      height: widget.height,
      topLeftRadius: widget.topRadius,
      topRightRadius: widget.topRadius,
      color: widget.backgroundColor ?? AppTheme.colorNavBar,
      children: [
        _buildBack(),
        _buildTitle(),
        _buildActions(),
      ],
    );
  }

  Widget _buildBack() {
    if (widget.hideBackArrow ?? true) {
      return SizedBox(
        width: LiveConversationNavBar._actionWidth + widget.actionExtraWidth,
      );
    }
    return GestureDetector(
      onTap: () {
        if (widget.onTapBack != null) {
          widget.onTapBack!();
        } else {
          if (widget.isBackToDismissKeyboard) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
          Get.back();
        }
      },
      child: Container(
        color: Colors.transparent,
        alignment: Alignment.centerLeft,
        width: LiveConversationNavBar._actionWidth + widget.actionExtraWidth,
        height: widget.height,
        padding: EdgeInsets.only(left: widget.leftPadding ?? 15.w),
        child: Image.asset(
          widget.backImg ?? AppResource().back,
          width: 20 / 2,
          height: 37 / 2,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Expanded(
        child: Container(
          alignment: Alignment.center,
          child: Text(
            title ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: widget.titleColor ?? AppTheme.colorTextWhite,
                fontSize: 18),
          ),
        ));
  }

  Widget _buildActions() {
    if (widget.rightAction == null) {
      return SizedBox(
        width: LiveConversationNavBar._actionWidth + widget.actionExtraWidth,
      );
    }
    return AppContainer(
      onTap: () {
        if (widget.onTapRight != null) {
          widget.onTapRight!();
        }
      },
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: widget.rightPadding ?? 15),
      width: LiveConversationNavBar._actionWidth + widget.actionExtraWidth,
      child: widget.rightAction,
    );
  }
}
