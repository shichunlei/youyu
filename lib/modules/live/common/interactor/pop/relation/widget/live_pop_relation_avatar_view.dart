/*
 * @Author: alexalive hhyy1243047559@gmail.com
 * @Date: 2024-11-03 03:35:53
 * @LastEditors: alexalive hhyy1243047559@gmail.com
 * @LastEditTime: 2024-11-03 20:48:27
 * @FilePath: /youyu/lib/modules/live/common/interactor/pop/relation/widget/live_pop_relation_avatar_view.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:flutter/material.dart';

class LivePopRelationAvatarItem extends StatelessWidget {
  const LivePopRelationAvatarItem({
    super.key,
    required this.model,
  });

  final UserInfo model;

  @override
  Widget build(BuildContext context) {
    return AppColumn(
      onTap: () {
        UserController.to.pushToUserDetail(model.id, UserDetailRef.live);
      },
      margin: EdgeInsets.only(left: 20.w, right: 20.w),
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppCircleNetImage(
          borderWidth: 1.w,
          borderColor: Colors.white,
          imageUrl: model.avatar,
          size: 70.w,
        ),
        SizedBox(
          height: 12.h,
        ),
        Text(model.nickname ?? "",
            style: AppTheme()
                .textStyle(fontSize: 12.sp, color: AppTheme.colorTextWhite))
      ],
    );
  }
}
