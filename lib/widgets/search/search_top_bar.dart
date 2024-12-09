import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/widgets/search/search_input_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';

class SearchTopBar extends StatefulWidget implements PreferredSizeWidget {
  const SearchTopBar(
      {super.key,
      required this.controller,
      this.onClickClear,
      this.extraHeight = 0,
      this.onTapBack,
      this.onSubmitted,
      this.extraWidget,
      this.placeHolder});

  final TextEditingController controller;
  final Function? onClickClear;
  final Function? onTapBack;
  final ValueChanged<String>? onSubmitted;
  final double extraHeight;
  final Widget? extraWidget;
  final String? placeHolder;

  @override
  State<SearchTopBar> createState() => SearchTopBarState();

  @override
  Size get preferredSize =>
      Size.fromHeight(ScreenUtils.navbarHeight + extraHeight);
}

class SearchTopBarState extends State<SearchTopBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      color: AppTheme.colorNavBar,
      width: double.infinity,
      height: widget.preferredSize.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: ScreenUtils.navbarHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildBack(),
                Expanded(
                    child: SearchInputWidget(
                        height: 38.h,
                        textColor: AppTheme.colorMain,
                        onClickClear: widget.onClickClear,
                        onSubmitted: widget.onSubmitted,
                        placeHolder: widget.placeHolder ?? '搜索房间名称，用户昵称或ID',
                        controller: widget.controller)),
                SizedBox(
                  width: 15.w,
                )
              ],
            ),
          ),
          if (widget.extraHeight > 0) widget.extraWidget!
        ],
      ),
    ));
  }

  Widget _buildBack() {
    return GestureDetector(
      onTap: () {
        if (widget.onTapBack != null) {
          widget.onTapBack!();
        } else {
          FocusManager.instance.primaryFocus?.unfocus();
          Get.back();
        }
      },
      child: Container(
        padding: EdgeInsets.only(left: 15.w),
        color: Colors.transparent,
        alignment: Alignment.centerLeft,
        width: 43.w,
        height: ScreenUtils.navbarHeight,
        child: Image.asset(
          AppResource().back,
          width: 20 / 2,
          height: 37 / 2,
        ),
      ),
    );
  }
}
