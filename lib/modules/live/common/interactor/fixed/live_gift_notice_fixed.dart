import 'dart:async';

import 'package:youyu/utils/screen_utils.dart';
import 'package:card_swiper/card_swiper.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/models/gift_record.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/material.dart';

///礼物公告（固定在麦位和公屏的中间）
class LiveGiftNoticeFixed extends StatefulWidget {
  const LiveGiftNoticeFixed(
      {super.key,
      required this.height,
      required this.onFetchNewMsg,
      required this.onClickItem});

  //获取数据
  final GiftRecord? Function() onFetchNewMsg;

  //高度
  final double height;

  //点击事件
  final Function onClickItem;

  @override
  State<LiveGiftNoticeFixed> createState() => LiveGiftNoticeFixedState();
}

class LiveGiftNoticeFixedState extends State<LiveGiftNoticeFixed> {
  bool isFull = false;
  int maxCount = 2;
  List<GiftRecord> bannerList = [];
  final SwiperController tzController = SwiperController();
  final int seconds = 10;

  //定时去拿
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 2.h),
      alignment: Alignment.center,
      child: Swiper(
        key: UniqueKey(),
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: bannerList.length,
        autoplayDelay: seconds * 1000,
        autoplay: true,
        outer: false,
        controller: tzController,
        // 自动翻页
        itemBuilder: (BuildContext context, int index) {
          GiftRecord model = bannerList[index];
          return AppRow(
            onTap: () {
              widget.onClickItem();
            },
            key: ValueKey(index),
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            margin: EdgeInsets.only(left: 14.w, right: 14.w),
            children: [
              Flexible(
                child: Text(
                  model.userName ?? "",
                  style: AppTheme().textStyle(
                      fontSize: 12.sp, color: const Color(0xFF612ADA)),
                ),
              ),
              Text(
                "送给",
                style: AppTheme().textStyle(
                    fontSize: 12.sp, color: AppTheme.colorMain),
              ),
              Flexible(
                child: Text(
                  model.toUserName ?? "",
                  style: AppTheme().textStyle(
                      fontSize: 12.sp, color: const Color(0xFF612ADA)),
                ),
              ),
              Text(
                " ${model.giftName ?? ""}x${model.num ?? 0}",
                style: AppTheme().textStyle(fontSize: 12.sp, color: const Color(0xFF612ADA)),
              )
            ],
          );
        },
      ),
    );
  }

  ///首次通知
  updateByFirst() {
    if (!isFull) {
      if (bannerList.length == maxCount) {
        isFull = true;
        _timer = Timer.periodic(Duration(seconds: seconds * 2), (timer) {
          _update();
        });
      } else {
        _update();
      }
    }
  }

  _update() {
    GiftRecord? model = widget.onFetchNewMsg();
    if (model != null) {
      setState(() {
        if (bannerList.length < 2) {
          bannerList.add(model);
        } else {
          bannerList.removeAt(0);
          bannerList.add(model);
        }
        tzController.startAutoplay();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
