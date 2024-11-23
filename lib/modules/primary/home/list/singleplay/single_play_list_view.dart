import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/room_list_item.dart';
import 'package:youyu/modules/primary/home/list/singleplay/model/single_play_hot_model.dart';
import 'package:youyu/modules/primary/home/list/singleplay/model/single_play_recommend_model.dart';
import 'package:youyu/modules/primary/home/list/singleplay/widget/single_play_five_widget.dart';
import 'package:youyu/modules/primary/home/list/singleplay/widget/single_play_item.dart';
import 'package:youyu/modules/primary/home/list/singleplay/widget/single_play_title_widget.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';
import 'package:youyu/widgets/app/other/app_segmentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'single_play_list_logic.dart';

class SinglePlayListPage extends StatefulWidget {
  const SinglePlayListPage({Key? key}) : super(key: key);

  @override
  State<SinglePlayListPage> createState() => _SinglePlayListPageState();
}

class _SinglePlayListPageState extends State<SinglePlayListPage>
    with AutomaticKeepAliveClientMixin {
  late SinglePlayListLogic logic = Get.find<SinglePlayListLogic>();

  @override
  void initState() {
    super.initState();
    Get.put<SinglePlayListLogic>(SinglePlayListLogic());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppPage<SinglePlayListLogic>(
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
            if (item is SinglePlayHotModel) {
              return _hotWidget(item);
            } else if (item is SinglePlayRecommendModel) {
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

  ///热门房间
  _hotWidget(SinglePlayHotModel model) {
    return Container(
      margin: EdgeInsets.only(left: 14.w, right: 14.w),
      decoration: BoxDecoration(
          color: AppTheme.colorDarkBg,
          borderRadius: BorderRadius.circular(7.w)),
      padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 20.h),
      child: Column(
        children: [
          SinglePlayTitleWidget(title: model.title, image: model.image),
          SinglePlayFiveWidget(roomList: model.fiveList),
          if (model.extraList.isNotEmpty) SizedBox(height: 7.h,),
          if (model.extraList.isNotEmpty) _commonListWidget(model.extraList)
        ],
      ),
    );
  }

  ///推荐房间
  _recommendWidget(SinglePlayRecommendModel model) {
    return Container(
      margin: EdgeInsets.only(left: 14.w, right: 14.w),
      decoration: BoxDecoration(
          color: AppTheme.colorDarkBg,
          borderRadius: BorderRadius.circular(7.w)),
      padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 20.h),
      child: Column(
        children: [
          SinglePlayTitleWidget(title: model.title, image: model.image),
          _commonListWidget(model.list)
        ],
      ),
    );
  }

  _commonListWidget(List<RoomListItem> list) {
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 3.w,right: 3.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //水平子Widget之间间距
          crossAxisSpacing: 7.w,
          //垂直子Widget之间间距
          mainAxisSpacing: 7.w,
          //一行的Widget数量
          crossAxisCount: 4,
          //子Widget宽高比例
          childAspectRatio: 75 / 75,
        ),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          RoomListItem itemModel = list[index];
          return InkWell(
            onTap: () {
              LiveService().pushToLive(itemModel.id, itemModel.groupId);
            },
            child: SinglePlayItem(model: itemModel, lockSize: 34.w, isShowTag: false,),
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
