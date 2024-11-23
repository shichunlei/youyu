import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/dynamic_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/discover_item.dart';
import 'package:youyu/utils/number_ext.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';

import '../discover_item.dart';

class DisCoverItemBottomWidget extends StatefulWidget {
  const DisCoverItemBottomWidget(
      {super.key,
      required this.model,
      required this.index,
      required this.ref,
      this.onClickComment,
      required this.padding,
      this.onClickDel});

  final DiscoverItem? model;
  final int index;
  final DisCoverItemRef ref;
  final EdgeInsetsGeometry padding;

  //评论
  final Function(DiscoverItem? model)? onClickComment;

  //删除
  final Function(DiscoverItem? model)? onClickDel;

  @override
  State<DisCoverItemBottomWidget> createState() =>
      _DisCoverItemBottomWidgetState();
}

class _DisCoverItemBottomWidgetState extends State<DisCoverItemBottomWidget> {
  @override
  Widget build(BuildContext context) {
    return AppRow(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      width: double.infinity,
      height: 46.h,
      children: [
        _like(),
        SizedBox(
          width: 8.w,
        ),
        _comment(),
        if (_isShowDel())
          AppContainer(
            onTap: () {
              if (widget.onClickDel != null) {
                widget.onClickDel!(widget.model);
              }
            },
            width: 40.w,
            height: 20,
            child: Center(
              child: AppLocalImage(
                path: AppResource().del,
                width: 21.w,
              ),
            ),
          )
      ],
    );
  }

  ///点赞
  _like() {
    return AppRow(
      width: 70.w,
      onTap: () {
        setState(() {
          DynamicController.to.onLikeChanged(widget.model);
        });
        DynamicController.to.onClickLike(widget.model, onError: () {
          setState(() {
            DynamicController.to.onLikeChanged(widget.model);
          });
        });
      },
      children: [
        AppLocalImage(
          path: (widget.model?.isLike ?? 0) == 1
              ? AppResource().disLike
              : AppResource().disUnLike,
          width: 22.w,
        ),
        SizedBox(
          width: 4.w,
        ),
        Expanded(
            child: Text(
          (widget.model?.like ?? 0).showNum(),
          style: AppTheme().textStyle(
              fontSize: 12.sp, color: AppTheme.colorTextSecond),
        ))
      ],
    );
  }

  ///评论
  _comment() {
    return AppRow(
      width: 70.w,
      onTap: () {
        if (widget.onClickComment != null) {
          widget.onClickComment!(widget.model);
        }
      },
      children: [
        AppLocalImage(
          path: AppResource().disComment,
          width: 22.w,
        ),
        SizedBox(
          width: 4.w,
        ),
        Expanded(
            child: Text(
          (widget.model?.commentCount ?? 0).showNum(),
          style: AppTheme().textStyle(
              fontSize: 12.sp, color: AppTheme.colorTextSecond),
        ))
      ],
    );
  }

  ///是否显示删除
  _isShowDel() {
    if (widget.ref == DisCoverItemRef.userList &&
        widget.model?.userInfo?.id == UserController.to.id) {
      return true;
    }
    return false;
  }
}
