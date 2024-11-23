/*
 * @Author: alexalive hhyy1243047559@gmail.com
 * @Date: 2024-11-03 00:12:26
 * @LastEditors: alexalive hhyy1243047559@gmail.com
 * @LastEditTime: 2024-11-06 16:23:00
 * @FilePath: /youyu/lib/modules/live/common/interactor/pop/relation/live_pop_relation.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:get/get.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/modules/live/common/interactor/pop/relation/live_relation_logic.dart';
import 'package:youyu/modules/live/common/interactor/pop/relation/live_relation_model.dart';
import 'package:youyu/modules/live/common/interactor/pop/relation/widget/live_pop_relation_avatar_view.dart';
import 'package:youyu/modules/live/common/model/mic_seat_state.dart';
import 'package:youyu/modules/live/index/live_index_logic.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_round_container.dart';
import 'package:flutter/material.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';

///邂逅关系弹窗
class LivePopRelation extends StatefulWidget {
  const LivePopRelation({
    super.key,
    required this.userPair,
  });

  final List<MicSeatState> userPair;

  @override
  State<LivePopRelation> createState() => LivePopRelationState();
}

class LivePopRelationState extends State<LivePopRelation>
    with SingleTickerProviderStateMixin {
  final logic = Get.put(LiveRelationLogic());

  @override
  void initState() {
    super.initState();
    logic.fetchList();
  }

  @override
  Widget build(BuildContext context) {
    return AppRoundContainer(
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.w), topRight: Radius.circular(12.w)),
        bgColor: AppTheme.colorDarkBg,
        height: 447.h,
        child: Column(children: [
          AppRow(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            width: double.infinity,
            height: 44.h,
            children: [
              SizedBox(
                width: 50.w,
              ),
              Text(
                "选择关系",
                style:
                    AppTheme().textStyle(fontSize: 18.sp, color: Colors.white),
              ),
              AppContainer(
                onTap: () {
                  Get.back();
                },
                width: 50.w,
                child: Center(
                  child: AppLocalImage(
                    path: AppResource().close,
                    width: 12.w,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 15.h,
          ),
          Padding(
              padding: EdgeInsets.all(20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  LivePopRelationAvatarItem(
                    model: widget.userPair[4].user!,
                  ),
                  LivePopRelationAvatarItem(
                    model: widget.userPair[5].user!,
                  ),
                ],
              )),
          Expanded(child: Obx(() => _relationList(logic.relationList))),
          Padding(
            padding: EdgeInsets.all(20.h),
            child: AppColorButton(
              title: '确定关系',
              width: 326.w,
              height: 56.h,
              titleColor: AppTheme.colorTextWhite,
              bgGradient: AppTheme().btnGradient,
              // bgColor: Colors.transparent,
              onClick: () {
                LiveIndexLogic.to.operation
                    .onOperateRelationConfirm(logic.selectIndex.value);
                print("管理员确定了关系");
              },
            ),
          )
        ]));
  }

  Widget _relationList(RxList<RelationType> list) {
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 15.w, right: 15.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //水平子Widget之间间距
          crossAxisSpacing: 13.w,
          //垂直子Widget之间间距
          mainAxisSpacing: 13.h,
          //一行的Widget数量
          crossAxisCount: 4,
          //子Widget宽高比例
          childAspectRatio: 76 / 41,
        ),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          // RelationType gift = list[index];
          return Obx(() {
            bool isSelected = logic.selectIndex.value == list[index].id;

            return AppContainer(
              strokeColor: isSelected ? Colors.transparent : AppTheme.colorMain,
              strokeWidth: 1.w,
              gradient: isSelected ? AppTheme().btnGradient : null,
              width: 76.w,
              height: 41.h,
              // color: isSelected ? AppTheme.colorMain : Colors.transparent,
              onTap: () {
                logic.selectIndex.value = list[index].id!;
              },
              radius: 7.w,
              child: Center(
                  child: Text(list[index].name!,
                      style: AppTheme()
                          .textStyle(fontSize: 17.sp, color: Colors.white))),
            );
          });
        });
  }
}
