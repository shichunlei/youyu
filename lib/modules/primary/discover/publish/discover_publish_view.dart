import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/models/localmodel/image_model.dart';
import 'package:youyu/widgets/discover/sub/discover_audio_file_widget.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/modules/primary/discover/publish/bottom/discover_bottom_more.dart';
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

import 'discover_publish_logic.dart';

class DiscoverPublishPage extends StatelessWidget {
  DiscoverPublishPage({Key? key}) : super(key: key);

  final logic = Get.find<DiscoverPublishLogic>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => exitVerify(),
        child: AppStack(
          children: [
            AppPage<DiscoverPublishLogic>(
              resizeToAvoidBottomInset: false,
              appBar: AppTopBar(
                title: "发布动态",
                onTapBack: logic.onBack,
                actionExtraWidth: 20.w,
                rightAction: AppColorButton(
                  onClick: () {
                    logic.onPublish();
                  },
                  padding: EdgeInsets.zero,
                  bgGradient: AppTheme().btnGradient,
                  title: '发布',
                  titleColor: AppTheme.colorTextWhite,
                  fontSize: 14.sp,
                  width: 52.w,
                  height: 26.h,
                ),
              ),
              childBuilder: (s) {
                return _content();
              },
            ),

            ///遮罩
            Obx(() => (logic.pageState == DiscoverPageState.normal)
                ? const SizedBox.shrink()
                : AppContainer(
                    onTap: () {
                      logic.setPageState = DiscoverPageState.normal;
                    },
                    color: const Color(0x66000000),
                    width: double.infinity,
                    height: double.infinity,
                  )),

            ///底部
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: DiscoverBottomMoreWidget(
                  logic: logic,
                ))
          ],
        ));
  }

  ///内容
  _content() {
    return SizedBox(
        height: ScreenUtils.screenHeight - ScreenUtils.navbarHeight,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            AppColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              margin:
                  EdgeInsets.only(bottom: 76.h + ScreenUtils.safeBottomHeight),
              children: [
                ///内容
                AppAreaInput(
                  padding: EdgeInsets.only(
                      left: 15.w, right: 15.w, top: 12.w, bottom: 12.w),
                  textColor: AppTheme.colorTextWhite,
                  controller: logic.contentController,
                  textInputAction: TextInputAction.newline,
                  bgColor: Colors.transparent,
                  placeHolderColor: AppTheme.colorTextSecond,
                  height: 130.h,
                  placeHolder: "记录这一刻，晒给懂你的人。",
                  theme: AppWidgetTheme.dark,
                ),

                if (logic.mentionUserNames.isNotEmpty)
                  AppContainer(
                    margin: EdgeInsets.symmetric(horizontal: 15.w),
                    height: 40.h,
                    child: Text(
                      "@${logic.mentionUserNames.join("，")}",
                      style: AppTheme().textStyle(
                          fontSize: 14.sp,
                          color: AppTheme.colorTextSecond),
                    ),
                  ),

                ///语音
                Obx(() => logic.audioState == DiscoverAudioRecordState.finish &&
                        logic.seconds.value > 0
                    ? AppRow(
                        margin: EdgeInsets.only(left: 15.w, bottom: 25.h),
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DiscoverAudioFileWidget(
                            time: logic.seconds.value.toString(),
                            audioFile: logic.audioFile,
                          ),
                          AppContainer(
                            onTap: () {
                              logic.onDelAudio();
                            },
                            width: 34.w,
                            height: 34.w,
                            child: Center(
                              child: AppLocalImage(
                                path: AppResource().imgDel,
                                width: 14.w,
                              ),
                            ),
                          )
                        ],
                      )
                    : const SizedBox.shrink()),

                ///图片
                Obx(() => GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding:
                        EdgeInsets.only(left: 15.w, right: 15.w, bottom: 10.h),
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
                        onClickAdd: logic.onClickImage,
                        onClickDel: logic.onClickDelImage,
                      );
                    }))
              ],
            )
          ],
        ));
  }

  Future<bool> exitVerify() async {
    return Future.value(false);
  }
}
