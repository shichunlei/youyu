import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/modules/live/common/interactor/pop/link/user/live_link_user_logic.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/app/app_default.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';

class LiveLinkUserApplyPage extends StatefulWidget {
  const LiveLinkUserApplyPage({super.key, required this.roomId});

  final int roomId;

  @override
  State<LiveLinkUserApplyPage> createState() => _LiveLinkUserApplyPageState();
}

class _LiveLinkUserApplyPageState extends State<LiveLinkUserApplyPage> {
  final logic = Get.put(LiveLinkUserApplyLogic());

  @override
  void initState() {
    super.initState();
    logic.fetchList(widget.roomId);
  }

  @override
  Widget build(BuildContext context) {
    return AppPage<LiveLinkUserApplyLogic>(
      isUseScaffold: false,
      childBuilder: (s) {
        return AppListSeparatedView(
            itemCount: 0,
            controller: logic.refreshController,
            itemBuilder: (context, index) {
              return const SizedBox();
            },
            defaultConfig: AppDefaultConfig.defaultConfig(AppLoadType.empty,
                msg: "当前无人排队,赶快上麦吧!",
                margin: EdgeInsets.only(top: 35.h),
                size: 82.h),
            isNoData: logic.isNoData,
            separatorBuilder: (context, index) {
              return const SizedBox();
            });
      },
    );
  }
}
