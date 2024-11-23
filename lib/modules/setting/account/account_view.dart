import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/models/localmodel/item_title_model.dart';
import 'package:youyu/controllers/auth_controller.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/app_round_container.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/dialog/app_tip_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widget/setting_index_item.dart';
import 'account_logic.dart';

class AccountPage extends StatelessWidget {
  AccountPage({Key? key}) : super(key: key);

  final logic = Get.find<AccountLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<AccountLogic>(
        appBar: const AppTopBar(
          title: "账号与安全",
        ),
        childBuilder: (s) {
          return Column(
            children: [
              AppRoundContainer(
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
                            logic.onClickItem(model);
                          },
                          child: SettingIndexItem(
                            model: model,
                          ),
                        );
                      })),
              SizedBox(
                height: 50.h,
              ),
              AppColorButton(
                margin: EdgeInsets.only(left: 15.w, right: 15.w),
                titleColor: AppTheme.colorTextWhite,
                title: "退出账号",
                fontSize: 18.sp,
                bgGradient: AppTheme().btnGradient,
                height: 50.h,
                onClick: () {
                  AppTipDialog().showTipDialog("提示", AppWidgetTheme.dark,
                      msg: "确定退出账号吗？", onCommit: () {
                    AuthController.to.logout(initiative: true);
                  });
                },
              ),
            ],
          );
        });
  }
}
