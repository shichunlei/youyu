import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/svga/simple_player_ext.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/primary/message/message/message_detail_logic.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

///导航栏
class MessageDetailNavBar extends StatefulWidget
    implements PreferredSizeWidget {
  static const double _space = 8;
  static final double _actionWidth = (ScreenUtils.navbarHeight + _space);

  const MessageDetailNavBar(
      {Key? key,
      this.title = ' ',
      this.titleColor,
      this.backgroundColor,
      this.rightAction,
      this.hideBackArrow = false,
      this.backImg,
      this.extraHeight = 0,
      this.onTapBack,
      this.bottomWidget,
      this.actionExtraWidth = 0,
      this.leftPadding,
      this.isBackToDismissKeyboard = true,
      this.rightPadding,
      this.onTapRight})
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

  //底部控件
  final Widget? bottomWidget;

  //额外宽度
  final double actionExtraWidth;

  //右边按钮
  final Widget? rightAction;

  //左右padding
  final double? leftPadding;
  final double? rightPadding;

  //事件
  final Function? onTapBack;
  final Function? onTapRight;

  final bool isBackToDismissKeyboard;

  @override
  State<MessageDetailNavBar> createState() => MessageDetailNavBarState();

  @override
  Size get preferredSize =>
      Size.fromHeight(ScreenUtils.navbarHeight + extraHeight);
}

class MessageDetailNavBarState extends MessageDetailBaseNavState<MessageDetailNavBar> {
  String? title;
  MessageDetailTitleState showState = MessageDetailTitleState.normal;

  @override
  void initState() {
    super.initState();
    title = widget.title;
  }

  ///更新title
  @override
  updateTitle({String? newTitle, MessageDetailTitleState? state}) {
    setState(() {
      showState = state ?? MessageDetailTitleState.normal;
      title = newTitle ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor ?? AppTheme.colorNavBar,
      child: SafeArea(
        child: Container(
          height: widget.preferredSize.height,
          constraints: const BoxConstraints.expand(),
          child: Column(
            children: [
              SizedBox(
                height: ScreenUtils.navbarHeight,
                child: Row(
                  children: [
                    _buildBack(),
                    _buildTitle(),
                    _buildActions(),
                  ],
                ),
              ),
              if (widget.bottomWidget != null) widget.bottomWidget!
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBack() {
    if (widget.hideBackArrow ?? true) {
      return SizedBox(
        width: MessageDetailNavBar._actionWidth + widget.actionExtraWidth,
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
        width: MessageDetailNavBar._actionWidth + widget.actionExtraWidth,
        height: ScreenUtils.navbarHeight,
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
        child: AppRow(
      alignment: Alignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
            child: Text(
          title ?? "",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: widget.titleColor ?? AppTheme.colorTextWhite,
              fontSize: 18),
        )),
        if (showState != MessageDetailTitleState.normal)
          SizedBox(
            width: 8.w,
          ),
        if (showState == MessageDetailTitleState.onLine) _onLine(),
        if (showState == MessageDetailTitleState.live) _onLive(),
      ],
    ));
  }

  Widget _onLine() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppContainer(
          radius: 12.w,
          color: AppTheme.colorMain,
          width: 6.w,
          height: 6.w,
        ),
        SizedBox(
          width: 1.w,
        ),
        Text(
          '在线',
          style: AppTheme().textStyle(
              fontSize: 12.sp, color: AppTheme.colorTextSecond),
        )
      ],
    );
  }

  Widget _onLive() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 8.w,
          height: 8.w,
          child: SVGASimpleImageExt(
            assetsName: AppResource.getSvga('audio_list'),
          ),
        ),
        SizedBox(
          width: 1.w,
        ),
        Text(
          '派对中',
          style: AppTheme().textStyle(
              fontSize: 12.sp, color: AppTheme.colorTextSecond),
        )
      ],
    );
  }

  Widget _buildActions() {
    if (widget.rightAction == null) {
      return SizedBox(
        width: MessageDetailNavBar._actionWidth + widget.actionExtraWidth,
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
      width: MessageDetailNavBar._actionWidth + widget.actionExtraWidth,
      child: widget.rightAction,
    );
  }
}
