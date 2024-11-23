import 'dart:async';
import 'dart:convert';

import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/utils/log_utils.dart';
import 'package:youyu/config/config.dart';
import 'package:youyu/controllers/auth_controller.dart';
import 'package:youyu/models/web_socket_server_message.dart';
import 'package:youyu/services/socket/socket_msg_type.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum SocketConnectStatus {
  socketStatusConnected, // 已连接
  socketStatusFailed, // 失败
  socketStatusClosed, // 连接关闭
}

mixin SocketServiceReceiveListener {
  onWSConnectSuccess();

  onWSReceiveMessage(String type, dynamic data);
}

///web socket服务
class SocketService extends AppBaseController {
  static const String tag = "SocketService";

  static SocketService? _instance;

  factory SocketService() => _instance ??= SocketService._();

  SocketService._();

  IOWebSocketChannel? _webSocket;

  SocketConnectStatus? _socketConnectStatus;

  SocketConnectStatus get socketConnectStatus =>
      _socketConnectStatus ?? SocketConnectStatus.socketStatusClosed;

  //是否退出
  bool _isLogout = false;

  /// 心跳定时器
  Timer? _heartBeat;

  /// 心跳间隔(毫秒)
  final int _heartTimes = 20000;

  /// 重连次数
  final int _reconnectCount = 60;

  /// 重连计数器
  int _reconnectTimes = 0;

  /// 重连定时器
  Timer? _reconnectTimer;

  final List<SocketServiceReceiveListener> _listeners = [];

  @override
  onInit() async {
    super.onInit();
    openSocket();
  }

  openSocket({bool isReconnect = false}) async {
    int time1 = DateTime.now().millisecondsSinceEpoch;
    LogUtils.onInfo("Web Socket 开始链接", tag: tag);
    if (isReconnect) {
      closeSocket();
    }
    String wssConnectAddress =
        '${AppConfig.wsUrl}?token=${AuthController.to.token}';
    _webSocket = IOWebSocketChannel.connect(wssConnectAddress);
    int time2 = DateTime.now().millisecondsSinceEpoch;
    int totalTime = time2 - time1;
    LogUtils.onInfo("WebSocket 链接成功: $wssConnectAddress 耗时：$totalTime",
        tag: tag);
    await _webSocket?.ready;
    _socketConnectStatus = SocketConnectStatus.socketStatusConnected;
    _reconnectTimes = 0;
    if (_reconnectTimer != null) {
      _reconnectTimer!.cancel();
      _reconnectTimer = null;
    }
    //连接开启回调
    initHeartBeat();
    _webSocket?.stream.listen((event) => _webSocketOnMessage(event),
        onError: webSocketOnError, onDone: _webSocketOnDone);
    _isLogout = false;
    for (SocketServiceReceiveListener listener in _listeners) {
      listener.onWSConnectSuccess();
    }
  }

  /// WebSocket接收消息回调
  _webSocketOnMessage(data) {
    _onMessage(data);
  }

  /// WebSocket关闭连接回调
  _webSocketOnDone() {
    if (!_isLogout) {
      String wssConnectAddress =
          '${AppConfig.wsUrl}?token=${AuthController.to.token}';
      LogUtils.onInfo("WebSocket 关闭连接: $wssConnectAddress", tag: tag);
      _reconnect();
    }
  }

  /// WebSocket连接错误回调
  webSocketOnError(e) {
    WebSocketChannelException ex = e;
    _socketConnectStatus = SocketConnectStatus.socketStatusFailed;
    LogUtils.onError("WebSocket: ${ex.message}", tag: tag);
    closeSocket();
  }

  /// 初始化心跳
  void initHeartBeat() {
    _destroyHeartBeat();
    _heartBeat = Timer.periodic(Duration(milliseconds: _heartTimes), (timer) {
      sentHeart();
    });
  }

  /// 心跳
  void sentHeart() {
    sendMessage(
        '{"type": "${SocketMessageType.ping}", "token": "${AuthController.to.token}"}');
  }

  /// 销毁心跳
  void _destroyHeartBeat() {
    if (_heartBeat != null) {
      _heartBeat!.cancel();
      _heartBeat = null;
    }
  }

  /// 关闭WebSocket
  void closeSocket({bool isLogoutMethod = false}) {
    if (_webSocket != null) {
      String wssConnectAddress =
          '${AppConfig.wsUrl}?token=${AuthController.to.token}';
      LogUtils.onError("WebSocket: 关闭连接: $wssConnectAddress", tag: tag);
      if (isLogoutMethod) {
        _isLogout = true;
      }
      _webSocket!.sink.close();
      _destroyHeartBeat();
      _socketConnectStatus = SocketConnectStatus.socketStatusClosed;
    }
  }

  bool sendMessage(message) {
    if (_webSocket != null) {
      switch (_socketConnectStatus) {
        case SocketConnectStatus.socketStatusConnected:
          LogUtils.onError("WebSocket 消息发送中:  $message", tag: tag);
          _webSocket!.sink.add(message);
          return true;
        case SocketConnectStatus.socketStatusClosed:
          LogUtils.onError("WebSocket 消息发送失败: 连接已关闭", tag: tag);
          break;
        case SocketConnectStatus.socketStatusFailed:
          LogUtils.onError("WebSocket 消息发送失败", tag: tag);
          break;
        default:
      }
    }
    return false;
  }

  /// 重连机制
  void _reconnect() {
    if (_reconnectTimes < _reconnectCount) {
      _reconnectTimes++;
      _reconnectTimer =
          Timer.periodic(Duration(milliseconds: _heartTimes), (timer) {
        LogUtils.onError("WebSocket 重连了----", tag: tag);
        openSocket(isReconnect: true);
      });
    } else {
      if (_reconnectTimer != null) {
        LogUtils.onError("WebSocket 重连次数超过最大次数", tag: tag);
        _reconnectTimer!.cancel();
        _reconnectTimer = null;
      }
      return;
    }
  }

  addWSServiceListener(SocketServiceReceiveListener listener) {
    _listeners.add(listener);
  }

  removeWSServiceListener(SocketServiceReceiveListener listener) {
    _listeners.remove(listener);
  }

  /// 接受消息回调
  void _onMessage(data) {
    if (!AuthController.to.isLogin) return;
    WebSocketServerMessage message =
        WebSocketServerMessage.fromJson(jsonDecode(data));
    if (message.code != 1) {
      return;
    }
    LogUtils.onInfo("Web Socket 收到消息: $data", tag: tag);
    for (SocketServiceReceiveListener listener in _listeners) {
      listener.onWSReceiveMessage(message.type, message.data);
    }
  }
}
