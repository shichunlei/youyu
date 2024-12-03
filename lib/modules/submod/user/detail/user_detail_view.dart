import 'package:youyu/modules/submod/user/detail/sub/relation/user_relation_view.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/submod/user/detail/sub/dynamic/user_dynamic_view.dart';
import 'package:youyu/modules/submod/user/detail/sub/gift/user_gift_view.dart';
import 'package:youyu/modules/submod/user/detail/sub/image/user_image_view.dart';
import 'package:youyu/modules/submod/user/detail/widget/user_detail_footer.dart';
import 'package:youyu/modules/submod/user/detail/widget/user_detail_header.dart';
import 'package:youyu/modules/submod/user/detail/widget/user_detail_tab_bar.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/widgets/top_bg/top_ba.dart';
import 'user_detail_logic.dart';

class UserDetailPage extends StatelessWidget {
  UserDetailPage({Key? key}) : super(key: key);

  final logic = Get.find<UserDetailLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<UserDetailLogic>(
      topBg: const TopBgMe(),
      childBuilder: (s) {
        return Stack(
          children: [
            _contentWidget(),
            if (!s.isMine)
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: ScreenUtils.safeBottomHeight + 18.h,
                  child: UserDetailFooter(
                    logic: logic,
                  )),
          ],
        );
      },
    );
  }

  ///滑动内容
  _contentWidget() {
    return ExtendedNestedScrollView(
      headerSliverBuilder: (BuildContext c, bool f) {
        return [
          // appbar
          Obx(
            () => SliverAppBar(
              backgroundColor: AppTheme.colorBg,
              leading: _leading(),
              actions: [_rightAction()],
              elevation: 0,
              pinned: true,
              floating: false,
              expandedHeight: UserDetailLogic.headerHeightWithOutStatus +
                  UserDetailLogic.tabBarTopRadius,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Stack(
                  children: [
                    ///头像背景
                    ShaderMask(
                      shaderCallback: (rect) {
                        return const LinearGradient(
                                colors: [
                              Color.fromRGBO(0, 0, 0, 0.5),
                              Color.fromRGBO(0, 0, 0, 0.5),
                            ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter)
                            .createShader(rect);
                      },
                      blendMode: BlendMode.dstIn,
                      child: AppNetImage(
                        imageUrl: logic.targetUserInfo.value?.avatar ?? "",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: UserDetailLogic.headerHeightWithOutStatus +
                            ScreenUtils.statusBarHeight +
                            UserDetailLogic.tabBarTopRadius,
                      ),
                    ),

                    ///header
                    logic.targetUserInfo.value != null
                        ? UserDetailHeader(
                            targetUserInfo: logic.targetUserInfo.value,
                            height: UserDetailLogic.headerHeightWithOutStatus +
                                ScreenUtils.statusBarHeight,
                            onClickHead: () {
                              logic.onClickPersonEdit();
                            },
                          )
                        : SizedBox(
                            height: UserDetailLogic.headerHeightWithOutStatus +
                                ScreenUtils.statusBarHeight,
                          ),

                    ///圆角
                    Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: AppContainer(
                          height: UserDetailLogic.tabBarTopRadius / 2,
                          width: double.infinity,
                          topRightRadius: UserDetailLogic.tabBarTopRadius / 2,
                          topLeftRadius: UserDetailLogic.tabBarTopRadius / 2,
                          color: AppTheme.colorBg,
                        ))
                  ],
                ),
              ),
            ),
          )
        ];
      },
      pinnedHeaderSliverHeightBuilder: () {
        return ScreenUtils.statusBarHeight + ScreenUtils.navbarHeight;
      },
      onlyOneScrollInBody: true,
      body: Column(
        children: <Widget>[
          ///tabBar
          UserDetailTabBar(
            tabs: logic.tabs,
            tabController: logic.tabController,
          ),

          ///内容
          Expanded(
              child: TabBarView(
                  controller: logic.tabController,
                  children: logic.tabs.map((e) {
                    switch (e.id) {
                      case 0:
                        return UserDynamicPage(
                          userId: logic.userId,
                          ref: logic.ref,
                        );
                      case 1:
                        return UserImagePage(
                          isMine: logic.isMine,
                          userId: logic.userId,
                        );
                      case 2:
                        return UserGiftPage(
                          userId: logic.userId,
                        );
                      case 3:
                        return UserRelationPage(
                          userId: logic.userId,
                        );
                    }
                    return Container();
                  }).toList()))
        ],
      ),
    );
  }

  /// 左边返回
  _leading() {
    return AppContainer(
      margin: EdgeInsets.only(left: 15.w),
      width: ScreenUtils.navbarHeight,
      onTap: () {
        Get.back();
      },
      color: Colors.transparent,
      alignment: Alignment.centerLeft,
      height: ScreenUtils.navbarHeight,
      child: Image.asset(
        AppResource().back,
        width: 20 / 2,
        height: 37 / 2,
      ),
    );
  }

  ///右边按钮
  _rightAction() {
    return AppContainer(
      margin: EdgeInsets.only(right: 18.w),
      width: ScreenUtils.navbarHeight,
      onTap: logic.onClickRight,
      color: Colors.transparent,
      alignment: Alignment.centerRight,
      height: ScreenUtils.navbarHeight,
      child:
          //TODO:暂时隐藏
          logic.isMine
              ? Container()
              : Image.asset(
                  AppResource().more,
                  width: 18,
                  height: 18,
                  fit: BoxFit.contain,
                ),
    );
  }
}
