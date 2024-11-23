import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/widgets/search/search_input_widget.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/modules/live/common/interactor/pop/userlist/sub/online/item/live_pop_user_online_item.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';
import 'package:youyu/widgets/app/other/app_segmentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'live_pop_user_on_line_logic.dart';

class LivePopUserOnLinePage extends StatefulWidget {
  const LivePopUserOnLinePage(
      {Key? key,
      required this.tabModel,
      required this.roomId,
      required this.onClickMore,
      required this.onlineUserList,
      required this.isOwner,
      required this.isManager})
      : super(key: key);

  final Function(UserInfo userInfo) onClickMore;
  final TabModel tabModel;
  final int roomId;
  final bool isOwner;
  final bool isManager;
  final List<UserInfo> onlineUserList;

  @override
  State<LivePopUserOnLinePage> createState() => LivePopUserOnLinePageState();
}

class LivePopUserOnLinePageState extends State<LivePopUserOnLinePage>
    with AutomaticKeepAliveClientMixin {
  final logic = Get.put(LivePopUserOnLineLogic());

  @override
  void initState() {
    super.initState();
    logic.fetchData(widget.onlineUserList);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppPage<LivePopUserOnLineLogic>(
      isUseScaffold: false,
      childBuilder: (s) {
        return Column(
          children: [
            _searchWidget(),
            SizedBox(
              height: 5.h,
            ),
            Expanded(child: GetBuilder<LivePopUserOnLineLogic>(
              builder: (s) {
                return AppListSeparatedView(
                  padding:
                      EdgeInsets.only(bottom: ScreenUtils.safeBottomHeight),
                  controller: s.refreshController,
                  itemCount: s.dataList.length,
                  isOpenLoadMore: false,
                  isOpenRefresh: false,
                  isNoData: logic.isNoData,
                  separatorBuilder: (_, int index) {
                    return AppSegmentation(
                      height: 1.h,
                      backgroundColor: AppTheme.colorLine,
                    );
                  },
                  itemBuilder: (_, int index) {
                    return LivePopUserOnLineItem(
                        index: index,
                        isOwner: widget.isOwner,
                        isManager: widget.isManager,
                        model: s.dataList[index],
                        onClickMore: () {
                          widget.onClickMore(s.dataList[index]);
                        });
                  },
                );
              },
            ))
          ],
        );
      },
    );
  }

  _searchWidget() {
    return Container(
      margin: EdgeInsets.only(left: 20.w, right: 20.w),
      child: Row(
        children: [
          Expanded(
              child: SearchInputWidget(
                  height: 34.h,
                  backgroundColor: const Color(0xFF000000),
                  onClickClear: logic.onClickClear,
                  onSubmitted: (text) {
                    logic.onSubmitted();
                  },
                  placeHolder: '输入用户ID或昵称',
                  controller: logic.controller)),
          SizedBox(
            width: 10.w,
          ),
          AppColorButton(
            onClick: () {
              logic.onSubmitted();
            },
            title: "确定",
            width: 78.w,
            height: 34.h,
            titleColor: const Color(0xFF000000),
            bgGradient: AppTheme().btnGradient,
          )
        ],
      ),
    );
  }

  updateForbidUserInfo(int type, UserInfo userInfo) {
    if (type == 2) {
      logic.dataList.removeWhere((element) => element.id == userInfo.id);
    }
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}
