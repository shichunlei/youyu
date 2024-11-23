import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/widgets/search/search_input_widget.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/conversation_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';
import 'package:youyu/widgets/app/other/app_load_footer.dart';
import 'package:youyu/widgets/app/other/app_segmentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'message_contact_sub_logic.dart';
import 'widget/message_contact_sub_item.dart';

class MessageContactSubPage extends StatefulWidget {
  const MessageContactSubPage({Key? key, required this.tabModel})
      : super(key: key);

  final TabModel tabModel;

  @override
  State<MessageContactSubPage> createState() => _MessageContactSubPageState();
}

class _MessageContactSubPageState extends State<MessageContactSubPage>
    with AutomaticKeepAliveClientMixin {
  late MessageContactSubLogic logic =
      Get.find<MessageContactSubLogic>(tag: widget.tabModel.id.toString());

  @override
  void initState() {
    super.initState();
    Get.put<MessageContactSubLogic>(MessageContactSubLogic(),
        tag: widget.tabModel.id.toString());
    logic.tabModel = widget.tabModel;
    logic.subRefreshController = RefreshController();
    logic.loadData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        _searchWidget(),
        SizedBox(
          height: 10.h,
        ),
        Expanded(
            child: AppPage<MessageContactSubLogic>(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          tag: widget.tabModel.id.toString(),
          childBuilder: (s) {
            return AppContainer(
              radius: 6.w,
              color: AppTheme.colorDarkBg,
              margin: EdgeInsets.symmetric(horizontal: 14.w),
              child: AppListSeparatedView(
                padding: EdgeInsets.zero,
                controller: s.subRefreshController,
                itemCount: s.dataList.length,
                isOpenLoadMore: true,
                isOpenRefresh: true,
                separatorBuilder: (_, int index) {
                  return AppSegmentation(
                    height: 0.5.h,
                    backgroundColor: AppTheme.colorLine,
                  );
                },
                itemBuilder: (_, int index) {
                  UserInfo userInfo = s.dataList[index];
                  return MessageContactSubItemWidget(
                    userInfo: userInfo,
                    onClickItem: () {
                      logic.onClickUser(userInfo);
                    },
                    onClickLive: (UserInfo? userInfo) {
                      ConversationController.to.pushToLive(userInfo);
                    },
                  );
                },
                onRefresh: logic.pullRefresh,
                onLoad: logic.loadMore,
                footer:
                    AppLoadMoreFooter.getFooter(isEmptyData: logic.isNoData),
                isNoData: logic.isNoData,
              ),
            );
          },
        )),
      ],
    );
  }

  _searchWidget() {
    return SearchInputWidget(
      controller: logic.controller,
      margin: EdgeInsets.only(top: 5.w, left: 14.w, right: 14.w),
      height: 38.h,
      placeHolder: '搜索用户昵称、ID或备注',
      enabled: true,
      onSubmitted: logic.onSubmitted,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
