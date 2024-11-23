import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/material.dart';

class AppWrapList extends StatefulWidget {
  const AppWrapList({
    super.key,
    this.runSpacing,
    this.spacing,
    required this.list,
    this.isMultiple = false,
    this.borderRadius,
    this.borderColor,
    this.textColor,
    this.itemHeight,
    this.itemPadding,
    this.textSize,
    this.onClickItem,
    this.onMultipleClick,
    this.isSingleHigh = false,
    this.multipleDefaultList,
  });

  //数据
  final List<String> list;

  //多选,默认选中的值
  final List<String>? multipleDefaultList;

  //主轴上子控件的间距
  final double? runSpacing;

  //交叉轴上子控件之间的间距
  final double? spacing;

  //圆角
  final BorderRadius? borderRadius;

  //边框
  final Color? borderColor;

  //文字颜色
  final Color? textColor;

  //item的高度
  final double? itemHeight;

  //item内边距
  final EdgeInsets? itemPadding;

  //文字字体大小
  final double? textSize;

  //是否多选
  final bool isMultiple;

  //单选的时候，是否高亮
  final bool isSingleHigh;

  //点击item时回调
  final Function(int index, String value)? onClickItem;

  //每次多选时回调
  final Function(List<int>)? onMultipleClick;

  @override
  State<AppWrapList> createState() => _AppWrapListState();
}

class _AppWrapListState extends State<AppWrapList> {
  List<int> selList = [];

  @override
  void initState() {
    super.initState();
    if (widget.multipleDefaultList?.isNotEmpty == true &&
        widget.list.isNotEmpty) {
      selList.addAll(widget.multipleDefaultList!
          .map((e) => widget.list.indexOf(e))
          .toList());
      selList.removeWhere((element) => element == -1);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<_AppWrapListItem> itemList = [];
    int i = 0;
    for (var value in widget.list) {
      _AppWrapListItem item = _AppWrapListItem(
        index: i,
        itemModel: value,
        isSel: selList.contains(i),
        borderRadius: widget.borderRadius,
        borderColor: widget.borderColor,
        textColor: widget.textColor,
        itemHeight: widget.itemHeight,
        itemPadding: widget.itemPadding,
        textSize: widget.textSize,
        onClick: (int index, String title) {
          //点击事件
          if (widget.onClickItem != null) {
            widget.onClickItem!(index, title);
          }
          //多选
          if (widget.isMultiple) {
            setState(() {
              if (selList.contains(index)) {
                selList.remove(index);
              } else {
                selList.add(index);
              }
            });
            if (widget.onMultipleClick != null) {
              widget.onMultipleClick!(selList);
            }
          } else {
            if (widget.isSingleHigh) {
              setState(() {
                selList.clear();
                selList.add(index);
              });
            }
          }
        },
      );
      itemList.add(item);
      i++;
    }

    return Wrap(
      //主轴上子控件的间距
      runSpacing: widget.runSpacing ?? 10.w,
      //交叉轴上子控件之间的间距
      spacing: 10.w,
      children: itemList,
    );
  }
}

class _AppWrapListItem extends StatelessWidget {
  const _AppWrapListItem(
      {this.borderRadius,
      this.borderColor,
      this.textColor,
      this.itemHeight,
      this.itemPadding,
      this.isSel = false,
      required this.itemModel,
      this.textSize,
      required this.onClick,
      required this.index});

  final int index;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final Color? textColor;
  final double? textSize;
  final double? itemHeight;
  final EdgeInsets? itemPadding;
  final String itemModel;
  final bool isSel;
  final Function(int index, String title) onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick(index, itemModel);
      },
      child: isSel ? _selState() : _normalState(),
    );
  }

  _normalState() {
    return Container(
      height: itemHeight ?? 28.h,
      padding: itemPadding ?? EdgeInsets.only(left: 11.w, right: 11.w),
      decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(5.w),
          border: Border.all(
              color: borderColor ?? AppTheme.colorMain, width: 1.w)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            itemModel,
            style: AppTheme().textStyle(
                fontSize: textSize ?? 12.sp,
                color: textColor ?? AppTheme.colorMain),
          )
        ],
      ),
    );
  }

  _selState() {
    return AppRow(
      strokeColor: AppTheme.colorMain,
      strokeWidth: 1,
      height: itemHeight ?? 28.h,
      padding: itemPadding ?? EdgeInsets.only(left: 11.w, right: 11.w),
      radius: 5.w,
      gradient: AppTheme().btnGradient,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          itemModel,
          style: AppTheme().textStyle(
              fontSize: textSize ?? 12.sp,
              color: const Color(0xFF000000)),
        )
      ],
    );
  }
}
