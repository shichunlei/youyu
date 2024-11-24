class LiveGifMsg {
  LiveGifMsg({required this.name, this.isShowEnd,this.localCustomInt = 0});

  //gif名称
  final String name;

  //是否显示结束的画面
  final bool? isShowEnd;

  int localCustomInt;
}
