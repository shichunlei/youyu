import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/gift.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';

class WheelGameResultDialog extends StatelessWidget {
  const WheelGameResultDialog({super.key, required this.giftList, required this.onReSend});

  final List<Gift> giftList;
  final Function onReSend;

  @override
  Widget build(BuildContext context) {
    double imageH =
        (ScreenUtils.screenWidth - 18 * 2.w).imgHeight(Size(339, 364));
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Get.back();
        },
        child: Center(
          child: AppStack(
            height: imageH,
            alignment: Alignment.center,
            children: [
              AppLocalImage(
                path: AppResource().gameWheelTaBg,
                width: ScreenUtils.screenWidth - 18 * 2.w,
              ),
              Positioned(
                  left: 0,
                  right: 0,
                  top: 75.w,
                  bottom: 60.w,
                  child: GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //水平子Widget之间间距
                        crossAxisSpacing: 1.w,
                        //垂直子Widget之间间距
                        mainAxisSpacing: 4.w,
                        //一行的Widget数量
                        crossAxisCount: 4,
                        //子Widget宽高比例
                        childAspectRatio: 70 / 110,
                      ),
                      itemCount: giftList.length,
                      itemBuilder: (BuildContext context, int index) {
                        Gift gift = giftList[index];
                        return _itemWidget(gift);
                      })),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 20.w,
                  child: Center(
                    child: AppLocalImage(
                      onTap: () {
                        onReSend();
                      },
                      path: AppResource().gameWheelBtn,
                      width: 200.w,
                      height: 40.w,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemWidget(Gift gift) {
    return AppColumn(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppStack(
          width: double.infinity,
          height: 62.w,
          children: [
            Positioned(top: 2.w,right: 2.w,bottom: 2.w,left: 2.w,child: AppLocalImage(
              path: AppResource().gameWheelItemBg,
              width: 62.w,
            )),
            Positioned(
              left: 17.w,
              top: 11.w,
              child: AppNetImage(
                imageUrl: gift.image,
                width: 40.w,
                height: 40.w,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
                child: Container(
              alignment: Alignment.center,
              width: 30.w,
              height: 16.h,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(AppResource().gameWheelCountBg),
                      fit: BoxFit.fill)),
              child: Text(
                'x${gift.count ?? 0}',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ))
          ],
        ),
        //名称
        SizedBox(
          height: 2.w,
        ),
        Center(
          child: Text(
            gift.name,
            style: AppTheme().textStyle(
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 2.w,
        ),
        //数量
        AppRow(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
                fit: FlexFit.loose,
                child: Text(
                  '${gift.unitPrice}',
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 12.sp,
                    color: Colors.white,
                  ),
                )),
            SizedBox(width: 2.w),
            AppLocalImage(
              path: AppResource().coin2,
              width: 8.w,
            )
          ],
        ),
      ],
    );
  }
}
