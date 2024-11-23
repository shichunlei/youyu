import 'dart:io';

import 'package:youyu/models/gift.dart';
import 'package:youyu/models/my_getuserinfo.dart';

///礼物消息模型
class LiveGiftMsg {
  LiveGiftMsg({
    required this.sender,
    required this.receiver,
    required this.gift,
    this.svgFile,
  });

  //发送人
  final UserInfo? sender;

  //接收人
  final UserInfo? receiver;

  final Gift? gift;

  //飘屏用到
  final File? svgFile;
}
