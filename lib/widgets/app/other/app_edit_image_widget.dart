import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/models/localmodel/image_model.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:flutter/material.dart';

///编辑的图片
class AppEditImageWidget extends StatelessWidget {
  const AppEditImageWidget(
      {super.key,
      required this.imageModel,
      this.isShowDel = true,
      this.onClickAdd,
      this.onClickSub,
      this.onClickDel,
      this.imageAdd});

  //是否显示删除
  final bool isShowDel;

  //图片信息
  final ImageModel imageModel;

  //点击添加
  final Function? onClickAdd;

  //点击移除
  final Function? onClickSub;

  //添加的图片
  final String? imageAdd;

  //点击删除
  final Function(ImageModel imageModel)? onClickDel;

  @override
  Widget build(BuildContext context) {
    switch (imageModel.type) {
      case ImageModelType.normal:
        return AppStack(
          width: double.infinity,
          height: double.infinity,
          children: [
            AppNetImage(
              width: double.infinity,
              height: double.infinity,
              imageUrl: imageModel.imageUrl,
              fit: BoxFit.cover,
              radius: BorderRadius.all(Radius.circular(8.w)),
              defaultWidget: AppTheme().defaultNewImage(color: AppTheme.colorDarkLightBg),
              errorWidget: AppTheme().defaultNewImage(color: AppTheme.colorDarkLightBg),
            ),
            Positioned(
                right: 0,
                child: AppContainer(
                  onTap: () {
                    if (onClickDel != null) {
                      onClickDel!(imageModel);
                    }
                  },
                  width: 20.w,
                  height: 20.w,
                  child: Center(
                    child: AppLocalImage(
                      path: AppResource().imgDel,
                      width: 14.w,
                    ),
                  ),
                ))
          ],
        );
      case ImageModelType.add:
        return AppLocalImage(
            onTap: () {
              if (onClickAdd != null) {
                onClickAdd!();
              }
            },
            path: imageAdd ?? AppResource().imgDarkAdd);
      case ImageModelType.sub:
        return AppLocalImage(
            onTap: () {
              if (onClickSub != null) {
                onClickSub!();
              }
            },
            path: AppResource().imDarkSub);
      default:
        break;
    }
    return Container();
  }
}
