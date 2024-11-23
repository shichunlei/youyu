import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/models/gift.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/list/app_grid_separated_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'user_gift_logic.dart';
import 'widget/user_gift_widget.dart';

class UserGiftPage extends StatefulWidget {
  const UserGiftPage({Key? key, required this.userId}) : super(key: key);

  final int userId;

  @override
  State<UserGiftPage> createState() => _UserGiftPageState();
}

class _UserGiftPageState extends State<UserGiftPage>
    with AutomaticKeepAliveClientMixin {
  final logic = Get.put(UserGiftLogic());

  @override
  void initState() {
    super.initState();
    logic.userId = widget.userId;
    logic.fetchList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppPage<UserGiftLogic>(
      isUseScaffold: false,
      childBuilder: (s) {
        return AppColumn(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppContainer(
              height: 40.h,
              margin: EdgeInsets.symmetric(horizontal: 12.w),
              alignment: Alignment.centerLeft,
              child: Text(
                '收到的礼物（${logic.allCount}）',
                style: AppTheme().textStyle(
                    fontSize: 14.sp, color: AppTheme.colorTextSecond),
              ),
            ),
            Expanded(
                child: AppGridSeparatedView(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                  bottom: 10.h + ScreenUtils.safeBottomHeight,
                  left: 12.w,
                  right: 12.w),
              controller: s.refreshController,
              itemCount: s.dataList.length,
              isOpenLoadMore: false,
              isOpenRefresh: false,
              itemBuilder: (_, int index) {
                Gift itemModel = s.dataList[index];
                return UserGiftWidget(
                  gift: itemModel, onClick: () {
                  logic.onClickGift(itemModel);
                },
                );
              },
              //水平子Widget之间间距
              crossAxisSpacing: 10.w,
              //垂直子Widget之间间距
              mainAxisSpacing: 10.w,
              //一行的Widget数量
              crossAxisCount: 4,
              //子Widget宽高比例
              childAspectRatio: 76 / 95,
              isNoData: s.isNoData,
            ))
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
