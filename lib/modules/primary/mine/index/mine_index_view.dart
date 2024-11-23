import 'package:youyu/utils/screen_utils.dart';
import 'package:card_swiper/card_swiper.dart';

import 'package:youyu/models/localmodel/menu_model.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/app_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/banner_model.dart';
import 'package:youyu/modules/index/widget/index_page_widget.dart';
import 'package:youyu/modules/primary/mine/index/widget/mine_index_data_widget.dart';
import 'package:youyu/modules/primary/mine/index/widget/mine_index_func_widget.dart';
import 'package:youyu/modules/primary/mine/index/widget/mine_index_item_widget.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'mine_index_logic.dart';
import 'widget/mine_index_core_widget.dart';
import 'widget/mine_index_header_widget.dart';
import 'package:youyu/widgets/page_life_state.dart';
class MineIndexPage extends IndexWidget {
  const MineIndexPage({Key? key}) : super(key: key);

  @override
  State<MineIndexPage> createState() => _MineIndexPageState();

  @override
  void onTabTap({param}) {
    //TODO:暂不操作刷新
  }
}

class _MineIndexPageState extends PageLifeState<MineIndexPage>
    with AutomaticKeepAliveClientMixin {
  final logic = Get.find<MineIndexLogic>();

  ///swiper
  final SwiperController tzController = SwiperController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppPage<MineIndexLogic>(
      childBuilder: (s) {
        return Container(
          padding: EdgeInsets.only(top: ScreenUtils.statusBarHeight),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ///头像header
                InkWell(
                  onTap: () {
                    s.pushToUserDetail();
                  },
                  child: const MineIndexHeaderWidget(),
                ),

                ///好友、访客等数据
                MineIndexDataWidget(
                  logic: logic,
                ),

                //TODO:暂时隐藏 vip
                /*
                MineIndexVipWidget(
                  onClickOpen: () {
                    logic.onOpenVip();
                  },
                ),
                 */
                Obx(() => _bannerWidget()),

                ///核心功能区
                MineIndexCoreIndex(
                  list: s.coreList,
                  onClick: (MenuModel model) {
                    s.onClickMenu(model);
                  },
                ),

                ///功能区
                MineIndexFuncWidget(
                  list: s.funcList,
                  onClick: (MenuModel model) {
                    s.onClickMenu(model);
                  },
                ),

                ///列表区
                MineIndexItemWidget(
                  list: s.itemList,
                  onClick: (MenuModel model) {
                    s.onClickMenu(model);
                  },
                ),
                SizedBox(
                  height: 12.h,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  ///banner
  _bannerWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.h),
      height: 92.h,
      child: Swiper(
        scrollDirection: Axis.horizontal,
        // 横向
        itemCount: AppController.to.bannerModel.value?.bannerList.length ?? 0,
        autoplayDelay: 5000,
        autoplay: true,
        pagination:
            (AppController.to.bannerModel.value?.bannerList.length ?? 0) > 1
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
        controller: tzController,
        // 自动翻页
        itemBuilder: (BuildContext context, int index) {
          BannerModel? model =
              AppController.to.bannerModel.value?.bannerList[index];
          if (model != null) {
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
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void onPagePause() {}

  @override
  void onPageResume() {
    //异步更新
    UserController.to.updateMyInfo();
  }
}
