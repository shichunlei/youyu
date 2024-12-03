import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/discover/widget/discover_item_bottom.dart';
import 'package:youyu/widgets/discover/widget/discover_item_content.dart';
import 'package:youyu/widgets/discover/widget/discover_item_header.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/dynamic_controller.dart';
import 'package:youyu/models/discover_item.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/material.dart';

enum DisCoverItemRef {
  recommendList, //推荐列表
  focusList, //关注列表
  listDetail, //动态详情
  userList, //用户详情列表
}

class DisCoverItemWidget extends StatefulWidget {
  const DisCoverItemWidget(
      {super.key,
      required this.model,
      required this.index,
      required this.ref,
      this.onClickFocus,
      this.onClickDel,
      this.onClickUser,
      this.onClickLive});

  final DiscoverItem? model;
  final int index;
  final DisCoverItemRef ref;
  final Function(DiscoverItem? model)? onClickFocus;
  final Function(DiscoverItem? model)? onClickDel;
  final Function(DiscoverItem? model)? onClickUser;
  final Function(DiscoverItem? model)? onClickLive;

  @override
  State<DisCoverItemWidget> createState() => _DisCoverItemWidgetState();
}

class _DisCoverItemWidgetState extends State<DisCoverItemWidget> {
  final _DisCoverItemConfig _uiConfig = _DisCoverItemConfig();

  @override
  void initState() {
    super.initState();
    switch (widget.ref) {
      case DisCoverItemRef.listDetail:
        _uiConfig.margin = 3.w;
        _uiConfig.radius = 0;
        _uiConfig.bgColor = Colors.transparent;
        break;
      default:
        _uiConfig.margin = 15.w;
        _uiConfig.radius = 6.w;
        _uiConfig.bgColor = AppTheme.colorDarkBg;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppColumn(
      margin: EdgeInsets.only(
        left: _uiConfig.margin ?? 0,
        right: _uiConfig.margin ?? 0,
      ),
      onTap: () {
        if (widget.ref != DisCoverItemRef.listDetail) {
          DynamicController.to.onClickDetail(widget.model);
        }
      },
      radius: _uiConfig.radius ?? 0,
      color: Colors.transparent,
      children: [
        //头部
        DisCoverItemHeaderWidget(
          padding: EdgeInsets.only(left: 0.w, right: 0.w),
          model: widget.model,
          index: widget.index,
          ref: widget.ref,
          onClickMore: DynamicController.to.onClickMore,
          onClickLive: widget.onClickLive ?? DynamicController.to.onClickLive,
          onClickUser: widget.onClickUser ??
              (widget.ref != DisCoverItemRef.userList
                  ? DynamicController.to.onClickUser
                  : null),
          onClickFocus: widget.onClickFocus,
        ),
        //内容
        DisCoverItemContentWidget(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          model: widget.model,
          index: widget.index,
          ref: widget.ref,
          onClickImage: DynamicController.to.onClickImage,
          marginLR: _uiConfig.margin ?? 0,
        ),
        //底部
        if (widget.ref != DisCoverItemRef.listDetail)
          DisCoverItemBottomWidget(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            model: widget.model,
            index: widget.index,
            ref: widget.ref,
            onClickComment: DynamicController.to.onClickComment,
            onClickDel: DynamicController.to.onClickDel,
          )
      ],
    );
  }
}

class _DisCoverItemConfig {
  double? margin;
  double? radius;
  Color? bgColor;
}
