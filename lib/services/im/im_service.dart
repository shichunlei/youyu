import 'dart:convert';

import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/utils/log_utils.dart';
import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/config/config.dart';
import 'package:youyu/controllers/app_controller.dart';
import 'package:youyu/controllers/auth_controller.dart';
import 'package:youyu/controllers/conversation_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/router/router.dart';
import 'package:youyu/services/im/im_listener.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/utils/format_utils.dart';
import 'package:youyu/widgets/app/dialog/app_tip_dialog.dart';
import 'package:youyu/widgets/app/other/app_custom_loading.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimAdvancedMsgListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimConversationListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimGroupListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimSDKListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/log_level_enum.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_callback.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation_filter.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_receipt.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_full_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_status.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencent_im_sdk_plugin_platform_interface/models/v2_tim_message.dart';
import 'package:tencent_im_sdk_plugin_platform_interface/enum/message_priority_enum.dart';
import 'package:tencent_im_sdk_plugin_platform_interface/models/v2_tim_msg_create_info_result.dart';
import 'model/im_custom_message_mdoel.dart';
import 'model/im_msg_type.dart';

enum IMState { noConnect, connecting, success, error }

class IMService extends AppBaseController {
  static const String _tag = "IM";
  static const adminId = 'administrator';

  static IMService? _instance;

  factory IMService() => _instance ??= IMService._();

  IMService._();

  //im状态
  IMState imageState = IMState.noConnect;

  //im是否登录
  bool isLogin = false;

  //im状态监听
  List<IMStateListener> imStateListeners = [];

  //im 消息发送监听
  List<IMMessageSendListener> imSendListeners = [];

  //im 消息接收监听
  List<IMMessageReceiveListener> imReceiveListeners = [];

  //im 消息已读监听
  List<IMMessageC2CReadReceiptListener> imC2CReadReceiptListeners = [];

  //im 会话监听
  List<IMConversationListener> imConversationListeners = [];

  //im 群组监听
  List<IMMessageGroupListener> imGroupListeners = [];

  /// ************************** 初始化SDK ***********************
  @override
  void onInit() async {
    super.onInit();
    V2TimValueCallback<bool> initSDKRes =
        await TencentImSDKPlugin.v2TIMManager.initSDK(
      sdkAppID: AppConfig.imAppId, // SDKAppID
      loglevel: LogLevelEnum.V2TIM_LOG_ALL, // 日志登记等级
      listener: _imSdkListener(), // 事件监听器
    );
    if (initSDKRes.code == 0) {
      //初始化成功
      LogUtils.onPrint("初始化成功", tag: _tag);
      //消息监听
      _imMessageListener();
      //群组监听
      _imGroupListener();
      //会话监听
      _imConversationListener();

      ///初始化会话管理
      ConversationController.to.initConversationManager();
      //更新未读消息数量
      V2TimValueCallback<int> getTotalUnreadMessageCountRes =
          await TencentImSDKPlugin.v2TIMManager
              .getConversationManager()
              .getTotalUnreadMessageCount();
      AppController.to.requestSysNoticeUnReadCount();
      if (getTotalUnreadMessageCountRes.code == 0) {
        //拉取成功
        int? count = getTotalUnreadMessageCountRes.data; //会话未读总数
        AppController.to.updateIMUnReadCount(count ?? 0);
      }
    }
  }

