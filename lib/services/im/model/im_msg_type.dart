//im消息类型
enum IMMsgType {
  ///会话消息
  //系统通知
  officialSystem(type: "official_system"),
  //官方公告
  officialNotice(type: "official_notice"),

  ///直播间消息
  //直播间文字消息
  liveRoomText(type: "live_room_text"),
  //进入房间消息
  joinRoom(type: "join_room"),
  //上麦消息
  hugUpMicMsg(type: "hug_up_mic_msg"),
  //礼物飘屏
  slideGift(type: "slide_gift"),
  //TODO:升级爵位消息
  nobility(type: "nobility"),
  //公屏开关
  screenSpeak(type: 'screen_speak'),
  //群at消息
  groupAt(type: 'group_at'),
  //禁言消息
  forbidden(type: 'forbidden'),
  //踢出消息
  kickOut(type: 'kick_out'),
  //管理消息
  manager(type: "manager"),
  //房间设置消息
  roomSetting(type: "room_setting"),

  ///直播间&会话都显示
  //礼物消息
  gift(type: "gift"),
  //福袋礼物
  luckyGift(type: "lucky_gift"),

  joinRoomWithDressCar(type: "dress_car");

  const IMMsgType({required this.type});

  final String type;

  static IMMsgType getTypeByType(String type) =>
      IMMsgType.values.firstWhere((activity) => activity.type == type);
}
