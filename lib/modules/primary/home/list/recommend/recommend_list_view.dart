import 'package:youyu/config/resource.dart';
import 'package:youyu/modules/primary/home/list/recommend/model/recommend_tabbar_jump_model.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:card_swiper/card_swiper.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/app_controller.dart';
import 'package:youyu/models/banner_model.dart';
import 'package:youyu/models/room_list_item.dart';
import 'package:youyu/modules/primary/home/list/recommend/widget/recommend_amusement_item.dart';
import 'package:youyu/modules/primary/home/list/recommend/widget/recommend_mark_item.dart';
import 'package:youyu/modules/primary/home/list/recommend/widget/recommend_title_widget.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/other/app_segmentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'model/recommend_amusement_model.dart';
import 'model/recommend_banner_model.dart';
import 'model/recommend_making_model.dart';
import 'recommend_list_logic.dart';
import 'package:youyu/widgets/page_life_state.dart';

class RecommendListPage extends StatefulWidget {
  const RecommendListPage({Key? key, required this.changeTabIndex})
      : super(key: key);
  final Function(int index) changeTabIndex;

  @override
  State<RecommendListPage> createState() => _RecommendListPageState();
}

class _RecommendListPageState extends PageLifeState<RecommendListPage>
    with AutomaticKeepAliveClientMixin {
  late RecommendListLogic logic = Get.find<RecommendListLogic>();

  @override
  void initState() {
    super.initState();
    Get.put<RecommendListLogic>(RecommendListLogic());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppPage<RecommendListLogic>(
      backgroundColor: Colors.transparent,
      childBuilder: (s) {
        return AppListSeparatedView(
          padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
          controller: s.refreshController,
          itemCount: s.allData.length,
          isOpenLoadMore: false,
          separatorBuilder: (_, int index) {
            return AppSegmentation(
              height: 10.h,
            );
          },
          itemBuilder: (_, int index) {
            var item = s.allData[index];
            if (item is RecommendBannerModel) {
              return _bannerWidget(item.bannerList);
            } else if (item is RecommendTabbarJumpModel) {
              return _tabBarJump();
            } else if (item is RecommendHotModel) {
              return _hotWidget(item);
            } else if (item is RecommendHomeModel) {
              return _recommendWidget(item);
            }
            return Container();
          },
          onRefresh: () {
            s.pullRefresh();
          },
        );
      },
    );
  }

  ///banner
  _bannerWidget(List<BannerModel> bannerList) {
    return SizedBox(
      height: 92.h,
      child: Swiper(
        scrollDirection: Axis.horizontal,
        // 横向
        itemCount: bannerList.length,
        autoplayDelay: 5000,
        autoplay: true,
        pagination: bannerList.length > 1
            ? const SwiperPagination(
                // 分页指示器
                alignment: Alignment.bottomCenter,
                // 位置 Alignment.bottomCenter 底部中间
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                // 距离调整
                builder: DotSwiperPaginationBuilder(
                    // 指示器构建
                    space: 5,
                    // 点之间的间隔
                    size: 8,
                    // 没选中时的大小
                    activeSize: 8,
                    // 选中时的大小
                    color: Colors.grey,
                    // 没选中时的颜色
                    activeColor: AppTheme.colorTextWhite))
            : null,
        outer: false,
        controller: logic.tzController,
        // 自动翻页
        itemBuilder: (BuildContext context, int index) {
          BannerModel model = bannerList[index];
          return AppContainer(
            onTap: () {
              AppController.to.onClickBanner(model);
            },
            margin: EdgeInsets.only(left: 14.w, right: 14.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.w),
              child: AppNetImage(
                imageUrl: model.img,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  // tab bar 跳转
  _tabBarJump() {
    return Container(
      margin: EdgeInsets.only(left: 14.w, right: 14.w),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 交友
              AppContainer(
                onTap: () {
                  widget.changeTabIndex(3);
                },
                child: AppLocalImage(
                  path: AppResource().homeTabBarJumpFriendship,
                  width: 174.w,
                ),
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // 酒吧
                  AppContainer(
                    onTap: () {
                      widget.changeTabIndex(2);
                    },
                    child: AppLocalImage(
                      path: AppResource().homeTabBarJumpBar,
                      width: 170.w,
                    ),
                  ),
                  SizedBox(height: 9.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 游戏
                      Expanded(
                        child: AppContainer(
                          onTap: () {
                            widget.changeTabIndex(4);
                          },
                          child: AppLocalImage(
                            path: AppResource().homeTabBarJumpGame,
                            width: 90.w,
                          ),
                        ),
                      ),
                      // 娱乐
                      Expanded(
                        child: AppContainer(
                          onTap: () {
                            widget.changeTabIndex(1);
                          },
                          child: AppLocalImage(
                            path: AppResource().homeTabBarJumpRecreation,
                            width: 90.w,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 唱歌
              AppContainer(
                onTap: () {
                  widget.changeTabIndex(5);
                },
                child: AppLocalImage(
                  path: AppResource().homeTabBarJumpSing,
                  width: 165.w,
                ),
              ),
              // 相亲
              AppContainer(
                onTap: () {
                  widget.changeTabIndex(6);
                },
                child: AppLocalImage(
                  path: AppResource().homeTabBarJumpBlingDate,
                  width: 181.w,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///推荐房间
  _recommendWidget(RecommendHomeModel model) {
    return Container(
      margin: EdgeInsets.only(left: 12.w, right: 12.w),
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(7.w)),
      padding: EdgeInsets.only(left: 0.w, right: 0.w),
      child: Column(
        children: [
          RecommendTitleWidget(
            title: model.title,
            image: model.image,
            onClick: () {
              // widget.changeTabIndex(1);
            },
          ),
          GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //水平子Widget之间间距
                crossAxisSpacing: 10.w,
                //垂直子Widget之间间距
                mainAxisSpacing: 11.w,
                //一行的Widget数量
                crossAxisCount: 2,
                //子Widget宽高比例
                childAspectRatio: 171 / 194,
              ),
              itemCount: model.list.length,
              itemBuilder: (BuildContext context, int index) {
                RoomListItem itemModel = model.list[index];
                return InkWell(
                  onTap: () {
                    LiveService().pushToLive(itemModel.id, itemModel.groupId);
                  },
                  child: RecommendAmusementItem(model: itemModel),
                );
              })
        ],
      ),
    );
  }

  ///热门房间
  _hotWidget(RecommendHotModel model) {
    return Container(
      margin: EdgeInsets.only(left: 12.w, right: 12.w),
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(7.w)),
      padding: EdgeInsets.only(left: 0.w, right: 0.w),
      child: Column(
        children: [
          RecommendTitleWidget(
            title: model.title,
            image: model.image,
            onClick: () {
              // widget.changeTabIndex(2);
            },
          ),
          GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //水平子Widget之间间距
                crossAxisSpacing: 8.w,
                //垂直子Widget之间间距
                mainAxisSpacing: 8.w,
                //一行的Widget数量
                crossAxisCount: 3,
                //子Widget宽高比例
                childAspectRatio: 171 / 194,
              ),
              itemCount: model.list.length,
              itemBuilder: (BuildContext context, int index) {
                RoomListItem itemModel = model.list[index];
                return InkWell(
                  onTap: () {
                    LiveService().pushToLive(itemModel.id, itemModel.groupId);
                  },
                  child: RecommendMarkItem(model: itemModel),
                );
              })
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void onPagePause() {}

  @override
  void onPageResume() {
    logic.fetchData();
  }
}
