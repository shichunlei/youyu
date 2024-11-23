import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';

class SinglePlayTitleWidget extends StatelessWidget {
  const SinglePlayTitleWidget(
      {super.key, required this.title, required this.image});

  final String title;
  final String image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              AppLocalImage(
                path: image,
                width: 12.w,
                fit: BoxFit.fitHeight,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                title,
                style: TextStyle(
                    color: AppTheme.colorTextWhite, fontSize: 14.sp),
              )
            ],
          ),
        ],
      ),
    );
  }
}
