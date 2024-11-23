import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/room_list_item.dart';
import 'package:youyu/modules/submod/search/list/room/widget/search_room_item.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';
import 'package:youyu/widgets/app/other/app_segmentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'search_room_list_logic.dart';
///搜索房间列表
class SearchRoomListPage extends StatefulWidget {
  const SearchRoomListPage({Key? key, required this.list}) : super(key: key);

  final List<RoomListItem> list;

  @override
  State<SearchRoomListPage> createState() => _SearchRoomListPageState();
}

class _SearchRoomListPageState extends State<SearchRoomListPage> {
  late SearchRoomListLogic logic = Get.find<SearchRoomListLogic>();

  @override
  void initState() {
    super.initState();
    Get.put<SearchRoomListLogic>(SearchRoomListLogic());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppTheme.colorDarkBg,
          borderRadius: BorderRadius.circular(8.w)),
      margin: EdgeInsets.only(left: 14.w, right: 14.w),
      child: AppListSeparatedView(
        isOpenLoadMore: false,
        isOpenRefresh: false,
        padding: EdgeInsets.only(
            left: 10.w,
            right: 10.w,
            top: 12.w,
            bottom: 12.w + ScreenUtils.safeBottomHeight),
        itemBuilder: (context, index) {
          RoomListItem model = widget.list[index];
          return InkWell(
              onTap: () {
                LiveService().pushToLive(model.id,model.groupId);
              },
              child: SearchRoomItem(
                model: model,
              ));
        },
        separatorBuilder: (_, int index) {
          return AppSegmentation(
            height: 14.h,
            backgroundColor: AppTheme.colorDarkBg,
          );
        },
        itemCount: widget.list.length,
        controller: logic.refreshController,
      ),
    );
  }
}
