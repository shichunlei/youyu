import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/widgets/discover/discover_item.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/controllers/dynamic_controller.dart';
import 'package:youyu/modules/primary/discover/detail/widget/discover_detail_bottom.dart';
import 'package:youyu/modules/primary/discover/detail/widget/discover_detail_comment.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';
import 'package:youyu/widgets/app/other/app_emoji_widget.dart';
import 'package:youyu/widgets/app/other/app_load_footer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../config/theme.dart';
import 'discover_detail_logic.dart';

class DiscoverDetailPage extends StatefulWidget {
  const DiscoverDetailPage({Key? key}) : super(key: key);

  @override
  State<DiscoverDetailPage> createState() => _DiscoverDetailPageState();
}

class _DiscoverDetailPageState extends State<DiscoverDetailPage>
    with WidgetsBindingObserver {
  final logic = Get.find<DiscoverDetailLogic>();
  bool isDispose = false;
  late AppEmojiWidget emojiWidget;

  @override
  void initState() {
    super.initState();
    logic.refreshController = RefreshController();
    //初始化
    WidgetsBinding.instance.addObserver(this);
    emojiWidget = AppEmojiWidget(
      onBackspacePressed:(){},
      editingController: logic.textController,
    );
  }

  // 监听
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !isDispose) {
        double bottom = MediaQuery.of(context).viewInsets.bottom;
        logic.onKeyBoardChange(bottom);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppStack(
      children: [
        AppPage<DiscoverDetailLogic>(
            resizeToAvoidBottomInset: false,
            appBar: AppTopBar(
              title: "动态详情",
              rightAction: AppContainer(
                width: 40.w,
                height: 40.h,
                onTap: () {
                  DynamicController.to.onClickMore(logic.detailModel);
                },
                child: Center(
                  child: AppLocalImage(
                    height: 4.h,
                    width: 18.w,
                    path: AppResource().more2,
                  ),
                ),
              ),
            ),
            childBuilder: (s) {
              //评论列表
              return _commentList();
            }),
        //mask
        Obx(() => logic.state != DiscoverDetailInputState.none
            ? AppContainer(
                onTap: () {
                  logic.onClickMaskNone();
                },
                color: const Color(0x66000000),
                width: double.infinity,
                height: ScreenUtils.screenHeight - ScreenUtils.navbarHeight,
              )
            : const SizedBox.shrink()),
        //底部input
        _bottomInput(),
        //底部emoji
        _bottomEmoji(),
        //底部占位
        _bottomSpace()
      ],
    );
  }

  ///评论列表
  _commentList() {
    return Positioned(
        bottom: 76.h + ScreenUtils.safeBottomHeight,
        left: 0,
        right: 0,
        top: 0,
        child: AppListSeparatedView(
          padding:
              EdgeInsets.only(top: 10.h, bottom: ScreenUtils.safeBottomHeight),
          controller: logic.refreshController,
          itemCount: 2,
          isOpenLoadMore: true,
          isOpenRefresh: false,
          footer: AppLoadMoreFooter.getFooter(isEmptyData: logic.isNoData),
          onLoad: logic.loadMore,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(children: [
                DisCoverItemWidget(
                  model: logic.detailModel,
                  index: 0,
                  ref: DisCoverItemRef.listDetail,
                ),
                Container(
                  margin: EdgeInsets.only(top: 14.h),
                  width: double.infinity,
                  height: 8.h,
                  color: const Color(0xFF000000),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15.w, top: 14.h),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '评论 ${logic.commentList.length}',
                    style: AppTheme().textStyle(
                        fontSize: 14.sp, color: AppTheme.colorTextWhite),
                  ),
                ),
              ]);
            } else {
              return logic.commentList.isNotEmpty
                  ? DiscoverDetailComment(
                      logic: logic,
                    )
                  : AppContainer(
                      width: double.infinity,
                      height: 150.h,
                      child: Center(
                        child: Text(
                          '暂无评论～',
                          style: AppTheme().textStyle(
                              fontSize: 14.sp,
                              color: AppTheme.colorTextSecond),
                        ),
                      ),
                    );
            }
          },
          separatorBuilder: (context, index) {
            return const SizedBox.shrink();
          },
        ));
  }

  ///底部input
  _bottomInput() {
    return Positioned(
        bottom: ScreenUtils.safeBottomHeight,
        left: 0,
        right: 0,
        child: AppColumn(
          onTap: () {
            //...
          },
          children: [
            DiscoverDetailBottom(
              height: 76.h,
              logic: logic,
              controller: logic.textController,
              onClickAt: logic.onClickAt,
              onClickEmoji: logic.onClickEmoji,
              onSendComment: logic.onSendComment,
            ),
            Obx(() => AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Container(
                  color: AppTheme.colorDarkBg,
                  height: logic.inputBottomHeight.value,
                )))
          ],
        ));
  }

  ///底部
  _bottomEmoji() {
    return Positioned(
      bottom: ScreenUtils.safeBottomHeight,
      left: 0,
      right: 0,
      child: _emojiWidget(),
    );
  }

  _emojiWidget() {
    return Obx(() => AnimatedSize(
          duration: logic.beforeState == DiscoverDetailInputState.text
              ? const Duration(milliseconds: 10)
              : const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: SizedBox(
            width: double.infinity,
            height: (logic.state == DiscoverDetailInputState.emoji)
                ? logic.emojiHeight
                : 0,
            child: emojiWidget,
          ),
        ));
  }

  ///底部占位
  _bottomSpace() {
    return Positioned(
        right: 0,
        left: 0,
        bottom: 0,
        child: Container(
          height: ScreenUtils.safeBottomHeight,
          color: AppTheme.colorDarkBg,
        ));
  }

  @override
  void dispose() {
    isDispose = true;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
