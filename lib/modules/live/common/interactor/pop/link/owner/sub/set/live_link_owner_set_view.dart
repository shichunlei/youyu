import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/modules/live/common/interactor/pop/link/owner/sub/set/live_link_owner_set_logic.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';

class LiveLinkOwnerSetPage extends StatefulWidget {
  const LiveLinkOwnerSetPage(
      {super.key, required this.tabModel, required this.roomId});

  final TabModel tabModel;
  final int roomId;

  @override
  State<LiveLinkOwnerSetPage> createState() => _LiveLinkOwnerSetPageState();
}

class _LiveLinkOwnerSetPageState extends State<LiveLinkOwnerSetPage> {
  final logic = Get.put(LiveLinkOwnerSetLogic());

  @override
  Widget build(BuildContext context) {
    return AppRow(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      alignment: Alignment.topCenter,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("连麦申请",
          style: AppTheme().textStyle(fontSize: 14.sp, color: Colors.white),),
        CupertinoSwitch(
            activeColor: AppTheme.colorMain,
            value: false,
            onChanged: (value) {
               logic.onSwitchLinkState(value);
            })
      ],
    );
  }
}