  /// ************************** Listener ***********************
  //im状态监听
  _imSdkListener() {
    // 2. 添加 V2TimSDKListener 的事件监听器，sdkListener 是 V2TimSDKListener 的实现类
    return V2TimSDKListener(
      onConnectFailed: (int code, String error) {
        // 连接失败的回调函数
        imageState = IMState.error;
        for (var element in imStateListeners) {
          element.onError(code: code, errorMsg: error);
        }
        LogUtils.onPrint("连接失败:$code-$error", tag: _tag);
      },
      onConnectSuccess: () {
        // SDK 已经成功连接到腾讯云服务器
        imageState = IMState.success;
        for (var element in imStateListeners) {
          element.onSuccess();
        }
        LogUtils.onPrint("连接成功", tag: _tag);
      },
      onConnecting: () {
        // SDK 正在连接到腾讯云服务器
        imageState = IMState.connecting;
        for (var element in imStateListeners) {
          element.onConnecting();
        }
        LogUtils.onPrint("连接中", tag: _tag);
      },
      onKickedOffline: () {
        // 当前用户被踢下线，此时可以 UI 提示用户，并再次调用 V2TIMManager 的 login() 函数重新登录。（跳转登录）
        AuthController.to.logout(initiative: false);
        AppTipDialog().showTipDialog("提示", AppWidgetTheme.dark,
            msg: "您已被踢下线，请重新登录", onlyCommit: true);
      },
      onSelfInfoUpdated: (V2TimUserFullInfo info) {
        //... 登录用户的资料发生了更新
      },
      onUserSigExpired: () {
        //在线时票据过期：此时您需要生成新的 userSig 并再次调用 V2TIMManager 的 login() 函数重新登录。（跳转登录）
        AuthController.to.logout(initiative: false);
        AppTipDialog().showTipDialog("提示", AppWidgetTheme.dark,
            msg: "您登录已过期，请重新登录", onlyCommit: true);
      },
      onUserStatusChanged: (List<V2TimUserStatus> userStatusList) {
        //用户状态变更通知，userStatusList 用户状态变化的用户列表，收到通知的情况：订阅过的用户发生了状态变更（包括在线状态和自定义状态），会触发该回调
        //在 IM 控制台打开了好友状态通知开关，即使未主动订阅，当好友状态发生变更时，也会触发该回调
        //同一个账号多设备登录，当其中一台设备修改了自定义状态，所有设备都会收到该回调
      },
    );
  }

  addImStateListener(IMStateListener listener) {
    imStateListeners.add(listener);
  }

  removeImStateListener(IMStateListener listener) {
    imStateListeners.remove(listener);
  }

  //im 消息监听
  _imMessageListener() async {
    V2TimAdvancedMsgListener msgListener = V2TimAdvancedMsgListener(
      onRecvNewMessage: (V2TimMessage msg) {
        if (msg.customElem != null &&
            msg.customElem!.desc == IMMsgType.gift.type) {
          //更新用户信息
          UserController.to.updateMyInfo();
        }
        if (AuthController.to.isLogin) {
          for (var element in imReceiveListeners) {
            element.onReceiveMessage(msg);
          }
        }
      },
      onRecvC2CReadReceipt: (List<V2TimMessageReceipt> receiptList) {
        //单聊已读回调
        if (AuthController.to.isLogin) {
          for (var element in imC2CReadReceiptListeners) {
            element.onMessageC2CReadReceipt(receiptList);
          }
        }
      },
    );
    TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .addAdvancedMsgListener(listener: msgListener);
  }

  addC2CReadReceiptListener(IMMessageC2CReadReceiptListener listener) {
    imC2CReadReceiptListeners.add(listener);
  }

  removeC2CReadReceiptListener(IMMessageC2CReadReceiptListener listener) {
    imC2CReadReceiptListeners.remove(listener);
  }

  addImReceiveMessageListener(IMMessageReceiveListener listener) {
    imReceiveListeners.add(listener);
  }

  removeImReceiveMessageListener(IMMessageReceiveListener listener) {
    imReceiveListeners.remove(listener);
  }

