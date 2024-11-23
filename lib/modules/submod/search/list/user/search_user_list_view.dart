import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';
import 'package:youyu/widgets/app/other/app_segmentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'search_user_list_logic.dart';
import 'widget/search_user_item.dart';

///搜索用户列表
class SearchUserListPage extends StatefulWidget {
  const SearchUserListPage({Key? key, required this.list}) : super(key: key);

  final List<UserInfo> list;

  @override
  State<SearchUserListPage> createState() => _SearchUserListPageState();
}

class _SearchUserListPageState extends State<SearchUserListPage> {
  late SearchUserListLogic logic = Get.find<SearchUserListLogic>();

  @override
  void initState() {
    super.initState();
    Get.put<SearchUserListLogic>(SearchUserListLogic());
    logic.list = widget.list;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchUserListLogic>(builder: (s) {
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
            UserInfo model = logic.list[index];
            return InkWell(
                onTap: () {
                  UserController.to
                      .pushToUserDetail(model.id ?? 0, UserDetailRef.other);
                },
                child: SearchUserItem(
                  model: model,
                  onClickFocus: logic.onClickFocus,
                ));
          },
          separatorBuilder: (_, int index) {
            return AppSegmentation(
              height: 10.h,
              backgroundColor: AppTheme.colorDarkBg,
            );
          },
          itemCount: logic.list.length,
          controller: logic.refreshController,
        ),
      );
    });
  }
}
