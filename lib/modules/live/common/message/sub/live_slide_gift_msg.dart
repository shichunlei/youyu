import 'dart:io';

import 'package:youyu/models/gift.dart';
import 'package:youyu/models/my_getuserinfo.dart';

///礼物飘屏消息模型
class LiveSlideGiftMsg {
  LiveSlideGiftMsg({
    required this.sender,
    required this.receiver,
    required this.giftList,
    this.svgFile,
  });

  //发送人
  final UserInfo? sender;

  //接收人
  final UserInfo? receiver;

  final List<Gift>? giftList;

  //飘屏用到
  final File? svgFile;
}
