import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/models/localmodel/image_model.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/models/report_model.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/input/app_area_input.dart';
import 'package:youyu/widgets/app/other/app_edit_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import 'report_logic.dart';

class ReportPage extends StatelessWidget {
  ReportPage({Key? key}) : super(key: key);

  final logic = Get.find<ReportLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<ReportLogic>(
      appBar: AppTopBar(
        title: logic.reportType == ReportType.room ? "举报房间" : "举报",
      ),
      childBuilder: (s) {
        return KeyboardActions(
          config: AppTheme().keyboardActions([
            AppTheme().keyboardActionItem(logic.contentFocusNode),
          ]),
          child: SingleChildScrollView(
            child: AppColumn(
              margin: EdgeInsets.only(
                  left: 14.w,
                  right: 14.w,
                  top: 12.h,
                  bottom: ScreenUtils.safeBottomHeight + 7.h),
              children: [
                _topReason(),
                SizedBox(
                  height: 10.h,
                ),
                _selImage(),
                SizedBox(
                  height: 10.h,
                ),
                _textWord(),
                SizedBox(
                  height: 35.h,
                ),
                _bottomButton()
              ],
            ),
          ),
        );
      },
    );
  }

  ///理由
  _topReason() {
    return AppColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 12.h),
      color: AppTheme.colorDarkBg,
      radius: 6.w,
      children: [
        SizedBox(
          height: 8.h,
        ),
        Text(
          '请选择举报理由',
          style: AppTheme().textStyle(
              fontSize: 16.sp, color: AppTheme.colorTextWhite),
        ),
        SizedBox(
          height: 20.h,
        ),
        GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //水平子Widget之间间距
              crossAxisSpacing: 70.w,
              //垂直子Widget之间间距
              mainAxisSpacing: 15.h,
              //一行的Widget数量
              crossAxisCount: 2,
              //子Widget宽高比例
              childAspectRatio: 160 / 30,
            ),
            itemCount: logic.reasonList.length,
            itemBuilder: (BuildContext context, int index) {
              ReportModel model = logic.reasonList[index];
              return GetBuilder<ReportLogic>(
                  id: ReportLogic.reasonUpdateId,
                  builder: (s) {
                    return AppRow(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      onTap: () {
                        logic.selReason(model);
                      },
                      children: [
                        Text(
                          model.reason ?? "",
                          style: AppTheme().textStyle(
                              fontSize: 14.sp,
                              color: AppTheme.colorTextSecond),
                        ),
                        AppLocalImage(
                            width: 15.w,
                            height: 15.w,
                            path: model.id == logic.reasonType
                                ? AppResource().sel
                                : AppResource().unGraySel)
                      ],
                    );
                  });
            })
      ],
    );
  }

  ///选择图片
  _selImage() {
    return Obx(() => AppColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          color: AppTheme.colorDarkBg,
          radius: 6.w,
          padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 12.h),
          children: [
            SizedBox(
              height: 4.h,
            ),
            Row(
              children: [
                Text(
                  '图片证据',
                  style: AppTheme().textStyle(
                      fontSize: 16.sp, color: AppTheme.colorTextWhite),
                ),
                Expanded(
                  child: Text(
                    '（必填）',
                    style: AppTheme().textStyle(
                        fontSize: 14.sp,
                        color: AppTheme.colorTextSecond),
                  ),
                ),
                Text(
                  '${logic.imageList.length}/3',
                  style: AppTheme().textStyle(
                      fontSize: 14.sp, color: AppTheme.colorTextPrimary),
                ),
              ],
            ),
            Obx(() => Container(
                  margin: EdgeInsets.only(top: 14.h),
                  height: 74.h,
                  width: (74 * 3 + 10 * 3).h,
                  child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding:
                          EdgeInsets.only(left: 6.w, right: 6.w, bottom: 10.h),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //水平子Widget之间间距
                        crossAxisSpacing: 15.h,
                        //垂直子Widget之间间距
                        mainAxisSpacing: 15.h,
                        //一行的Widget数量
                        crossAxisCount: 3,
                        //子Widget宽高比例
                        childAspectRatio: 1,
                      ),
                      itemCount: logic.imageList.length,
                      itemBuilder: (BuildContext context, int index) {
                        ImageModel model = logic.imageList[index];
                        return AppEditImageWidget(
                          imageModel: model,
                          imageAdd: AppResource().imgAdd,
                          onClickAdd: logic.selectImageList,
                          onClickDel: logic.onClickDelImage,
                        );
                      }),
                ))
          ],
        ));
  }

  ///文字描述
  _textWord() {
    return AppColumn(
      padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 12.h),
      radius: 6.w,
      height: 188.h,
      color: AppTheme.colorDarkBg,
      children: [
        SizedBox(
          height: 4.h,
        ),
        Row(
          children: [
            Text(
              '图片证据',
              style: AppTheme().textStyle(
                  fontSize: 16.sp, color: AppTheme.colorTextWhite),
            ),
            Expanded(
              child: Text(
                '（最多140字）',
                style: AppTheme().textStyle(
                    fontSize: 14.sp, color: AppTheme.colorTextSecond),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5.h,
        ),
        AppAreaInput(
            controller: logic.contentController,
            theme: AppWidgetTheme.dark,
            padding: EdgeInsets.zero,
            maxLength: 140,
            placeHolderColor: AppTheme.colorTextSecond,
            textColor: AppTheme.colorTextWhite,
            height: 130.h,
            focusNode: logic.contentFocusNode,
            counterStyle: AppTheme().textStyle(
                fontSize: 14.sp, color: AppTheme.colorTextSecond),
            onChanged: (s) {
              //...
            },
            placeHolder: "请描述举报原因，让我们更快速吃力问题。")
      ],
    );
  }

  ///底部按钮
  _bottomButton() {
    return AppColorButton(
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        height: 50.w,
        onClick: logic.submit,
        padding: EdgeInsets.zero,
        fontSize: 14.sp,
        title: '提交',
        titleColor: AppTheme.colorTextWhite,
        bgGradient: AppTheme().btnGradient);
  }
}
