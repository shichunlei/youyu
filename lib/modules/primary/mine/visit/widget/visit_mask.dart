import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';

//TODO:后期再做
class VisitMask extends StatelessWidget {
  const VisitMask({super.key, required this.maskList});

  final List<String> maskList;

  @override
  Widget build(BuildContext context) {
    return AppColumn(
      padding: EdgeInsets.all(15.w),
      radius: 6.w,
      color: AppTheme.colorDarkBg,
      margin: EdgeInsets.only(top: 15.h),
      children: [_top(), _mask()],
    );
  }

  _top() {
    return AppRow(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AppCircleNetImage(
          imageUrl: "",
          size: 48.w,
          borderWidth: 1.w,
          borderColor: AppTheme.colorMain,
        ),
        SizedBox(
          width: 6.w,
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    'As.xxx',
                    style: AppTheme().textStyle(
                        fontSize: 16.sp,
                        color: AppTheme.colorTextPrimary),
                  ),
                ),
                SizedBox(
                  width: 2.w,
                ),
                AppLocalImage(
                  path: AppResource().girl,
                  width: 11.w,
                )
              ],
            ),
            Text(
              '08.06 01:12',
              style: AppTheme().textStyle(
                  fontSize: 12.sp, color: AppTheme.colorTextSecond),
            )
          ],
        )),
        Text(
          '20次',
          style: AppTheme().textStyle(
              fontSize: 16.sp, color: AppTheme.colorTextPrimary),
        ),
      ],
    );
  }

  _mask() {
    return Container(
      alignment: Alignment.center,
      height: 122.h,
      child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 50.w, right: 50.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //水平子Widget之间间距
            crossAxisSpacing: 34.w,
            //垂直子Widget之间间距
            mainAxisSpacing: 1,
            //一行的Widget数量
            crossAxisCount: 3,
            //子Widget宽高比例
            childAspectRatio: 1,
          ),
          itemCount: maskList.length,
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: AppLocalImage(
                width: 48.w,
                height: 48.w,
                fit: BoxFit.fill,
                path: maskList[index],
              ),
            );
          }),
    );
  }
}
