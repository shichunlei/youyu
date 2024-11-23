// ignore_for_file: must_be_immutable

import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/icon/app_clear_icon.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';

///搜索输入框
class SearchInputWidget extends StatefulWidget {
  SearchInputWidget(
      {Key? key,
      required this.placeHolder,
      this.height,
      this.backgroundColor,
      this.enabled = true,
      this.placeHolderColor,
      this.textColor,
      this.onChanged,
      this.fontSize,
      this.controller,
      this.focusNode,
      this.onClick,
      this.radius,
      this.onSubmitted,
      this.onClickClear,
      this.margin})
      : super(key: key);

  //背景颜色
  Color? backgroundColor;

  //占位颜色
  Color? placeHolderColor;

  //文字颜色
  Color? textColor;

  //是否可以输入
  bool enabled;

  final EdgeInsetsGeometry? margin;

  //圆角
  double? radius;

  //高度
  double? height;

  //占位语
  final String placeHolder;

  //监听文字变化
  final ValueChanged<String>? onChanged;

  final Function? onClick;

  double? fontSize;

  FocusNode? focusNode;

  //控制器
  TextEditingController? controller;

  final ValueChanged<String>? onSubmitted;

  final Function? onClickClear;

  @override
  State<SearchInputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<SearchInputWidget> {
  bool _isShowClear = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller?.text.isNotEmpty == true) {
      _isShowClear = true;
    } else {
      _isShowClear = false;
    }
    widget.controller?.addListener(_updateClear);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!widget.enabled) {
          if (widget.onClick != null) {
            widget.onClick!();
          }
        }
      },
      child: Container(
        margin: widget.margin,
        padding: EdgeInsets.only(left: 15.w, right: 10.w),
        height: widget.height ?? 37.h,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular((widget.radius ?? 36.w)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppLocalImage(
              path: AppResource().search,
              width: 17.w,
            ),
            SizedBox(
              width: 8.w,
            ),
            Expanded(
                child: TextField(
              enabled: widget.enabled,
              textInputAction: TextInputAction.search,
              focusNode: widget.focusNode,
              onSubmitted: widget.onSubmitted,
              cursorColor: AppTheme.colorMain,
              controller: widget.controller,
              onChanged: (str) {
                if (widget.onChanged != null) {
                  widget.onChanged!(str);
                }
                _updateClear();
              },
              maxLines: 1,
              style: AppTheme().textStyle(
                  fontSize: widget.fontSize ?? 15.sp,
                  color: widget.textColor ?? AppTheme.colorTextWhite),
              decoration: AppTheme().inputDecoration(
                  hintText: widget.placeHolder,
                  hintSize: widget.fontSize ?? 15.sp,
                  hintColor: widget.placeHolderColor ??
                      AppTheme.colorTextSecond),
            )),
            //clear
            InkWell(
              child: AppClearIcon(
                backgroundColor:
                    widget.backgroundColor ?? const Color(0xFF1E1E1E),
                text: widget.controller?.text,
              ),
              onTap: () {
                widget.controller?.clear();
                if (widget.onClickClear != null) {
                  widget.onClickClear!();
                }
                _updateClear();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _updateClear() {
    if (widget.controller?.text.isNotEmpty == true) {
      if (!_isShowClear) {
        setState(() {});
      }
      _isShowClear = true;
    } else {
      if (_isShowClear) {
        setState(() {});
      }
      _isShowClear = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller?.removeListener(_updateClear);
  }
}
