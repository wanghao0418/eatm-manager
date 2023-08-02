/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-05-11 09:45:37
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-02 16:22:19
 * @FilePath: /mesui/lib/pages/common/customWebSocket.dart
 * @Description: websocket
 */
import 'dart:async';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CustomWebSocket {
  final String connectUrl;
  late WebSocketChannel _channel;
  final Function(String message) onMessage;
  Function? onOpen = () {};
  Function? onClose = () {};
  Function? onError = () {};

  CustomWebSocket(
      {required this.connectUrl,
      required this.onMessage,
      this.onOpen,
      this.onClose,
      this.onError});

  // WebSocket
  WebSocketChannel? get instance => _channel;

  void connect() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(connectUrl));
      onOpen!();
      _channel.stream.listen((message) {
        print('Received message: $message');
        onMessage(message);
      }, onError: (error) {
        print('WebSocket error: $error');
        PopupMessage.showFailInfoBar(error.toString());
        onError!(error);
      }, onDone: () {
        print('WebSocket connection closed');
        onClose!();
      });
    } catch (e) {
      print('WebSocket connect error: $e');
      PopupMessage.showFailInfoBar(e.toString());
    }
  }

  void send(String message) {
    _channel.sink.add(message);
  }

  void close() {
    _channel.sink.close();
  }
}