  //im 群组监听
  _imGroupListener() async {
    V2TimGroupListener groupListener = V2TimGroupListener(
      onMemberEnter:
          (String groupID, List<V2TimGroupMemberInfo> memberList) async {
        //有用户加入群（全员能够收到）
        //groupID    群 ID
        //memberList    加入的成员
        if (AuthController.to.isLogin) {
          for (var element in imGroupListeners) {
            element.onMemberEnter(groupID, memberList);
          }
        }
      },
      onMemberLeave: (String groupID, V2TimGroupMemberInfo member) async {
        //有用户离开群（全员能够收到）
        //groupID    群 ID
        //member    离开的成员
        if (AuthController.to.isLogin) {
          for (var element in imGroupListeners) {
            element.onMemberLeave(groupID, member);
          }
        }
      },
      onMemberInvited: (String groupID, V2TimGroupMemberInfo opUser,
          List<V2TimGroupMemberInfo> memberList) async {},
      onGroupDismissed: (String groupID, V2TimGroupMemberInfo member) {},
      onMemberKicked: (String groupID, V2TimGroupMemberInfo member,
          List<V2TimGroupMemberInfo> mems) {},
      onGroupRecycled: (String groupID, V2TimGroupMemberInfo member) {},
      onGroupAttributeChanged:
          (String groupID, Map<String, String> groupAttributeMap) async {
        //收到群属性更新的回调
      },
      onReceiveRESTCustomData: (String groupID, String customData) async {
        //收到 RESTAPI 下发的自定义系统消息
      },
    );
    TencentImSDKPlugin.v2TIMManager.addGroupListener(listener: groupListener);
  }

  addImGroupListener(IMMessageGroupListener listener) {
    imGroupListeners.add(listener);
  }

  removeImGroupListener(IMMessageGroupListener listener) {
    imGroupListeners.remove(listener);
  }

  //im 会话监听
  _imConversationListener() async {
    //设置会话监听器
    V2TimConversationListener listener = V2TimConversationListener(
      onConversationChanged: (List<V2TimConversation> conversationList) async {
        if (AuthController.to.isLogin) {
          for (var element in imConversationListeners) {
            element.onConversationChanged(conversationList);
          }
        }
      },
      onNewConversation: (List<V2TimConversation> conversationList) {
        if (AuthController.to.isLogin) {
          for (var element in imConversationListeners) {
            element.onConversationChanged(conversationList);
          }
        }
      },
      onSyncServerFailed: () => {
        //同步服务器会话失败
      },
      onSyncServerFinish: () => {
        //同步服务器会话完成，如果会话有变更，会通过 onNewConversation | onConversationChanged 回调告知客户
      },
      onSyncServerStart: () => {
        //同步服务器会话开始，SDK 会在登录成功或者断网重连后自动同步服务器会话，您可以监听这个事件做一些 UI 进度展示操作。
      },
      onTotalUnreadMessageCountChanged: (int totalUnreadCount) {
        //会话未读总数变更通知，未读总数会减去设置为免打扰的会话的未读数
        AppController.to.updateIMUnReadCount(totalUnreadCount);
      },
    );

    // 添加会话监听器
    await TencentImSDKPlugin.v2TIMManager
        .getConversationManager()
        .setConversationListener(listener: listener); //需要设置的会话监听器
  }

  addImConversationListener(IMConversationListener listener) {
    imConversationListeners.add(listener);
  }

  removeImConversationListener(IMConversationListener listener) {
    imConversationListeners.remove(listener);
  }

  /// ************************** 登录 & 用户相关 ***********************
  Future<V2TimCallback> login(String userID, String sig) async {
    V2TimCallback res = await TencentImSDKPlugin.v2TIMManager
        .login(userID: userID, userSig: sig);
    if (res.code == 0) {
      // 登录成功逻辑
      isLogin = true;
      LogUtils.onPrint("登录成功", tag: _tag);
    } else {
      // 登录失败逻辑
      isLogin = false;
      LogUtils.onPrint("登录失败", tag: _tag);
    }
    return res;
  }

