import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/app/app_default.dart';

import 'package:youyu/models/localmodel/image_model.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/button/app_image_button.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'user_image_logic.dart';

class UserImagePage extends StatefulWidget {
  const UserImagePage({Key? key, required this.isMine, required this.userId})
      : super(key: key);

  //是否是自己
  final bool isMine;
  final int userId;

  @override
  State<UserImagePage> createState() => _UserImagePageState();
}

class _UserImagePageState extends State<UserImagePage>
    with AutomaticKeepAliveClientMixin {
  final logic = Get.put(UserImageLogic());

  @override
  void initState() {
    super.initState();
    logic.isMine = widget.isMine;
    logic.userId = widget.userId;
    logic.fetchList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppPage<UserImageLogic>(
      isUseScaffold: false,
      childBuilder: (s) {
        return s.dataList.isNotEmpty
            ? GridView.builder(
                padding: EdgeInsets.only(
                    left: 24.w,
                    right: 24.w,
                    bottom: 10.h + ScreenUtils.safeBottomHeight),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //水平子Widget之间间距
                  crossAxisSpacing: 10.h,
                  //垂直子Widget之间间距
                  mainAxisSpacing: 10.h,
                  //一行的Widget数量
                  crossAxisCount: 3,
                  //子Widget宽高比例
                  childAspectRatio: 1,
                ),
                itemCount: s.dataList.length,
                itemBuilder: (BuildContext context, int index) {
                  ImageModel model = s.dataList[index];
                  return _imageWidget(model);
                })
            : _emptyWidget();
      },
    );
  }

  _imageWidget(ImageModel model) {
    switch (model.type) {
      case ImageModelType.normal:
        return AppNetImage(
          imageUrl: model.imageUrl,
          fit: BoxFit.cover,
          radius: BorderRadius.all(Radius.circular(8.w)),
          defaultWidget: AppTheme().defaultNewImage(color: AppTheme.colorDarkLightBg),
          errorWidget: AppTheme().defaultNewImage(color: AppTheme.colorDarkLightBg),
        );
      case ImageModelType.add:
        return AppLocalImage(
            onTap: () {
              logic.onAddImage();
              /*
              TODO:后面做
              if (UserController.to.isVip) {
                logic.onAddImage();
              } else {
                AppTipDialog().showTipDialog("提示", AppWidgetTheme.dark,
                    msg: "开通VIP可上传9张照片",
                    commitBtn: "去开通",
                    commitBtnColor: Color(0xFF000000),
                    onlyCommit: true);
              }
               */
            },
            path: AppResource().imgDarkAdd);
      case ImageModelType.sub:
        return AppLocalImage(
            onTap: () {
              logic.onAddImage();
            },
            path: AppResource().imDarkSub);
    }
  }

  _emptyWidget() {
    if (logic.isMine) {
      return AppColumn(
        mainAxisAlignment: MainAxisAlignment.center,
        width: double.infinity,
        height: double.infinity,
        children: [
          Text(
            '照片墙是空的呦～快去添加吧',
            style: AppTheme().textStyle(
                fontSize: 14.sp, color: AppTheme.colorTextSecond),
          ),
          SizedBox(
            height: 36.h,
          ),
          AppImageButton(
              path: AppResource().userImgAdd,
              width: 123.w,
              height: 42.h,
              onClick: () {
                logic.onAddImage();
              })
        ],
      );
    } else {
      return AppDefault(
          loadType: AppLoadType.empty,
          config: AppDefaultConfig(
              title: "暂无照片", image: AppResource().empty));
    }
  }

  @override
  bool get wantKeepAlive => true;
}
