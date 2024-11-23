import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/time_utils.dart';

import 'package:youyu/widgets/user/user_avatar_state_widget.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/visit.dart';
import 'package:youyu/modules/primary/mine/visit/widget/visit_head.dart';
import 'package:youyu/modules/primary/mine/visit/widget/visit_mask.dart';
import 'package:youyu/modules/primary/mine/visit/widget/vist_vip.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';
import 'package:youyu/widgets/app/other/app_segmentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'visit_logic.dart';

class VisitPage extends StatelessWidget {
  VisitPage({Key? key}) : super(key: key);

  final logic = Get.find<VisitLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<VisitLogic>(
      appBar: const AppTopBar(
        title: "来访",
      ),
      childBuilder: (s) {
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: AppColumn(
            margin: EdgeInsets.all(15.w),
            children: [
              VisitHead(
                countList: s.countList,
              ),
              if (!s.isVip)
                VisitMask(
                  maskList: s.maskList,
                ),
              if (s.isVip) _list(),
              if (!s.isVip)
                VisitVip(
                  onClick: s.updateVipState,
                )
            ],
          ),
        );
      },
    );
  }

  //被SingleChildScrollView嵌套，得设置高度
  _list() {
    return AppContainer(
      height: ScreenUtils.screenHeight -
          ScreenUtils.navbarHeight -
          75.w -
          30.h -
          ScreenUtils.safeBottomHeight,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      radius: 6.w,
      color: AppTheme.colorDarkBg,
      margin: EdgeInsets.only(top: 15.h),
      child: AppListSeparatedView(
        shrinkWrap: true,
        padding: EdgeInsets.only(
            top: 10.h, bottom: 10.h + ScreenUtils.safeBottomHeight),
        controller: logic.refreshController,
        itemCount: logic.dataList.length,
        isOpenLoadMore: true,
        isNoData: logic.isNoData,
        separatorBuilder: (_, int index) {
          return AppSegmentation(
            backgroundColor: AppTheme.colorDarkBg,
            height: 10.h,
          );
        },
        itemBuilder: (_, int index) {
          VisitInfo model = logic.dataList[index];
          return AppRow(
            onTap: () {
              UserController.to.pushToUserDetail(model.userInfo?.id, UserDetailRef.other);
            },
            height: 64.h,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              UserAvatarStateWidget(
                avatar: model.userInfo?.avatar ?? '',
                size: 48.w,
                userInfo: model.userInfo,
              ),
              SizedBox(
                width: 6.w,
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
                          model.userInfo?.nickname ?? "",
                          style: AppTheme().textStyle(
                              fontSize: 16.sp,
                              color: AppTheme.colorTextWhite),
                        ),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      AppLocalImage(
                        path: AppResource().girl,
                        width: 11.w,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    TimeUtils.ucTimeAgo((model.createTime ?? 0) * 1000),
                    style: AppTheme().textStyle(
                        fontSize: 12.sp,
                        color: AppTheme.colorTextSecond),
                  )
                ],
              )),
              Text(
                '${model.num ?? 0}次',
                style: AppTheme().textStyle(
                    fontSize: 16.sp, color: AppTheme.colorTextSecond),
              ),
            ],
          );
        },
        onRefresh: () {
          logic.pullRefresh();
        },
        onLoad: logic.loadMore,
      ),
    );
  }
}
