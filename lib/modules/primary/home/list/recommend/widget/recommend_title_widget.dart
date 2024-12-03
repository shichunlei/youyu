import 'package:youyu/utils/screen_utils.dart';

// import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
// import 'package:youyu/widgets/app/icon/app_more_icon.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';

///热门分类标题
class RecommendTitleWidget extends StatelessWidget {
  const RecommendTitleWidget(
      {super.key,
      required this.title,
      required this.image,
      required this.onClick});

  final String title;
  final String image;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick();
      },
      child: SizedBox(
        height: 42.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                AppLocalImage(
                  path: image,
                  width: 16.w,
                  fit: BoxFit.fitHeight,
                ),
                const SizedBox(
                  width: 6,
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: AppTheme.colorTextDarkSecond,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ),
            // AppMoreIcon(height: 30.h,image: AppResource().arrow1,)
          ],
        ),
      ),
    );
  }
}
