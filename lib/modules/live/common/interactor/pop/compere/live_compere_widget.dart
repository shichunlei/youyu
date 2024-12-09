import 'package:get/get.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/modules/live/common/interactor/pop/compere/set/live_compere_set_view.dart';
import 'package:youyu/modules/live/common/notification/live_setting_notify.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_default.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:flutter/material.dart';
import 'package:youyu/widgets/app/app_round_container.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';
import 'package:youyu/widgets/user/user_info_widget.dart';
import 'live_compere_logic.dart';

///主持列表
class LiveCompereWidget extends StatefulWidget {
  const LiveCompereWidget({
    super.key,
    required this.roomId,
    required this.settingNotify,
  });

  final int roomId;
  final LiveSettingNotify settingNotify;

  @override
  State<LiveCompereWidget> createState() => LiveCompereWidgetState();
}

class LiveCompereWidgetState extends State<LiveCompereWidget> {
  final logic = Get.put(LiveCompereLogic());

  @override
  void initState() {
    super.initState();
    logic.roomId = widget.roomId;
    logic.settingNotify = widget.settingNotify;
    logic.fetchList();
  }

  @override
  Widget build(BuildContext context) {
    return AppPage<LiveCompereLogic>(
      isUseScaffold: false,
      backgroundColor: Colors.transparent,
      bodyHeight: 523.h,
      childBuilder: (s) {
        return AppRoundContainer(
            padding: EdgeInsets.zero,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.w),
                topRight: Radius.circular(12.w)),
            bgColor: AppTheme.colorDarkBg,
            height: 523.h,
            child: Column(
              children: [
                _navWidget(),
                Expanded(
                    child: AppListSeparatedView(
                        isOpenRefresh: false,
                        isOpenLoadMore: false,
                        itemCount: logic.dataList.length,
                        controller: logic.refreshController,
                        itemBuilder: (context, index) {
                          return _itemWidget(logic.dataList[index]);
                        },
                        defaultConfig: AppDefaultConfig.defaultConfig(
                            AppLoadType.empty,
                            msg: "暂无数据",
                            size: 82.h),
                        isNoData: logic.isNoData,
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 8.h,
                          );
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
      height: 58.h,
      children: [
        AppContainer(
          padding: EdgeInsets.only(left: 20.w),
          alignment: Alignment.centerLeft,
          onTap: () {
            Get.back();
          },
          width: (76 + 15).w,
          height: 28.h,
          child: AppLocalImage(
            path: AppResource().back,
            width: 20 / 2,
            height: 37 / 2,
          ),
        ),
        Text(
          "主持人",
          style: AppTheme().textStyle(fontSize: 18.sp, color: Colors.white),
        ),
        AppContainer(
          margin: EdgeInsets.only(right: 15.w),
          radius: 99,
          gradient: AppTheme().btnGradient,
          onTap: () {
            Get.bottomSheet(LiveCompereSetPage(
              roomId: logic.roomId,
              settingNotify: logic.settingNotify,
              hasDataList: logic.dataList,
              onAdd: (UserInfo model) {
                logic.isNoData = logic.dataList.isEmpty;
                logic.setSuccessType();
              },
              onRemove: (UserInfo model) {
                logic.dataList.removeWhere((element) => element.id == model.id);
                logic.isNoData = logic.dataList.isEmpty;
                logic.setSuccessType();
              },
            ));
          },
          width: 76.w,
          height: 28.h,
          child: Center(
              child: Text(
            "添加主持人",
            style: AppTheme().textStyle(fontSize: 12.sp, color: Colors.white),
          )),
        )
      ],
    );
  }

  ///item
  _itemWidget(UserInfo model) {
    return AppRow(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      radius: 10.w,
      height: 90.h,
      color: const Color(0xFF090909),
      children: [
        SizedBox(
          width: 13.w,
        ),
        AppCircleNetImage(
          imageUrl: model.avatar,
          size: 55.w,
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
                viewType: UserInfoViewType.light,
                isHighFancyNum: model.isHighFancyNum,
                name: model.nickname ?? "",
                sex: model.gender,
              ),
              SizedBox(
                height: 10.h,
              ),
              RichText(
                  text: TextSpan(
                text: "总热度 ",
                style: AppTheme()
                    .textStyle(color: const Color(0xFF999999), fontSize: 14.sp),
                children: <TextSpan>[
                  TextSpan(
                      style: AppTheme()
                          .textStyle(color: Colors.white, fontSize: 14.sp),
                      text: "${model.focusMeCount}"),
                  TextSpan(
                    style: AppTheme().textStyle(
                        color: const Color(0xFF999999), fontSize: 14.sp),
                    text: "   比例 ",
                  ),
                  TextSpan(
                    style: AppTheme()
                        .textStyle(color: Colors.white, fontSize: 14.sp),
                    text: "${model.proportion ?? "0"}%",
                  ),
                ],
              )),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AppContainer(
              onTap: () {
                logic.setProportion(model);
              },
              topLeftRadius: 99,
              bottomLeftRadius: 99,
              gradient: AppTheme().btnGradient,
              width: 62.w,
              height: 24.h,
              child: Center(
                child: Text(
                  '设置比例',
                  style: AppTheme().textStyle(
                      fontSize: 12.sp, color: const Color(0xFF1D1817)),
                ),
              ),
            ),
            SizedBox(
              height: 7.h,
            ),
            AppContainer(
              onTap: () {
                logic.onCancelManager(model);
              },
              topLeftRadius: 99,
              bottomLeftRadius: 99,
              strokeWidth: 1.w,
              strokeColor: AppTheme.colorMain,
              width: 47.w,
              height: 24.h,
              child: Center(
                child: Text(
                  '移除',
                  style: AppTheme()
                      .textStyle(fontSize: 12.sp, color: AppTheme.colorMain),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
