import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/time_utils.dart';

import 'package:youyu/widgets/svga/simple_player_ext.dart';
import 'package:youyu/widgets/user/user_avatar_state_widget.dart';
import 'package:youyu/widgets/user/user_info_widget.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/discover_comment_model.dart';
import 'package:youyu/modules/primary/discover/detail/discover_detail_logic.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/utils/number_ext.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/other/app_segmentation.dart';
import 'package:flutter/material.dart';

///评论
class DiscoverDetailComment extends StatefulWidget {
  const DiscoverDetailComment({super.key, required this.logic});

  final DiscoverDetailLogic logic;

  @override
  State<DiscoverDetailComment> createState() => _DiscoverDetailCommentState();
}

class _DiscoverDetailCommentState extends State<DiscoverDetailComment> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(top: 10.h, bottom: ScreenUtils.safeBottomHeight),
      itemCount: widget.logic.commentList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        DiscoverCommentModel model = widget.logic.commentList[index];
        return _comment(model);
      },
      separatorBuilder: (context, index) {
        return AppSegmentation(
          backgroundColor: const Color(0xFF262626),
          height: 1.h,
        );
      },
    );
  }

  ///评论
  _comment(DiscoverCommentModel model) {
    return AppColumn(
      onTap: () {
        widget.logic.onClickCommentItemToReply(model);
      },
      crossAxisAlignment: CrossAxisAlignment.start,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 16.h),
      children: [
        AppRow(
          children: [
            // 头像
            AppStack(
              alignment: Alignment.bottomCenter,
              children: [
                UserAvatarStateWidget(
                  avatar: model.userInfo?.avatar ?? '',
                  size: 46.w,
                  borderWidth: 1.w,
                  borderColor: AppTheme.colorTextWhite,
                  userInfo: model.userInfo,
                ),
                if (model.userInfo?.isPlay ?? false)
                  Positioned(
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.w),
                            color: AppTheme.colorMain),
                        width: 16.w,
                        height: 10.w,
                        child: Center(
                          child: SVGASimpleImageExt(
                            assetsName: AppResource.getSvga('audio_list_white'),
                          ),
                        ),
                      ))
              ],
            ),
            // 昵称&时间
            SizedBox(
              width: 10.w,
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserInfoWidget(
                  isHighFancyNum: model.userInfo?.isHighFancyNum ?? false,
                  name: model.userInfo?.nickname ?? "",
                  sex: model.userInfo?.gender,
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  TimeUtils.displayTime(model.time ?? 0),
                  style: AppTheme().textStyle(
                      fontSize: 12.sp, color: AppTheme.colorTextSecond),
                )
              ],
            )),
            _like(model)
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 56.w),
          child: model.isReply == 1
              ? _isReply(model.reply ?? "", model.content ?? "")
              : Text(
                  model.content ?? "",
                  style: AppTheme().textStyle(
                      fontSize: 14.sp, color: AppTheme.colorTextWhite),
                ),
        ),
      ],
    );
  }

  ///点赞
  _like(DiscoverCommentModel model) {
    return AppRow(
      onTap: () {
        setState(() {
          widget.logic.onCommentLikeChanged(model);
        });
        widget.logic.onCommentLikeOrCancel(model, () {
          setState(() {
            widget.logic.onCommentLikeChanged(model);
          });
        });
      },
      children: [
        AppLocalImage(
          path: ((model.isLike ?? 0) == 1)
              ? AppResource().disLike
              : AppResource().disUnLike,
          width: 15.w,
        ),
        SizedBox(
          width: 4.w,
        ),
        Text(
          (model.likeCount ?? 0).showNum(),
          style: AppTheme()
              .textStyle(fontSize: 12.sp, color: AppTheme.colorTextSecond),
        )
      ],
    );
  }

  _isReply(String name, String content) {
    return RichText(
        text: TextSpan(
      text: "回复 ",
      style:
          AppTheme().textStyle(fontSize: 14.sp, color: AppTheme.colorTextWhite),
      children: <TextSpan>[
        TextSpan(
            style:
                AppTheme().textStyle(color: AppTheme.colorMain, fontSize: 14),
            text: "$name "),
        TextSpan(
          style: AppTheme()
              .textStyle(color: AppTheme.colorTextWhite, fontSize: 14),
          text: content,
        ),
      ],
    ));
  }
}