  ///自己设置im信息
  Future setUserInfo({
    required String nickName,
    required String faceUrl,
    required String userID,
  }) async {
    if (userID == '-1') {
      return;
    }
    //TODO:未来再设置更多
    V2TimUserFullInfo userFullInfo = V2TimUserFullInfo(
      nickName: nickName, // 用户昵称
      allowType: 0, //用户的好友验证方式 0:允许所有人加我好友 1:不允许所有人加我好友 2:加我好友需我确认
      // birthday: 0,//用户生日
      // customInfo: {"custom": "custom"}, //用户的自定义状态 旗舰版支持修改此属性
      faceUrl: faceUrl, //用户头像 url
      // gender: 1, //用户的性别 1:男 2:女
      // level: 0, //用户的等级
      // role: 0, //用户的角色
      // selfSignature: "", //用户的签名
      userID: userID, //用户 ID
    );
    V2TimCallback setSelfInfoRes = await TencentImSDKPlugin.v2TIMManager
        .setSelfInfo(userFullInfo: userFullInfo); //用户资料设置信息
    if (setSelfInfoRes.code == 0) {
      // 修改成功
      LogUtils.onPrint("修改用户信息成功", tag: _tag);
    }
  }

  ///设置备注
  setRemark(int userID, {required String remark}) async {
    V2TimCallback callback = await TencentImSDKPlugin.v2TIMManager
        .getFriendshipManager()
        .setFriendInfo(
            userID: FormatUtil.getImUserId(userID.toString()),
            friendRemark: remark);
    return callback;
  }

  /// ************************** 操作相关 ***********************

  ///加入群组
  Future joinRoom(String groupID, {String msg = ''}) async {
    V2TimCallback res = await TencentImSDKPlugin.v2TIMManager
        .joinGroup(groupID: groupID, message: msg);
    if (res.code == 0) {
      // 登录成功逻辑
      LogUtils.onPrint("加入群组成功", tag: _tag);
    } else {
      // 登录失败逻辑
      LogUtils.onPrint("加入群组失败", tag: _tag);
    }
    return res;
  }

  ///离开群组
  leaveRoom(String groupID, String userId, {String msg = ''}) async {
    // 获取群资料
    V2TimValueCallback<List<V2TimGroupInfoResult>> groupinfos =
        await TencentImSDKPlugin.v2TIMManager.v2TIMGroupManager
            .getGroupsInfo(groupIDList: [groupID]);
    String? groupOwner = groupinfos.data?[0].groupInfo?.owner;
    if (userId != groupOwner) {
      V2TimCallback res =
          await TencentImSDKPlugin.v2TIMManager.quitGroup(groupID: groupID);
      if (res.code == 0) {
        LogUtils.onPrint("离开群组成功", tag: _tag);
      } else {
        LogUtils.onPrint("离开群组失败", tag: _tag);
      }
    }
  }

  ///获取未读数量失败
  Future<int> getTotalUnreadMessageCount() async {
    //获取会话未读总数
    V2TimValueCallback<int> getTotalUnreadMessageCountRes =
        await TencentImSDKPlugin.v2TIMManager
            .getConversationManager()
            .getTotalUnreadMessageCount();
    if (getTotalUnreadMessageCountRes.code != 0) {
      throw Exception('获取未读数量失败');
    }
    return getTotalUnreadMessageCountRes.data ?? 0;
  }

  ///获取c2c会话消息列表
  Future<List<V2TimConversation>> getC2CConversations(
      {int? count, int? nextSeq}) async {
    V2TimValueCallback<V2TimConversationResult> getConversationListRes =
        await TencentImSDKPlugin.v2TIMManager
            .getConversationManager()
            .getConversationListByFilter(
                filter: V2TimConversationFilter(conversationType: 1),
                count: count ?? 100,
                //分页拉取的个数，一次分页拉取不宜太多，会影响拉取的速度，建议每次拉取 100 个会话
                nextSeq:
                    nextSeq ?? 0 //分页拉取的游标，第一次默认取传 0，后续分页拉传上一次分页拉取成功回调里的 nextSeq
                );
    if (getConversationListRes.code == 0) {
      int count = 0;
      //拉取成功
      // bool? isFinished = getConversationListRes.data?.isFinished; //是否拉取完
      // String? nextSeq = getConversationListRes.data?.nextSeq; //后续分页拉取的游标
      Map<String, int> map = {};
      List<V2TimConversation> conversationList =
          (getConversationListRes.data?.conversationList ?? []).map((e) {
        count += e?.unreadCount ?? 0;
        map[e?.groupID ?? ''] = e?.unreadCount ?? 0;
        return e!;
      }).toList();
      AppController.to.updateIMUnReadCount(count);
      return conversationList;
    }
    return [];
  }

