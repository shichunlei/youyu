import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/models/localmodel/item_title_model.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///底部弹窗
class AppExtActionSheet {
  showSheet(
      {required AppWidgetTheme theme,
      required List<ItemTitleModel> actions,
      required Function(ItemTitleModel model) onClick}) {
    Get.bottomSheet(
        _ActionExtSheet(
          theme: theme,
          actions: actions,
          onClick: onClick,
        ),
        backgroundColor: Colors.transparent);
  }
}

class _ActionExtSheet extends StatelessWidget {
  const _ActionExtSheet(
      {required this.theme, required this.actions, required this.onClick});

  final List<ItemTitleModel> actions;
  final Function(ItemTitleModel model) onClick;
  final AppWidgetTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.w, right: 20.w),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
                color: theme == AppWidgetTheme.light
                    ? const Color(0xFFFFFFFF)
                    : AppTheme.colorDarkBg,
                borderRadius: BorderRadius.circular(10.w)),
            child: ListView.separated(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: actions.length,
                separatorBuilder: (context, index) {
                  return Container(
                    height: 1.h,
                    color: const Color(0x0D000000),
                  );
                },
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Get.back();
                      onClick(actions[index]);
                    },
                    child: _item(actions[index]),
                  );
                }),
          ),
          SizedBox(
            height: 20.h,
          ),
          AppColorButton(
            onClick: () {
              Get.back();
            },
            title: "取消",
            height: 52.h,
            borderRadius: BorderRadius.all(Radius.circular(10.w)),
            titleColor: theme == AppWidgetTheme.light
                ? AppTheme.colorTextPrimary
                : AppTheme.colorTextWhite,
            bgColor: theme == AppWidgetTheme.light
                ? const Color(0xFFFFFFFF)
                : AppTheme.colorDarkBg,
            fontSize: 15.sp,
          ),
          SizedBox(
            height: ScreenUtils.safeBottomHeight + 10.h,
          ),
        ],
      ),
    );
  }

  _item(ItemTitleModel model) {
    return SizedBox(
      height: 50.h,
      child: Center(
        child: Text(
          model.title,
          style: AppTheme().textStyle(
              color: theme == AppWidgetTheme.light
                  ? AppTheme.colorTextPrimary
                  : AppTheme.colorTextWhite),
        ),
      ),
    );
  }
}
