import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/utils/time_utils.dart';
import 'package:youyu/widgets/user/user_avatar_state_widget.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/discover_item.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';

import '../discover_item.dart';

class DisCoverItemHeaderWidget extends StatefulWidget {
  const DisCoverItemHeaderWidget(
      {super.key,
      required this.model,
      required this.index,
      required this.ref,
      this.onClickUser,
      this.onClickMore,
      required this.padding,
      this.onClickLive,
      required this.onClickFocus});

  final DiscoverItem? model;
  final int index;
  final DisCoverItemRef ref;
  final EdgeInsetsGeometry padding;

  final Function(DiscoverItem? model)? onClickUser;
  final Function(DiscoverItem? model)? onClickLive;
  final Function(DiscoverItem? model)? onClickMore;
  final Function(DiscoverItem? model)? onClickFocus;

  @override
  State<DisCoverItemHeaderWidget> createState() =>
      _DisCoverItemHeaderWidgetState();
}

class _DisCoverItemHeaderWidgetState extends State<DisCoverItemHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return AppRow(
      padding: widget.padding,
      height: 72.h,
      children: [
        Expanded(
          child: AppRow(
            children: [
              UserAvatarStateWidget(
                avatar: widget.model?.userInfo?.avatar ?? '',
                size: 48.w,
                userInfo: widget.model?.userInfo,
                onClickUserHead: (userInfo) {
                  if ((userInfo?.onlineRoom ?? 0) > 0) {
                    //TODO:直播间内不能进入
                    if (!LiveService().isInLive) {
                      if (widget.onClickLive != null) {
                        widget.onClickLive!(widget.model);
                      }
                    }
                  } else {
                    if (widget.onClickUser != null) {
                      widget.onClickUser!(widget.model);
                    }
                  }
                },
              ),
              SizedBox(
                width: 9.w,
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.model?.userInfo?.nickname ?? "",
                          style: AppTheme().textStyle(
                              fontSize: 16.sp,
                              color: AppTheme.colorTextDarkSecond,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      AppLocalImage(
                        path: AppResource().girl,
                        width: 12.w,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    TimeUtils.displayTime(widget.model?.createTime ?? 0),
                    style: AppTheme().textStyle(
                        fontSize: 12.sp, color: AppTheme.colorTextSecond),
                  )
                ],
              )),
            ],
          ),
        ),
        _rightWidget(),
        if (widget.ref == DisCoverItemRef.recommendList ||
            widget.ref == DisCoverItemRef.focusList)
          SizedBox(
            width: 15.w,
          ),
        if (widget.ref == DisCoverItemRef.recommendList ||
            widget.ref == DisCoverItemRef.focusList)
          AppContainer(
            onTap: () {
              if (widget.onClickMore != null) {
                widget.onClickMore!(widget.model);
              }
            },
            child: Center(
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppTheme.colorTextSecond,
                size: 24.w,
              ),
            ),
          )
      ],
    );
  }

  _rightWidget() {
    return (widget.model?.userInfo?.id != UserController.to.id)
        ? AppColorButton(
            title: (widget.model?.userInfo?.isFocus ?? false) ? "取消关注" : "+ 关注",
            padding: EdgeInsets.zero,
            width: (widget.model?.userInfo?.isFocus ?? false) ? 56.w : 46.w,
            fontSize: 10.sp,
            height: 20.h,
            titleColor: AppTheme.colorTextWhite,
            bgGradient: (widget.model?.userInfo?.isFocus ?? false)
                ? AppTheme().btnLightGradient
                : AppTheme().focusBtnGradient,
            onClick: () {
              if (widget.onClickFocus != null) {
                widget.onClickFocus!(widget.model);
              } else {
                ///关注（外面如果没有接管，内部处理）
                UserController.to.onFocusUserOrCancel(widget.model?.userInfo,
                    onUpdate: () {
                  //通知刷新
                  UserController.to
                      .notifyChangeUserFocus(widget.model!.userInfo!);
                  setState(() {});
                });
              }
            },
          )
        : const SizedBox.shrink();
  }
}
