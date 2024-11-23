import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/models/localmodel/item_title_model.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/setting/widget/setting_index_item.dart';
import 'package:youyu/widgets/app/app_round_container.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'setting_index_logic.dart';

class SettingIndexPage extends StatelessWidget {
  SettingIndexPage({Key? key}) : super(key: key);

  final logic = Get.find<SettingIndexLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<SettingIndexLogic>(
      appBar: const AppTopBar(
        title: "设置",
      ),
      childBuilder: (s) {
        return AppRoundContainer(
            alignment: Alignment.center,
            height: 54.h * logic.itemList.length,
            borderRadius: BorderRadius.all(Radius.circular(8.w)),
            bgColor: AppTheme.colorDarkBg,
            margin: EdgeInsets.only(top: 15.h, left: 14.w, right: 14.w),
            child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: logic.itemList.length,
                itemBuilder: (context, index) {
                  ItemTitleModel model = logic.itemList[index];
                  return InkWell(
                    onTap: () {
                      logic.onClick(model);
                    },
                    child: SettingIndexItem(
                      model: model,
                    ),
                  );
                }));
      },
    );
  }
}