  ///获取历史消息
  Future<List<V2TimMessage>> getUserGetList(
      {required String userID, int? count, String? lastID}) async {
    // 拉取单聊历史消息
    // 首次拉取，lastMsgID 设置为 null
    // 再次拉取时，lastMsgID 可以使用返回的消息列表中的最后一条消息的id
    V2TimValueCallback<List<V2TimMessage>> msgList = await TencentImSDKPlugin
        .v2TIMManager
        .getMessageManager()
        .getC2CHistoryMessageList(
          userID: FormatUtil.getImUserId(userID),
          count: count ?? 20,
          lastMsgID: lastID,
        );
    if (msgList.code == 0) {
      return msgList.data ?? [];
    }
    return [];
  }

  ///删除会话
  Future deleteConversation(String conversationID) async {
    V2TimCallback deleteConversationRes = await TencentImSDKPlugin.v2TIMManager
        .getConversationManager()
        .deleteConversation(
          conversationID: conversationID, //需要删除的会话id
        );
    if (deleteConversationRes.code != 0) {
      //删除失败
      throw Exception('会话删除失败');
    }
  }

  ///删除消息
  Future deleteMessage(V2TimMessage message) async {
    // 删除本地及漫游消息
    V2TimCallback deleteMessagesRes = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .deleteMessages(
            msgIDs: [message.msgID ?? ''], // 需要删除的消息id
            webMessageInstanceList: [] // 需要删除的web端消息实例列表
            );
    if (deleteMessagesRes.code == 0) {
      //删除成功
    }
  }

  ///设置消息已读
  Future markC2CMessageAsRead(String sysUserID) async {
    // 设置单聊消息已读
    V2TimCallback markC2CMessageAsReadRes = await TencentImSDKPlugin
        .v2TIMManager
        .getMessageManager()
        .markC2CMessageAsRead(
          userID: FormatUtil.getImUserId(sysUserID),
        ); // 需要设置消息已读的用户id
    if (markC2CMessageAsReadRes.code != 0) {
      // 标记成功
      throw Exception('标记失败');
    }
  }

  /// 标记所有消息为已读
  Future markAllMessageAsRead() async {
    V2TimCallback markAllMessageAsReadRes = await TencentImSDKPlugin
        .v2TIMManager
        .getMessageManager()
        .markAllMessageAsRead();
    if (markAllMessageAsReadRes.code != 0) {
      // 标记成功
      throw Exception('清除消息失败');
    } else {
      AppController.to.updateIMUnReadCount(0);
    }
  }

  ///群内禁言
  Future muteGroupUser(
      {required String groupId,
      required String userId,
      required int seconds}) async {
    // 禁言群组内的用户
    V2TimCallback muteGroupMemberRes =
        await TencentImSDKPlugin.v2TIMManager.getGroupManager().muteGroupMember(
              groupID: groupId, // 禁言的群组id
              userID: userId, // 禁言的用户id
              seconds: seconds, // 禁言时间
            );
    if (muteGroupMemberRes.code != 0) {
      throw Exception('禁言失败');
    }
  }

  /// ************************** 消息发送 ***********************

  addMessageSendListener(IMMessageSendListener listener) {
    imSendListeners.add(listener);
  }

  removeMessageSendListener(IMMessageSendListener listener) {
    imSendListeners.remove(listener);
  }

