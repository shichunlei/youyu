import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/app/app_default.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';
import 'live_link_owner_apply_logic.dart';

class LiveLinkOwnerApplyPage extends StatefulWidget {
  const LiveLinkOwnerApplyPage(
      {super.key, required this.tabModel, required this.roomId});

  final TabModel tabModel;
  final int roomId;

  @override
  State<LiveLinkOwnerApplyPage> createState() => _LiveLinkOwnerApplyPageState();
}

class _LiveLinkOwnerApplyPageState extends State<LiveLinkOwnerApplyPage> {
  final logic = Get.put(LiveLinkOwnerApplyLogic());

  @override
  void initState() {
    super.initState();
    logic.fetchList(widget.roomId);
  }

  @override
  Widget build(BuildContext context) {
    return AppPage<LiveLinkOwnerApplyLogic>(
      isUseScaffold: false,
      childBuilder: (s) {
        return AppListSeparatedView(
            itemCount: 0,
            controller: logic.refreshController,
            itemBuilder: (context, index) {
              return const SizedBox();
            },
            defaultConfig: AppDefaultConfig.defaultConfig(AppLoadType.empty,
                msg: "暂无数据", margin: EdgeInsets.only(top: 35.h), size: 82.h),
            isNoData: logic.isNoData,
            separatorBuilder: (context, index) {
              return const SizedBox();
            });
      },
    );
  }
}
