import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/modules/live/common/notification/live_setting_notify.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_default.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_round_container.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';
import 'package:youyu/widgets/user/user_info_widget.dart';
import 'live_compere_set_logic.dart';

class LiveCompereSetPage extends StatefulWidget {
  const LiveCompereSetPage(
      {Key? key,
      required this.roomId,
      required this.settingNotify,
      required this.hasDataList,
      required this.onAdd,
      required this.onRemove})
      : super(key: key);
  final int roomId;
  final LiveSettingNotify settingNotify;
  final List<UserInfo> hasDataList;
  final Function(UserInfo model) onAdd;
  final Function(UserInfo model) onRemove;

  @override
  State<LiveCompereSetPage> createState() => _LiveCompereSetPageState();
}

class _LiveCompereSetPageState extends State<LiveCompereSetPage> {
  final logic = Get.put(LiveCompereSetLogic());

  @override
  void initState() {
    super.initState();
    logic.roomId = widget.roomId;
    logic.settingNotify = widget.settingNotify;
    logic.hasDataList = widget.hasDataList;
    logic.onAdd = widget.onAdd;
    logic.onRemove = widget.onRemove;
    logic.fetchList();
  }

  @override
  Widget build(BuildContext context) {
    return AppPage<LiveCompereSetLogic>(
      isUseScaffold: false,
      backgroundColor: Colors.transparent,
      bodyHeight: 414.h,
      childBuilder: (s) {
        return AppRoundContainer(
            padding: EdgeInsets.zero,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.w),
                topRight: Radius.circular(12.w)),
            bgColor: AppTheme.colorDarkBg,
            height: 414.h,
            child: Column(
              children: [
                _navWidget(),
                Expanded(
                    child: AppListSeparatedView(
                        isOpenRefresh: false,
                        isOpenLoadMore: false,
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        itemCount: logic.dataList.length,
                        controller: logic.refreshController,
                        itemBuilder: (context, index) {
                          return _itemWidget(logic.dataList[index]);
                        },
                        defaultConfig: AppDefaultConfig.defaultConfig(
                            AppLoadType.empty,
                            msg: "暂无数据",
                            margin: EdgeInsets.only(top: 70.h),
                            size: 82.h),
                        isNoData: logic.isNoData,
                        separatorBuilder: (context, index) {
                          return const SizedBox.shrink();
                        }))
              ],
            ));
      },
    );
  }

  ///导航
  _navWidget() {
    return AppRow(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      width: double.infinity,
      height: 44.h,
      children: [
        SizedBox(
          width: 50.w,
        ),
        Text(
          "主持设置",
          style: AppTheme().textStyle(fontSize: 18.sp, color: Colors.white),
        ),
        AppContainer(
          onTap: () {
            Get.back();
          },
          width: 50.w,
          child: Center(
            child: AppLocalImage(
              path: AppResource().close,
              width: 12.w,
            ),
          ),
        )
      ],
    );
  }

  ///item list
  _itemWidget(LiveCompereSetModel sModel) {
    return AppColumn(
      children: [
        AppContainer(
          width: double.infinity,
          height: 44.h,
          child: Text(
            sModel.type == 1 ? '添加主持' : '已有主持',
            style: AppTheme().textStyle(fontSize: 14.sp, color: Colors.white),
          ),
        ),
        ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              UserInfo model = sModel.list[index];
              return AppRow(
                children: [
                  AppCircleNetImage(
                    imageUrl: model.avatar,
                    size: 46.w,
                    borderWidth: 1.w,
                    borderColor: AppTheme.colorTextWhite,
                  ),
                  SizedBox(
                    width: 10.h,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        UserInfoWidget(
                          isHighFancyNum: model.isHighFancyNum,
                          name: model.nickname ?? "",
                          sex: model.gender,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          "ID：${model.fancyNumber}",
                          style: AppTheme().textStyle(
                              fontSize: 14.sp, color: AppTheme.colorTextSecond),
                        ),
                      ],
                    ),
                  ),
                  sModel.type == 1
                      ? AppColorButton(
                          title: "添加主持",
                          width: 62.w,
                          height: 24.h,
                          padding: EdgeInsets.zero,
                          fontSize: 12.sp,
                          bgGradient: AppTheme().btnGradient,
                          titleColor: AppTheme.colorTextWhite,
                          onClick: () {
                            logic.onSetManager(model);
                          },
                        )
                      : AppColorButton(
                          title: "取消主持",
                          width: 62.w,
                          height: 24.h,
                          padding: EdgeInsets.zero,
                          fontSize: 12.sp,
                          titleColor: AppTheme.colorMain,
                          borderColor: AppTheme.colorMain,
                          onClick: () {
                            logic.onCancelManager(model);
                          },
                        )
                ],
              );
            },
            separatorBuilder: (context, index) {
              return Container(
                  height: 0.5.h,
                  width: double.infinity,
                  color: AppTheme.colorLine);
            },
            itemCount: sModel.list.length)
      ],
    );
  }
}
