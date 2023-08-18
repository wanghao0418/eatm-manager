/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-05-11 09:45:37
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-18 10:15:04
 * @FilePath: /mesui/lib/pages/common/customWebSocket.dart
 * @Description: websocket
 */
import 'dart:async';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// WebSocket状态
enum SocketStatus {
  SocketStatusConnected, // 已连接
  SocketStatusFailed, // 失败
  SocketStatusClosed, // 连接关闭
}

class WebSocketUtility {
  // WebSocket地址
  final String connectUrl;
  WebSocketChannel? _channel;
  final Function(String message) onMessage;
  Function onOpen = () {};
  Function onClose = () {};
  Function(String? error) onError = (error) {};

  WebSocketUtility(
      {required this.connectUrl,
      required this.onMessage,
      required this.onOpen,
      required this.onClose,
      required this.onError});

  // WebSocket
  WebSocketChannel? get instance => _channel;

  // socket状态
  SocketStatus? _socketStatus;

  // 心跳定时器
  Timer? _heartBeat;

  // 心跳间隔(毫秒)
  int _heartTimes = 3000;

  // 重连次数，默认60次
  int _reconnectCount = 5;

  // 重连计数器
  int _reconnectTimes = 0;

  // 重连定时器
  Timer? _reconnectTimer;

  void connect() {
    closeSocket();
    try {
      _channel = WebSocketChannel.connect(Uri.parse(connectUrl));
      _socketStatus = SocketStatus.SocketStatusConnected;
      // 连接成功，重置重连计数器
      _reconnectTimes = 0;
      if (_reconnectTimer != null) {
        _reconnectTimer!.cancel();
        _reconnectTimer = null;
      }
      onOpen();
      // 接收消息
      _channel!.stream.listen((message) {
        print('Received message: $message');
        onMessage(message);
      }, onError: (error) {
        print('WebSocket error: $error');
        WebSocketChannelException ex = error;
        PopupMessage.showFailInfoBar(ex.message ?? '');
        onError(ex.message);
        closeSocket();
      }, onDone: () {
        print('WebSocket connection closed');
        onClose();
      });
    } catch (e) {
      print('WebSocket connect error: $e');
      _socketStatus = SocketStatus.SocketStatusFailed;
      PopupMessage.showFailInfoBar(e.toString());
    }
  }

  /// 初始化心跳
  void initHeartBeat() {
    destroyHeartBeat();
    _heartBeat = Timer.periodic(Duration(milliseconds: _heartTimes), (timer) {
      sentHeart();
    });
  }

  /// 心跳
  void sentHeart() {
    sendMessage('{"module": "HEART_CHECK", "message": "请求心跳"}');
  }

  /// 销毁心跳
  void destroyHeartBeat() {
    if (_heartBeat != null) {
      _heartBeat!.cancel();
      _heartBeat = null;
    }
  }

  // 发送WebSocket消息
  void sendMessage(String message) {
    if (_channel != null) {
      switch (_socketStatus) {
        case SocketStatus.SocketStatusConnected:
          print('发送中：' + message);
          _channel!.sink.add(message);
          break;
        case SocketStatus.SocketStatusClosed:
          print('连接已关闭');
          break;
        case SocketStatus.SocketStatusFailed:
          print('发送失败');
          break;
        default:
          break;
      }
    }
  }

  /// 关闭WebSocket
  void closeSocket() {
    if (_channel != null) {
      print('WebSocket连接关闭');
      _channel!.sink.close();
      destroyHeartBeat();
      if (_reconnectTimer != null) {
        _reconnectTimer!.cancel();
        _reconnectTimer = null;
      }
      _socketStatus = SocketStatus.SocketStatusClosed;
    }
  }

  /// 重连机制
  void reconnect() {
    if (_reconnectTimes < _reconnectCount) {
      print('重连次数：$_reconnectTimes');
      _reconnectTimes++;
      _reconnectTimer =
          Timer.periodic(Duration(milliseconds: _heartTimes), (timer) {
        connect();
      });
    } else {
      if (_reconnectTimer != null) {
        print('重连次数超过最大次数');
        _reconnectTimer!.cancel();
        _reconnectTimer = null;
      }
      return;
    }
  }
}