  /// 发送文字消息
  Future<V2TimValueCallback<V2TimMessage>> sendTextMsg(
    String msg, {
    String? receiver,
    String? groupID,
    UserInfo? userInfo,
  }) async {
    if (msg.isEmpty) {
      throw Exception('信息不能为空');
    }
    AppCustomLoading.showLiteLoading();
    V2TimValueCallback<V2TimMsgCreateInfoResult> createTextMessageRes =
        await TencentImSDKPlugin.v2TIMManager
            .getMessageManager()
            .createTextMessage(
              text: msg, // 文本信息
            );
    if (createTextMessageRes.code != 0) {
      AppCustomLoading.hideLoading();
      throw Exception('createTextMessage error [${createTextMessageRes.data}]');
    }
    String? id = createTextMessageRes.data?.id;
    // 发送文本消息
    // 在sendMessage时，若只填写receiver则发个人用户单聊消息
    // 若只填写groupID则发群组消息
    // 若填写了receiver与groupID则发群内的个人用户，消息在群聊中显示，只有指定receiver能看见
    V2TimValueCallback<V2TimMessage> sendMessageRes =
        await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
              id: id!,
              receiver: FormatUtil.getImUserId(receiver ?? ''),
              groupID: groupID ?? '',
            );
    if (sendMessageRes.code != 0) {
      if ((sendMessageRes.code == 10016 || sendMessageRes.code == 20006) &&
          sendMessageRes.data?.textElem != null) {
        logger.d('识别到违规词');
        sendMessageRes.data?.textElem?.text = '***';
      }
      AppCustomLoading.hideLoading();
      throw Exception('sendTextMessage error [${sendMessageRes.data}]');
    }
    AppCustomLoading.hideLoading();
    if (AuthController.to.isLogin) {
      for (var element in imSendListeners) {
        element.onSendMessageSuccess(
            sysUserId: receiver, imGroupId: groupID, msg: sendMessageRes.data!);
      }
    }

