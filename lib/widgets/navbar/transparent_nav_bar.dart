import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/material.dart';

class TransparentNavBar extends StatelessWidget implements PreferredSizeWidget {
  static final double _actionWidth = (ScreenUtils.navbarHeight);

  const TransparentNavBar(
      {super.key,
      this.title,
      this.titleColor,
      this.onClickLeft,
      this.onClickRight,
      this.leftImage,
      this.rightImage});

  //标题
  final String? title;
  //标题颜色
  final Color? titleColor;
  //左边
  final String? leftImage;
  //右边
  final String? rightImage;
  final Function? onClickLeft;
  final Function? onClickRight;


  @override
  Widget build(BuildContext context) {
    return AppColumn(
      width: double.infinity,
      padding: EdgeInsets.only(left: 15.w, right: 18.w),
      height: ScreenUtils.navbarHeight + ScreenUtils.statusBarHeight,
      children: [
        SizedBox(
          height: ScreenUtils.statusBarHeight,
        ),
        AppRow(
          height: ScreenUtils.navbarHeight,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_back(), _buildTitle(), _right()],
        )
      ],
    );
  }

  _back() {
    return AppContainer(
      width: _actionWidth,
      onTap: () {
        if (onClickLeft != null) {
          onClickLeft!();
        }
      },
      color: Colors.transparent,
      alignment: Alignment.centerLeft,
      height: ScreenUtils.navbarHeight,
      child: Image.asset(
        leftImage ?? AppResource().back,
        width: 20 / 2,
        height: 37 / 2,
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
            color: titleColor ?? AppTheme.colorTextWhite, fontSize: 18),
      ),
    ));
  }

  _right() {
    if (rightImage != null) {
      return AppContainer(
        width: _actionWidth,
        onTap: () {
          if (onClickRight != null) {
            onClickRight!();
          }
        },
        color: Colors.transparent,
        alignment: Alignment.centerRight,
        height: ScreenUtils.navbarHeight,
        child: Image.asset(
          rightImage ?? "",
          width: 18,
          height: 18,
          fit: BoxFit.contain,
        ),
      );
    } else {
      return SizedBox(
        width: _actionWidth,
      );
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(ScreenUtils.navbarHeight + ScreenUtils.statusBarHeight);
}
