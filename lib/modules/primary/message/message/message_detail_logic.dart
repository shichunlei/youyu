import 'dart:async';
import 'dart:io';
import 'package:youyu/utils/platform_utils.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/widgets/gift/common_gift_pop_view.dart';
import 'package:youyu/widgets/gift/model/common_gift_pop_model.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/gift_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:youyu/services/voice_service.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/services/im/im_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as math;

import 'package:permission_handler/permission_handler.dart';

enum MessageDetailTitleState {
  normal, //正常
  onLine, //在线
  live //直播中
}

enum MessageDetailInputState {
  none, //空
  emoji, //表情
  audio, //语音
  text //输入框
}

abstract class MessageDetailBaseNavState<T extends StatefulWidget>
    extends State<T> {
  updateTitle({String? newTitle, MessageDetailTitleState? state});
}

//TODO:未来判断群聊
class MessageDetailLogic extends AppBaseController with UserBlackListener {
  ///用户系统id
  int? userId = 0;

  ///标题
  String pageTitle = "";
  GlobalKey<MessageDetailBaseNavState> navKey =
      GlobalKey<MessageDetailBaseNavState>();

  Rx<MessageDetailTitleState> titleState = MessageDetailTitleState.normal.obs;

  var isCloseLive = false.obs;

  ///用户信息
  Rx<UserInfo?> targetUserInfo = Rx(null);

  ///内容控制器
  var chatTextEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();

  ///input状态
  //当前状态
  MessageDetailInputState get state => _state.value;

  //记录上一个状态
  final List<MessageDetailInputState> _states = [
    MessageDetailInputState.none, //new
    MessageDetailInputState.none //old
  ];

  MessageDetailInputState get beforeState => _states.last;

  set setInputState(MessageDetailInputState state) {
    _states.removeLast();
    _states.insert(0, state);
    _state.value = state;
  }

  final _state = MessageDetailInputState.none.obs;

  ///语音相关
  File? audioFile;
  int audioId = -1;
  var isAudioInputing = false.obs;
  var isAudioInputingCancle = false.obs;

  //播放用的id
  var currentPlayAudioId = "-1";