    return sendMessageRes;
  }

  /// 发送语音消息
  Future<V2TimValueCallback<V2TimMessage>> sendAudioMsg(
    String audio,
    int duration, {
    String? receiver,
    String? groupID,
  }) async {
    if (audio.isEmpty) {
      ToastUtils.show('信息不能为空');
      throw Exception('信息不能为空');
    }
    AppCustomLoading.showLiteLoading();
    V2TimValueCallback<V2TimMsgCreateInfoResult> createTextMessageRes =
        await TencentImSDKPlugin.v2TIMManager
            .getMessageManager()
            .createSoundMessage(soundPath: audio, duration: duration);

    if (createTextMessageRes.code != 0) {
      AppCustomLoading.hideLoading();
      throw Exception('createTextMessage error [${createTextMessageRes.data}]');
    }
    String? id = createTextMessageRes.data?.id;
    // 发送文本消息
    // 在sendMessage时，若只填写receiver则发个人用户单聊消息
    //                 若只填写groupID则发群组消息
    //                 若填写了receiver与groupID则发群内的个人用户，消息在群聊中显示，只有指定receiver能看见
    V2TimValueCallback<V2TimMessage> sendMessageRes =
        await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
              id: id!,
              groupID: groupID ?? '',
              receiver: FormatUtil.getImUserId(receiver ?? ''),
            );

    if (sendMessageRes.code != 0) {
      AppCustomLoading.hideLoading();
      throw Exception('sendTextMessage error [${sendMessageRes.data}]');
    }
    AppCustomLoading.hideLoading();
    for (var element in imSendListeners) {
      element.onSendMessageSuccess(
          sysUserId: receiver, imGroupId: groupID, msg: sendMessageRes.data!);
    }

    return sendMessageRes;
  }

  /// 发送图片消息
  Future<V2TimValueCallback<V2TimMessage>> sendImageMsg(
    String img, {
    String? receiver,
    String? groupID,
  }) async {
    if (img.isEmpty) {
      ToastUtils.show('信息不能为空');
      throw Exception('信息不能为空');
    }
    AppCustomLoading.showLiteLoading();
    V2TimValueCallback<V2TimMsgCreateInfoResult> createTextMessageRes =
        await TencentImSDKPlugin.v2TIMManager
            .getMessageManager()
            .createImageMessage(
              imagePath: img,
            );

    if (createTextMessageRes.code != 0) {
      AppCustomLoading.hideLoading();
      throw Exception('createTextMessage error [${createTextMessageRes.data}]');
    }
    String? id = createTextMessageRes.data?.id;
    // 发送文本消息
    // 在sendMessage时，若只填写receiver则发个人用户单聊消息
    //                 若只填写groupID则发群组消息
    //                 若填写了receiver与groupID则发群内的个人用户，消息在群聊中显示，只有指定receiver能看见
    V2TimValueCallback<V2TimMessage> sendMessageRes =
        await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
              id: id!,
              groupID: groupID ?? '',
              receiver: FormatUtil.getImUserId(receiver ?? ''),
            );
    if (sendMessageRes.code != 0) {
      AppCustomLoading.hideLoading();
      throw Exception('sendTextMessage error [${sendMessageRes.data}]');
    }
    AppCustomLoading.hideLoading();
    for (var element in imSendListeners) {
      element.onSendMessageSuccess(
          sysUserId: receiver, imGroupId: groupID, msg: sendMessageRes.data!);
    }
    return sendMessageRes;
  }

  /// 发送自定义单聊消息
  Future<V2TimValueCallback<V2TimMessage>>
      sendC2CCustomMsg<T extends IMCustomMessageModel>(
    T? sendMsg,
    String msgType, {
    String? receiver,
    MessagePriorityEnum? priority,
  }) async {
    V2TimValueCallback<V2TimMsgCreateInfoResult> createTextMessageRes =
        await TencentImSDKPlugin.v2TIMManager
            .getMessageManager()
            .createCustomMessage(
              data: sendMsg != null
                  ? jsonEncode(
                      sendMsg.toJson(IMMsgType.getTypeByType(msgType)),
                    )
                  : '',
              desc: msgType,
            );

    if (createTextMessageRes.code != 0) {
      throw Exception('createTextMessage error [${createTextMessageRes.data}]');
    }
    String? id = createTextMessageRes.data?.id;
    // 发送文本消息
    // 在sendMessage时，若只填写receiver则发个人用户单聊消息
    //                 若只填写groupID则发群组消息
    //                 若填写了receiver与groupID则发群内的个人用户，消息在群聊中显示，只有指定receiver能看见
    V2TimValueCallback<V2TimMessage> sendMessageRes =
        await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
              id: id!,
              receiver: (receiver?.isNotEmpty == true)
                  ? FormatUtil.getImUserId(receiver ?? "")
                  : "",
              priority: priority ?? MessagePriorityEnum.V2TIM_PRIORITY_NORMAL,
              groupID: "",
            );
    if (sendMessageRes.code != 0) {
      throw Exception('sendTextMessage error [${sendMessageRes.data}]');
    }
    AppCustomLoading.hideLoading();
    for (var element in imSendListeners) {
      element.onSendMessageSuccess(
          sysUserId: receiver, imGroupId: null, msg: sendMessageRes.data!);
    }
    return sendMessageRes;
  }

  /// 发送群自定义消息
  Future<V2TimValueCallback<V2TimMessage>>
      sendGroupCustomMsg<T extends IMCustomMessageModel>(
    T? sendMsg,
    String msgType, {
    required String groupID,
    MessagePriorityEnum? priority,
    List<String> atUserList = const [],
  }) async {
    V2TimValueCallback<V2TimMsgCreateInfoResult> createTextMessageRes =
        await TencentImSDKPlugin.v2TIMManager
            .getMessageManager()
            .createCustomMessage(
              data: sendMsg != null
                  ? jsonEncode(
                      sendMsg.toJson(IMMsgType.getTypeByType(msgType)),
                    )
                  : '',
              desc: msgType,
            );

    if (createTextMessageRes.code != 0) {
      throw Exception('createTextMessage error [${createTextMessageRes.data}]');
    }
    String? id = createTextMessageRes.data?.id;
    // 发送文本消息
    // 在sendMessage时，若只填写receiver则发个人用户单聊消息
    // 若只填写groupID则发群组消息
    // 若填写了receiver与groupID则发群内的个人用户，消息在群聊中显示，只有指定receiver能看见
    V2TimValueCallback<V2TimMessage> sendMessageRes =
        await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
              id: id!,
              receiver: '',
              priority: priority ?? MessagePriorityEnum.V2TIM_PRIORITY_DEFAULT,
              groupID: groupID,
            );
    if (sendMessageRes.code != 0) {
      throw Exception('sendTextMessage error [${sendMessageRes.data}]');
    }
    for (var element in imSendListeners) {
      element.onSendMessageSuccess(
          sysUserId: null, imGroupId: groupID, msg: sendMessageRes.data!);
    }
    return sendMessageRes;
  }

  // 创建@文本消息
  /*
  Future<V2TimValueCallback<V2TimMessage>> sendGroupAtTextMsg(
    String msg, {
    required String groupID,
    MessagePriorityEnum? priority,
    List<String> atUserList = const [],
  }) async {
    V2TimValueCallback<V2TimMsgCreateInfoResult> createTextAtMessageRes =
        await TencentImSDKPlugin.v2TIMManager
            .getMessageManager()
            .createTextAtMessage(
              text: msg, // 文本信息
              atUserList: atUserList, // @用户ID列表 @所有人并@uesr1
            );
    // 文本信息创建成功
    String? id = createTextAtMessageRes.data?.id;
    // 发送@文本消息
    // 在sendMessage时，必须填写groupID，receiver必须为空，否则无法发送消息
    V2TimValueCallback<V2TimMessage> sendMessageRes = await TencentImSDKPlugin
        .v2TIMManager
        .getMessageManager()
        .sendMessage(id: id!, receiver: "", groupID: groupID);
    if (sendMessageRes.code == 0) {
      // 发送成功
    }
    if (sendMessageRes.code != 0) {
      throw Exception('sendGroupAtTextMsg error [${sendMessageRes.data}]');
    }
    return sendMessageRes;
  }
   */

  /// ************************** 其他方法 ***********************
  setLocalCustomIntRes(String msgID,int localCustomInt) async {
    // 设置消息自定义数据
    // 设置之后此消息会多出一个localCustomInt属性，用户可以读取此属性来获取设置的自定义属性
    V2TimCallback setLocalCustomIntRes = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .setLocalCustomInt(
        msgID: msgID, // 需要设置的消息id messageId为消息发送后服务端创建的messageid，不是创建消息时的消息id
        localCustomInt: localCustomInt); // 需要设置的自定义属性
    if (setLocalCustomIntRes.code == 0) {
       //设置成功
      print("suc");
    }
  }


  ///进入会话页面
  ///userId 用户系统id
  ///userName 用户名称
  pushToMessageDetail(
      {required int userId, required String userName, bool isOffPush = false}) {
    if (isOffPush) {
      Get.until((route) =>
          route.settings.name ==
          AppRouter().messagePages.messageDetailRoute.name);
    } else {
      Get.toNamed(AppRouter().messagePages.messageDetailRoute.name,
          preventDuplicates: false,
          arguments: {'userId': userId, 'userName': userName});
    }
  }

  ///退出
  logOut() async {
    imageState = IMState.noConnect;
    V2TimCallback logoutRes = await TencentImSDKPlugin.v2TIMManager.logout();
    if (logoutRes.code == 0) {
      //TODO: 暂时不反初始化 SDK,全局通用
      LogUtils.onPrint("退出成功", tag: _tag);
      // TencentImSDKPlugin.v2TIMManager.unInitSDK();
    }
  }
}
