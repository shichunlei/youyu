import 'package:youyu/config/resource.dart';
import 'package:youyu/modules/live/common/interactor/pop/user/Relation_Model.dart';
import 'package:youyu/modules/submod/user/detail/user_detail_logic.dart';
import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/list/app_grid_separated_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'user_relation_logic.dart';
import 'widget/user_relation_card_widget.dart';

class UserRelationPage extends StatefulWidget {
  const UserRelationPage({Key? key, required this.userId}) : super(key: key);

  final int userId;

  @override
  State<UserRelationPage> createState() => _UserRelationPageState();
}

class _UserRelationPageState extends State<UserRelationPage>
    with AutomaticKeepAliveClientMixin {
  final logic = Get.put(UserRelationLogic());

  @override
  void initState() {
    super.initState();
    logic.userId = widget.userId;
    logic.fetchList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppPage<UserRelationLogic>(
      isUseScaffold: false,
      childBuilder: (s) {
        return AppColumn(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppContainer(
                  height: 40.h,
                  margin: EdgeInsets.symmetric(horizontal: 12.w),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '限定关系',
                    style: AppTheme().textStyle(
                        fontSize: 14.sp, color: AppTheme.colorTextSecond),
                  ),
                ),
                AppContainer(
                  height: 40.h,
                  margin: EdgeInsets.symmetric(horizontal: 12.w),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '和他/她绑定限定关系',
                    style: AppTheme()
                        .textStyle(fontSize: 14.sp, color: AppTheme.colorMain),
                  ),
                ),
              ],
            ),
            Expanded(
                child: AppStack(
              alignment: Alignment.topCenter,
              children: [
                //背景
                Positioned(
                  top: 0,
                  child: AppLocalImage(
                    path: AppResource().mineRelationBg,
                    fit: BoxFit.fitWidth,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                //底部蒙版
                Positioned(
                    bottom: 0,
                    child: AppContainer(
                      color: const Color(0xff583B86),
                      width: MediaQuery.of(context).size.width,
                      height: 180.h,
                    )),
                //底部渐变蒙版
                Positioned(
                    bottom: 180.h,
                    child: AppContainer(
                      gradientBegin: Alignment.topCenter,
                      gradientEnd: Alignment.bottomCenter,
                      gradientStartColor: Colors.transparent,
                      gradientEndColor: const Color(0xff583B86),
                      // color: Color(0xff583B86),
                      width: MediaQuery.of(context).size.width,
                      height: 180.h,
                    )),
                //CP背景
                Positioned(
                  top: 66.h,
                  child: RelationBarwidget(s.userRelation?.cpInfo),
                ),
                Positioned(
                  top: 185.h,
                  child: SizedBox(
                    width: 343.w,
                    height: MediaQuery.of(context).size.height - 200.h,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: 200.h),
                      //todo 空安全处理
                      child: AppGridSeparatedView(
                        shrinkWrap: true,
                        // padding: EdgeInsets.only(
                        //     bottom: 10.h + ScreenUtils.safeBottomHeight,
                        //     left: 12.w,
                        //     right: 12.w),
                        controller: s.refreshController,
                        // todo 空安全处理
                        itemCount: s.userRelation!.relationList!.length,
                        isOpenLoadMore: false,
                        isOpenRefresh: false,
                        itemBuilder: (_, int index) {
                          RelationList itemModel =
                              s.userRelation!.relationList![index];
                          return UserRelationCardWidget(
                            index: index,
                            relationCard: itemModel,
                            onClick: () {
                              // logic.onClickGift(itemModel);
                            },
                          );
                        },
                        //水平子Widget之间间距
                        crossAxisSpacing: 10.w,
                        //垂直子Widget之间间距
                        mainAxisSpacing: 10.w,
                        //一行的Widget数量
                        crossAxisCount: 3,
                        //子Widget宽高比例
                        childAspectRatio: 108 / 127,
                        isNoData: s.isNoData,
                      ),
                    ),
                  ),
                )
              ],
            )),
            // Expanded(child: RelationGridView(logic: logic))
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class RelationBarwidget extends StatelessWidget {
  const RelationBarwidget(
    this.cpInfo, {
    super.key,
  });

  final CpInfo? cpInfo;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppContainer(
          margin: EdgeInsets.all(16.w),
          child: AppLocalImage(
            path: AppResource().mineRelationCpBg1,
            fit: BoxFit.fitWidth,
            width: 343.w,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _cpAvatar(
                  avatar: UserDetailLogic.to.targetUserInfo.value!.avatar!,
                  nickname: UserDetailLogic.to.targetUserInfo.value!.nickname!,
                ),
              ),
              cpInfo != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          cpInfo!.val.toString(),
                          textAlign: TextAlign.center,
                          style: AppTheme().textStyle(
                            color: AppTheme.colorTextWhite,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              Expanded(
                child: cpInfo != null
                    ? _cpAvatar(
                        avatar: cpInfo!.avatar!,
                        nickname: cpInfo!.nickname!,
                      )
                    : _relationEmpty(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _cpAvatar({required String avatar, required String nickname}) {
    return AppColumn(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppCircleNetImage(
          imageUrl: avatar,
          size: 41.w,
        ),
        SizedBox(
          height: 5.h,
        ),
        Text(
          nickname,
          style: AppTheme().textStyle(color: Colors.black, fontSize: 11.sp),
        )
      ],
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
}
