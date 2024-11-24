import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/svga/simple_player_once.dart';
import 'package:youyu/models/gift_record.dart';
import 'package:youyu/models/room_detail_info.dart';
import 'package:youyu/modules/live/common/interactor/fixed/live_gift_notice_fixed.dart';
import 'package:youyu/modules/live/common/interactor/slide/gift/live_center_gift_slide.dart';
import 'package:youyu/modules/live/common/interactor/slide/gift/sub/live_center_gift_sub_normal.dart';
import 'package:youyu/modules/live/common/message/live_message.dart';
import 'package:youyu/modules/live/common/message/sub/live_gift_msg.dart';
import 'package:youyu/router/router.dart';
import 'package:youyu/services/async_down_service.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import "package:just_audio/just_audio.dart";
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'abs/live_notification.dart';

///礼物动画
class LiveGiftNotify extends LiveNotificationDispatch with AsyncDownListener {
  LiveGiftNotify() {
    _screenSlideData();
  }

  final svgPlayer = AudioPlayer();

  @override
  onStart({LiveNotification? notification, required Rx<RoomDetailInfo?> roomInfoObs}) {
    super.onStart(notification: notification, roomInfoObs: roomInfoObs);
    AsyncDownService().addDownListener(DownType.bigGifAni, this);
  }

  ///数据
  _screenSlideData() {
    //礼物漂屏
    double screenSlideH = 36.h;
    double screenSpace = 8.h;
    screenSlideList.clear();
    for (int i = 0; i < _subWidgetSlideList.length; i++) {
      var subWidgetSlide = _subWidgetSlideList[i];
      var subWidgetSlideKey = _subWidgetSlideKeyList[i];
      screenSlideList.add(Obx(() => Column(
            children: [
              (subWidgetSlide.value != null)
                  ? LiveCenterGiftSlide(
                      key: subWidgetSlideKey,
                      height: screenSlideH,
                      subWidget: subWidgetSlide.value,
                      onAniEnd: () {
                        subWidgetSlide.value = null;
                        continueGiftScreen();
                      },
                    )
                  : SizedBox(
                      height: screenSlideH,
                    ),
              SizedBox(
                height: screenSpace,
              ),
            ],
          )));
    }

    //礼物公告
    giftNoticeWidget = LiveGiftNoticeFixed(
      key: _giftNoticeKey,
      height: 37.h,
      onFetchNewMsg: () {
        //获取最新的一条
        return _giftCacheSlideQue.lastOrNull;
      },
      onClickItem: () {
        Get.toNamed(AppRouter().livePages.liveGiftNoticeRoute.name,
            arguments: roomInfoObs.value);
      },
    );

    //礼物大礼物
    bigAniWidget = Obx(() => _bigAniFile.value != null
        ? SVGASimpleImageOnce(
            key: _bigAniImageKey,
            file: _bigAniFile.value,
            onAniEnd: () {
              _bigAniFile.value = null;
              //此处要延时,给svga释放的时间
              Future.delayed(const Duration(milliseconds: 10), () {
                _continueGiftBigAni();
              });
            },
          )
        : const SizedBox.shrink());
  }

  insertGiftModel(LiveMessageModel<LiveGiftMsg> model) {
    _giftSlideQue.add(model);
    continueGiftScreen();
  }

/////////////////////////////////////////////////////////////////////////////////
//
//                   漂屏相关
//
/////////////////////////////////////////////////////////////////////////////////

  Timer? _playTimer;
  int time = 0;
  bool isJoinShow = false;

  final ListQueue<LiveMessageModel<LiveGiftMsg>> _giftSlideQue =
      ListQueue<LiveMessageModel<LiveGiftMsg>>();

  ///2个数组要统一长度
  final List<Rx<LiveCenterGiftSubNormal?>> _subWidgetSlideList = [
    Rx(null),
    Rx(null),
  ];
  final List<GlobalKey<LiveCenterGiftSlideState>> _subWidgetSlideKeyList = [
    GlobalKey<LiveCenterGiftSlideState>(),
    GlobalKey<LiveCenterGiftSlideState>(),
  ];

  final List<Widget> screenSlideList = [];

  ///继续处理gift漂屏
  continueGiftScreen() async {
    _playTimer?.cancel();
    _playTimer = Timer(const Duration(milliseconds: 10), () {
      ///根据展示的总数量
      for (int i = 0; i < _subWidgetSlideList.length; i++) {
        LiveMessageModel<LiveGiftMsg>? model = _giftSlideQue.lastOrNull;
        ///判断数量增加
        if (model != null && _equalSameGiftDataWithCount(
                _subWidgetSlideList[i].value?.model.data, model.data)) {

          _subWidgetSlideKeyList[i].currentState?.addCount(model.data,
              (allGiftCount) {
            //更新数量
            if ((_subWidgetSlideList[i].value?.key
                        as GlobalKey<LiveCenterGiftSubNormalState>)
                    .currentState
                    ?.twoAniEnd ==
                true) {
              _subWidgetSlideList[i].value = _createSubWidget(
                  LiveMessageModel(
                      isManager: false, type: model.type, data: model.data),
                  allGiftCount);
            }
          });
          _giftSlideQue.removeLast();
          continue;
        }

        ///判断显示礼物widget
        if (_subWidgetSlideList[i].value == null) {
          if (isJoinShow) {
            if (i == 0) {
              continue;
            }
          }
          LiveCenterGiftSubNormal? subWidget =
              _createSubWidget(model, model?.data?.gift?.count ?? 0);
          if (subWidget != null) {
            _subWidgetSlideList[i].value = subWidget;
            _giftSlideQue.removeLast();
            continue;
          }
        }
      }


      _judgmentShow();
    });
  }