  ///记录录音时间
  DateTime startTime = DateTime.now();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/${DateTime.now().millisecondsSinceEpoch}_sound.mp3');
  }

  ///键盘高度相关
  //距离底部高度(配合键盘)
  var inputBottomHeight = 0.0.obs;

  //emoji高度
  double emojiHeight = 280.h;

  //临时变量
  double tempBottom = 0;
  Timer? _timer;

  ///高度
  //输入框高度
  double inputHeight = 56.h;

  //底部高度
  double bottomMoreHeight = 78.w;

  ///当前上下文
  BuildContext? context;

  @override
  void onInit() async {
    super.onInit();
    if (Get.arguments != null) {
      userId = Get.arguments['userId'];
      pageTitle = Get.arguments['userName'];
      initData();
    }
  }

  initData() async {
    audioFile = await _localFile;
    UserController.to.addUserBlackObserver(this);
    //加载数据
    _loadData();
  }

  ///加载数据
  _loadData() async {
    //获取他人信息
    UserController.to.fetchOtherInfo(userId).then((value) {
      targetUserInfo.value = UserInfo.fromJson(value.data);
      pageTitle = targetUserInfo.value?.nickname ?? "";
      titleState.value = MessageDetailTitleState.normal;
      if ((targetUserInfo.value?.onlineRoom ?? 0) > 0) {
        titleState.value = MessageDetailTitleState.live;
      } else {
        if (targetUserInfo.value?.isOnline == true) {
          titleState.value = MessageDetailTitleState.onLine;
        }
      }
      navKey.currentState
          ?.updateTitle(newTitle: pageTitle, state: titleState.value);
    });
    IMService().markC2CMessageAsRead(userId.toString());
  }

  ///事件
  //点击表情
  onClickEmoji() {
    if (!isCanSend()) return;

    ///根据状态判断
    switch (state) {
      case MessageDetailInputState.none:
        setInputState = MessageDetailInputState.emoji;
        inputBottomHeight.value = emojiHeight + ScreenUtils.safeBottomHeight;
        closeKeyboard();
        break;
      case MessageDetailInputState.emoji:
        setInputState = MessageDetailInputState.text;
        focusNode.requestFocus();
        _delayShowKb();
        break;
      case MessageDetailInputState.text:
        setInputState = MessageDetailInputState.emoji;
        inputBottomHeight.value = emojiHeight + ScreenUtils.safeBottomHeight;
        closeKeyboard();
        break;
      case MessageDetailInputState.audio:
        setInputState = MessageDetailInputState.emoji;
        inputBottomHeight.value = emojiHeight + ScreenUtils.safeBottomHeight;
        closeKeyboard();
        break;
    }
  }

  //点击语音
  onClickAudio() {
    if (!isCanSend()) return;
    if (state == MessageDetailInputState.audio) {
      setInputState = MessageDetailInputState.none;
    } else {
      setInputState = MessageDetailInputState.audio;
      inputBottomHeight.value = 0;
      closeKeyboard();
    }
  }

  //删除语音
  onAudioDel() async {
    try {
      bool isExists = await audioFile?.exists() ?? false;
      if (isExists) {
        await audioFile?.delete();
      }
    } catch (e) {
      //...
    }
  }

  //点击图片
  onClickImage() async {
    if (!isCanSend()) return;
    setInputState = MessageDetailInputState.none;
    inputBottomHeight.value = 0;
    closeKeyboard();
    List<Media> res = await ImagePickers.pickerPaths(
        galleryMode: GalleryMode.image,
        selectCount: 1,
        showCamera: true,
        compressSize: 500,
        cropConfig: CropConfig(enableCrop: false, width: 2, height: 1),
        uiConfig: UIConfig(
          uiThemeColor: AppTheme.colorNavBar,
        ));
    if (res.isNotEmpty) {
      var m = res[0];
      onSendImageMessage(m);
    }
  }

  //点击相机
  onClickCamera() async {
    if (!isCanSend()) return;
    PermissionStatus status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      ToastUtils.show("请打相机权限");
    } else {
      Media? res = await ImagePickers.openCamera();
      if (res != null) {
        var m = res;
        onSendImageMessage(m);
      }
    }
  }

  //点击弹出键盘
  onClickShowKb() {
    setInputState = MessageDetailInputState.text;
    focusNode.requestFocus();
    if (beforeState == MessageDetailInputState.emoji) {
      _delayShowKb();
    }
  }

  //核心
  _delayShowKb() {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: PlatformUtils.isIOS ? 650 : 500), () {
      inputBottomHeight.value = tempBottom;
      setInputState = MessageDetailInputState.text;
    });
  }

  var oldBottom = 0.0;

  //键盘变化 注意只有键盘弹出bottom才会变化，否则都为0
  onKeyBoardChange(double bottom) {
    if (oldBottom != bottom) {
      if (state == MessageDetailInputState.text) {
        if (beforeState == MessageDetailInputState.emoji) {
          tempBottom = math.max(tempBottom, bottom);
        } else {
          inputBottomHeight.value = bottom;
          if (bottom <= 0 && context != null) {
            setInputState = MessageDetailInputState.none;
            focusNode.unfocus();
          }
        }
      }
      oldBottom = bottom;
    }
  }

  //点击背景消失
  onClickMaskNone() {
    setInputState = MessageDetailInputState.none;
    inputBottomHeight.value = 0;
    closeKeyboard();
  }

  ///发消息
  //点击礼物
  bool isShowGiftPop = false;

  //发送礼物消息
  onClickGift() async {
    if (!isCanSend()) return;
    if (isShowGiftPop) {
      return;
    }
    await showModalBottomSheet(
        context: Get.context!,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) {
          return CommonGiftPopPage(
            receiver: targetUserInfo.value,
            isShowUserList: false,
            isSeatUsers: false,
            onSend: (CommonGiftSendModel? sendModel) async {
              if (sendModel != null) {
                try {
                  isShowGiftPop = false;
                  await GiftController.to.msgSendGift(sendModel);
                } catch (e) {
                  hiddenCommit();
                  isShowGiftPop = false;
                }
              }
            },
          );
        });
    isShowGiftPop = false;
  }

  //文字消息
  onSendTextMessage() async {
    setInputState = MessageDetailInputState.none;
    inputBottomHeight.value = 0;
    closeKeyboard();
    if (isCanSend()) {
      if (chatTextEditingController.text.isNotEmpty) {
        try {
          await IMService().sendTextMsg(
            chatTextEditingController.text,
            receiver: userId.toString(),
            groupID: null,
          );
          chatTextEditingController.text = '';
        } catch (e) {
          ToastUtils.show("发送失败");
        }
      } else {
        ToastUtils.show("请输入内容");
      }
    }
  }

  //图片消息
  void onSendImageMessage(Media m) async {
    try {
      await IMService().sendImageMsg(
        m.path!,
        receiver: userId.toString(),
        groupID: null,
      );
    } catch (e) {
      ToastUtils.show("发送失败");
    }
  }

  //语音消息
  onSendAudioMessage(int secs) async {
    try {
      await VoiceService().stopAudio();
      await IMService().sendAudioMsg(
        audioFile?.path ?? "",
        secs,
        receiver: userId.toString(),
        groupID: null,
      );
      onAudioDel();
    } catch (e) {
      onAudioDel();
      ToastUtils.show("发送失败");
    }
  }

  ///发送拦截
  bool isCanSend() {
    if (targetUserInfo.value?.isBlock == 1) {
      ToastUtils.show("您已拉黑了对方");
      return false;
    } else if (targetUserInfo.value?.isCoverBlock == 1) {
      ToastUtils.show("您已被对方拉黑");
      return false;
    }
    return true;
  }

  //进入直播间
  onClickToLive() {
    LiveService().pushToLive(targetUserInfo.value?.thisRoomInfo?.id,
        targetUserInfo.value?.thisRoomInfo?.groupId);
  }

  //关闭直播弹窗
  onClickCloseLive() {
    isCloseLive.value = true;
  }

  ///UserBlackListener
  @override
  onUserBlackChanged(UserInfo userInfo) {
    if (userInfo.id == targetUserInfo.value?.id) {
      targetUserInfo.value?.isBlock = userInfo.isBlock;
      setSuccessType();
    }
  }

  ///重新加载
  @override
  void reLoadData() {
    super.reLoadData();
    _loadData();
  }

  @override
  void onClose() {
    UserController.to.removeUserBlackObserver(this);
    VoiceService().stopAudio();
    focusNode.dispose();
    super.onClose();
  }
}
