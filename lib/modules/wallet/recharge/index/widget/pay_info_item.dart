import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/models/localmodel/item_title_model.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';

class PayInfoItem extends StatelessWidget {
  const PayInfoItem(
      {super.key,
      this.curSelModel,
      required this.model,
      required this.onClick});

  final ItemTitleModel model;
  final ItemTitleModel? curSelModel;
  final Function(ItemTitleModel model) onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick(model);
      },
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Padding(
            padding:
                EdgeInsets.only(left: 5.w, right: 5.w, top: 8.h, bottom: 5.h),
            child: mainCard(model: model, curSelModel: curSelModel),
          ),
          Positioned(
              top: 0.h,
              right: 0,
              child: AppContainer(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.h),
                gradient: AppTheme().btnGradient,
                topLeftRadius: 8.w,
                topRightRadius: 8.w,
                bottomRightRadius: 8.w,
                bottomLeftRadius: 1.w,
                child: Text("加赠${model.extra.toString()}豆",
                    style: AppTheme().textStyle(
                        fontSize: 10.sp, color: AppTheme.colorTextWhite)),
              ))
        ],
      ),
    );
  }
}

class mainCard extends StatelessWidget {
  const mainCard({
    super.key,
    required this.model,
    required this.curSelModel,
  });

  final ItemTitleModel model;
  final ItemTitleModel? curSelModel;

  @override
  Widget build(BuildContext context) {
    return AppColumn(
      radius: 6.w,
      strokeColor: model.title == (curSelModel?.title ?? 0)
          ? AppTheme.colorMain
          : Colors.transparent,
      strokeWidth: 1.w,
      color: model.title == (curSelModel?.title ?? 0)
          ? const Color(0xFF475739)
          : AppTheme.colorDarkLightBg,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppLocalImage(
          path: AppResource().coin2,
          width: 20.w,
          height: 20.w,
        ),
        SizedBox(
          height: 3.h,
        ),
        Text(
          model.title,
          style: AppTheme()
              .textStyle(fontSize: 16.sp, color: AppTheme.colorTextWhite),
        ),
        SizedBox(
          height: 3.h,
        ),
        Text("¥${model.subTitle}元",
            style: AppTheme()
                .textStyle(fontSize: 14.sp, color: AppTheme.colorTextSecond)),
      ],
    );
  }
}