  ///进入消息通知
  ///isJoinShow (进入消息是否显示)
  joinNotification(bool isJoinShow) {
    this.isJoinShow = isJoinShow;
    if (!isJoinShow) {
      notification?.giftSlideNotify.continueGiftScreen();
    } else {
      _judgmentShow();
    }
  }

  ///通知公屏遮罩(只在这一处通知)
  _judgmentShow() {
    LiveScreenMaskType maskType = LiveScreenMaskType.normal;
    bool firstMask = false;
    bool secondMask = false;
    if (_subWidgetSlideList[0].value != null) {
      firstMask = true;
    }
    if (_subWidgetSlideList[1].value != null) {
      secondMask = true;
    }
    if (firstMask && secondMask) {
      maskType = LiveScreenMaskType.long;
    } else if (!firstMask && !secondMask) {
      if (isJoinShow) {
        maskType = LiveScreenMaskType.short;
      }
    } else {
      if (secondMask) {
        maskType = LiveScreenMaskType.long;
      } else {
        maskType = LiveScreenMaskType.middle;
      }
    }

    notification?.screenNotify.processMaskType(maskType);
  }

  ///创建动画试图
  _createSubWidget(LiveMessageModel<LiveGiftMsg>? model, int allGiftCount) {
    LiveCenterGiftSubNormal? subWidget;
    if (model != null &&
        (model.type == LiveMessageType.gift ||
            model.type == LiveMessageType.luckGift)) {
      subWidget = LiveCenterGiftSubNormal(
        key: GlobalKey<LiveCenterGiftSubNormalState>(),
        model: model,
        allGiftCount: allGiftCount,
      );
    }
    return subWidget;
  }

  ///对比是否是同一个人送同一个人同样的礼物
  _equalSameGiftDataWithCount(LiveGiftMsg? oldData, LiveGiftMsg? newData) {
    if (oldData != null && newData != null) {
      if (oldData.gift?.id == newData.gift?.id &&
          oldData.sender?.nickname == newData.sender?.nickname &&
          oldData.receiver?.nickname == newData.receiver?.nickname) {
        return true;
      }
    }
    return false;
  }

///////////////////////////////////////////////////////////////////////////////////
//
//                  礼物公告相关
//
/////////////////////////////////////////////////////////////////////////////////

  final int maxCacheCount = 20;
  final ListQueue<GiftRecord> _giftCacheSlideQue = ListQueue<GiftRecord>();
  Widget? giftNoticeWidget;
  final GlobalKey<LiveGiftNoticeFixedState> _giftNoticeKey =
      GlobalKey<LiveGiftNoticeFixedState>();

  initGiftNotice() {}

  insertGiftNotice(GiftRecord model) {
    _giftCacheSlideQue.add(model);

    ///判断游戏公告缓存是否超过最大值
    _giftNoticeKey.currentState?.updateByFirst();
    if (_giftCacheSlideQue.length > maxCacheCount) {
      _giftCacheSlideQue.removeFirst();
    }
  }

/////////////////////////////////////////////////////////////////////////////////
//
//                    大礼物特效相关
//
/////////////////////////////////////////////////////////////////////////////////

  final ListQueue<File> _bigAniQue = ListQueue<File>();
  final GlobalKey<SVGASimpleImageOnceState> _bigAniImageKey =
      GlobalKey<SVGASimpleImageOnceState>();
  final Rx<File?> _bigAniFile = Rx(null);
  Widget? bigAniWidget;

  //下载成功
  @override
  onDownLoadSuccess(DownType downType, File file) {
    //播放大礼物动画
    _bigAniQue.add(file);
    _continueGiftBigAni();
  }

  _continueGiftBigAni() async {
    if (_bigAniFile.value == null) {
      File? bigAniFile = _bigAniQue.lastOrNull;
      if (bigAniFile != null) {
        _bigAniFile.value = bigAniFile;
        final videoItem = await SVGAParser.shared
            .decodeFromBuffer(await bigAniFile.readAsBytes());
        if (videoItem.audios.isNotEmpty) {
          final result = videoItem.images[videoItem.audios.first.audioKey];
          svgPlayer.setAudioSource(AudioSource.uri(Uri.dataFromBytes(result!)));
          svgPlayer.play();
        }
        _bigAniQue.removeLast();
      }
    }
  }

  ///清除大礼物队列
  clearBigAniQue() {
    _bigAniFile.value = null;
    _bigAniQue.clear();
  }

  //下载失败
  @override
  onDownLoadError(DownType downType) {}

  @override
  onClose() {
    AsyncDownService().removeDownListener(DownType.bigGifAni, this);
    _playTimer?.cancel();
    _giftSlideQue.clear();
    _bigAniQue.clear();
    svgPlayer.stop();
  }
}
