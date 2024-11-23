import 'dart:io';

import 'package:youyu/modules/live/index/operation/live_index_operation.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';

import 'package:youyu/widgets/svga/simple_player_repeat.dart';
import 'package:youyu/widgets/user/user_info_widget.dart';
import 'package:youyu/widgets/user/user_tag_widget.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/services/async_down_service.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_round_container.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'live_pop_user_logic.dart';

class LivePopUser extends StatefulWidget {
  const LivePopUser(
      {super.key,
      this.targetUserInfo,
      required this.isOwnerByOp,
      required this.isManagerByOp,
      required this.isManagerByTarget,
      required this.isOwnerByTarget,
      required this.targetUserId,
      required this.isOnWheatByTarget,
      this.isDisableMic = false,
      required this.roomId,
      required this.updateTargetInfo});

  final int roomId;

  ///目标人信息
  //目标用户id
  final int targetUserId;

  //目标用户信息
  final UserInfo? targetUserInfo;

  //目标用户是否是管理员
  final bool isManagerByTarget;

  //目标用户是否房主
  final bool isOwnerByTarget;

  //目标用户是否在麦
  final bool isOnWheatByTarget;

  ///操作人信息
  final bool isOwnerByOp;
  final bool isManagerByOp;

  //是否禁麦
  final bool isDisableMic;

  final Function(UserInfo? targetInfo) updateTargetInfo;

  @override
  State<LivePopUser> createState() => _LivePopUserState();
}

class _LivePopUserState extends State<LivePopUser> {
  late LivePopUserLogic logic = Get.find<LivePopUserLogic>();
  File? headFile;

  @override
  void initState() {
    super.initState();
    Get.put<LivePopUserLogic>(LivePopUserLogic());

    ///数据赋值
    logic.roomId = widget.roomId;
    //目标人信息
    logic.targetUserId = widget.targetUserId;
    logic.targetUserInfo = widget.targetUserInfo;
    logic.isManagerByTarget = widget.isManagerByTarget;
    logic.isOwnerByTarget = widget.isOwnerByTarget;
    logic.isOnWheatByTarget = widget.isOnWheatByTarget;
    if (UserController.to.id == widget.targetUserId) {
      logic.isMine = true;
    }
    //操作人信息
    logic.isOwnerByOp = widget.isOwnerByOp;
    logic.isManagerByOp = widget.isManagerByOp;

    logic.isDisableMic = widget.isDisableMic;
    // logic.loadData(widget.updateTargetInfo);

    _loadHeadBorder();
  }

  _loadHeadBorder() async {
    if (widget.targetUserInfo?.dressHead() != null) {
      headFile = await AsyncDownService().addTask(DownType.header,
          DownModel(url: widget.targetUserInfo?.dressHead()?.res ?? ""));
      setState(() {});
    }

    logic.loadData(widget.updateTargetInfo);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppPage<LivePopUserLogic>(
      isUseScaffold: false,
      backgroundColor: Colors.transparent,
      bodyHeight: logic.height + ScreenUtils.safeBottomHeight + 109.h,
      childBuilder: (s) {
        return AppStack(
          width: ScreenUtils.screenWidth,
          alignment: Alignment.topCenter,
          children: [
            AppColumn(
              margin: EdgeInsets.only(top: 45.h),
              width: ScreenUtils.screenWidth,
              mainAxisSize: MainAxisSize.min,
              padding: EdgeInsets.only(
                  top: 13.h, bottom: ScreenUtils.safeBottomHeight),
              topRightRadius: 12.w,
              topLeftRadius: 12.w,
              color: AppTheme.colorDarkBg,
              children: [
                _topContent(),
                _centerContent(),
                Expanded(child: _bottomButtons()),
                if (logic.operations.isNotEmpty) _bottomOperations()
              ],
            ),
            AppStack(
              width: widget.targetUserInfo?.dressHead() != null ? 108.w : 90.w,
              height: widget.targetUserInfo?.dressHead() != null ? 108.w : 90.w,
              alignment: Alignment.center,
              children: [
                AppCircleNetImage(
                  onTap: () {
                    UserController.to.pushToUserDetail(
                        widget.targetUserInfo?.id, UserDetailRef.live);
                  },
                  imageUrl: widget.targetUserInfo?.avatar,
                  size: 90.w,
                ),
                _headerBorder()
              ],
            ),
          ],
        );
      },
    );
  }

  ///头像框
  _headerBorder() {
    if (headFile != null) {
      return SizedBox(
        width: 108.w,
        height: 108.w,
        child: SVGASimpleImageRepeat(
          key: UniqueKey(),
          file: headFile,
          fit: BoxFit.cover,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  ///顶部
  _topContent() {
    return AppRow(
      padding: EdgeInsets.only(left: 17.w, right: 17.w),
      height: 21.h,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ///举报 & @TA
        logic.isMine
            ? const SizedBox.shrink()
            : Row(
                children: [
                  AppRoundContainer(
                      onTap: () {
                        logic.onClickEvent(MicOperationType.report);
                      },
                      alignment: Alignment.center,
                      width: 45.w,
                      height: 20.h,
                      border: Border.all(
                          color: AppTheme.colorTextWhite, width: 1.w),
                      child: Text(
                        '举报',
                        style: AppTheme().textStyle(
                            fontSize: 12.sp, color: AppTheme.colorTextSecond),
                      )),
                  SizedBox(
                    width: 5.w,
                  ),
                  AppRoundContainer(
                      onTap: () {
                        logic.onClickEvent(MicOperationType.at);
                      },
                      alignment: Alignment.center,
                      width: 45.w,
                      height: 20.h,
                      border: Border.all(
                          color: AppTheme.colorTextWhite, width: 1.w),
                      child: Text(
                        '@TA',
                        style: AppTheme().textStyle(
                            fontSize: 12.sp, color: AppTheme.colorTextSecond),
                      ))
                ],
              ),
        AppRow(
          onTap: () {
            Clipboard.setData(
                ClipboardData(text: '${widget.targetUserInfo?.fancyNumber}'));
            ToastUtils.show('复制成功');
          },
          children: [
            if (widget.targetUserInfo?.isHighFancyNum == true)
              AppLocalImage(
                path: AppResource().lh,
                width: 16.w,
              ),
            SizedBox(
              width: 5.w,
            ),
            Text(
              'ID:${widget.targetUserInfo?.fancyNumber}',
              style: AppTheme()
                  .textStyle(fontSize: 12.sp, color: AppTheme.colorTextSecond),
            ),
            SizedBox(
              width: 4.w,
            ),
            AppLocalImage(
              path: AppResource().copy,
              width: 10.w,
            ),
          ],
        )
      ],
    );
  }

  ///中间
  _centerContent() {
    return AppColumn(
      padding: EdgeInsets.only(
        left: 17.w,
        right: 17.w,
      ),
      crossAxisAlignment: CrossAxisAlignment.center,
      margin: EdgeInsets.only(top: 35.h),
      children: [
        AppRow(
          margin: EdgeInsets.only(bottom: 11.h),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UserInfoWidget(
              isHighFancyNum: widget.targetUserInfo?.isHighFancyNum ?? false,
              name: widget.targetUserInfo?.nickname ?? "",
              sex: widget.targetUserInfo?.gender,
            ),
            if (logic.targetUserInfo?.unionName?.isNotEmpty == true)
              SizedBox(
                width: 10.w,
              ),
            if (logic.targetUserInfo?.unionName?.isNotEmpty == true)
              AppRoundContainer(
                  alignment: Alignment.center,
                  height: 16.sp,
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  gradient: AppTheme().btnGradient,
                  child: Text(
                    logic.targetUserInfo?.unionName ?? "",
                    style: AppTheme().textStyle(
                        fontSize: 10.sp, color: const Color(0xFF000000)),
                  )),
          ],
        ),
        UserTagWidget(tagList: widget.targetUserInfo?.userTagList ?? []),
        if (widget.targetUserInfo?.userTagList.isNotEmpty == true)
          SizedBox(
            height: 11.h,
          ),
        AppRow(
          mainAxisSize: MainAxisSize.min,
          alignment: Alignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          children: [
            AppLocalImage(
              path: AppResource().signTip,
              width: 15.w,
            ),
            SizedBox(
              width: 5.w,
            ),
            Flexible(
                child: Text(
              logic.targetUserInfo?.signature?.isNotEmpty == true
                  ? (logic.targetUserInfo?.signature ?? "")
                  : "暂无签名",
              style: AppTheme()
                  .textStyle(fontSize: 12, color: AppTheme.colorTextSecond),
            ))
          ],
        ),
        AppContainer(
          margin: EdgeInsets.only(
            top: 20.w,
          ),
          child: AppStack(
            onTap: () {
              UserController.to.pushToUserDetail(
                  widget.targetUserInfo?.id, UserDetailRef.live);
            },
            children: [
              AppLocalImage(path: AppResource().liveUserCardRelationBg),
              Positioned(
                top: 0,
                // left: 0,
                right: 0,
                bottom: 0,
                child: Row(
                  children: [
                    logic.relationList.isNotEmpty == true
                        ? AppStack(
                            width: 44.w,
                            height: 44.h,
                            alignment: Alignment.center,
                            children: [
                                Positioned(
                                    child: _headWidget(
                                        logic.relationList[0]?.avatar ?? "")),
                                Positioned(
                                    bottom: 0,
                                    child: AppNetImage(
                                      width: 38.w,
                                      imageUrl:
                                          logic.relationList[0]?.textImg ?? "",
                                    ))
                              ])
                        : _relationEmpty(),
                    Padding(
                      padding: EdgeInsets.all(10.w),
                      child: AppLocalImage(
                        path: AppResource().liveUserCardRelationLine,
                        height: 29.h,
                      ),
                    ),
                    logic.relationList.length >= 2
                        ? AppStack(
                            width: 44.w,
                            height: 44.h,
                            alignment: Alignment.center,
                            children: [
                                Positioned(
                                    child: _headWidget(
                                        logic.relationList[1]?.avatar ?? "")),
                                Positioned(
                                    bottom: 0,
                                    child: AppNetImage(
                                      width: 38.w,
                                      imageUrl:
                                          logic.relationList[1]?.textImg ?? "",
                                    ))
                              ])
                        : _relationEmpty(),
                    Padding(
                      padding: EdgeInsets.all(10.w),
                      child: AppLocalImage(
                        path: AppResource().liveUserCardRelationLine,
                        height: 29.h,
                      ),
                    ),
                    logic.relationList.length >= 3
                        ? AppStack(
                            width: 44.w,
                            height: 44.h,
                            alignment: Alignment.center,
                            children: [
                                Positioned(
                                    child: _headWidget(
                                        logic.relationList[2]?.avatar ?? "")),
                                Positioned(
                                    bottom: 0,
                                    child: AppNetImage(
                                      width: 38.w,
                                      imageUrl:
                                          logic.relationList[2]?.textImg ?? "",
                                    ))
                              ])
                        : _relationEmpty(),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 22.w),
                      child: AppLocalImage(
                        path: AppResource().arrow2,
                        height: 11.h,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  _headWidget(String url) {
    if (url.isEmpty) {
      return Container(
        width: 38.w,
        height: 38.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99.w),
            border: Border.all(width: 2.w, color: AppTheme.colorTextWhite)),
      );
    }
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: AppTheme.colorTextWhite,
                offset: const Offset(0, 0),
                blurRadius: 3.w)
          ],
          borderRadius: BorderRadius.circular(99.w),
          border: Border.all(width: 2.w, color: AppTheme.colorTextWhite)),
      width: 38.w,
      height: 38.w,
      child: Align(
        child: AppCircleNetImage(
          imageUrl: url,
          size: 36.w,
        ),
      ),
    );
  }

  _relationEmpty() {
    return Container(
        alignment: Alignment.center,
        child: AppLocalImage(
          path: AppResource().liveRelationEmpty,
          width: 44.w,
        ));
  }

  ///button
  _bottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: logic.bottomButtons,
    );
  }

  ///底部
  _bottomOperations() {
    List<Widget> list = logic.operations
        .map((e) => Expanded(
                child: AppContainer(
              onTap: () {
                logic.onClickEvent(e.type);
              },
              child: Text(
                e.title,
                textAlign: TextAlign.center,
                style: AppTheme()
                    .textStyle(fontSize: 16.sp, color: AppTheme.colorTextWhite),
              ),
            )))
        .toList();
    return AppRow(
      mainAxisAlignment: MainAxisAlignment.center,
      height: 30.h,
      children: list,
    );
  }
}
