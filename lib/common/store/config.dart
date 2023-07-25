import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../utils/http.dart';

class ConfigStore extends GetxController {
  static ConfigStore get instance => Get.find<ConfigStore>();

  String? localBaseUrl = 'http://localhost:8081';
  String? devBaseUrl = 'http://localhost:8081';
  String? productBaseUrl = 'http://localhost:8081';
  int? connectTimeout = 5000;
  int? receiveTimeout = 5000;
  int? sendTimeout = 5000;
  int? mesPort = 8098;
  String? autoRunWebsocketUrL = 'ws://localhost:8092';

  @override
  void onInit() async {
    // TODO: implement onInit
    loadApplication();
    super.onInit();
  }

  loadApplication() async {
    String config = await rootBundle.loadString('config/application.json');
    var globalConfig = GlobalConfig.fromJson(json.decode(config));
    localBaseUrl = globalConfig.localBaseUrl;
    devBaseUrl = globalConfig.devBaseUrl;
    productBaseUrl = globalConfig.productBaseUrl;
    connectTimeout = globalConfig.connectTimeout;
    receiveTimeout = globalConfig.receiveTimeout;
    sendTimeout = globalConfig.sendTimeout;
    mesPort = globalConfig.mesPort;
    autoRunWebsocketUrL = globalConfig.autoRunWebsocketUrL;
    _readArguments();
  }

  // 读取启动参数
  Future<void> _readArguments() async {
    var env = const String.fromEnvironment('APP_ENV', defaultValue: 'product');
    print(env);
    // 根据启动参数设置当前的环境
    final String environment = env; // 默认为生产环境
    switch (environment) {
      case 'local':
        HttpUtil.setBaseUrl(ConfigStore.instance.localBaseUrl!);
        break;
      case 'dev':
        HttpUtil.setBaseUrl(ConfigStore.instance.devBaseUrl!);
        break;
      case 'product':
        HttpUtil.setBaseUrl(ConfigStore.instance.productBaseUrl!);
        break;
      default:
        // 未知环境
        break;
    }
  }
}

class GlobalConfig {
  String? localBaseUrl;
  String? devBaseUrl;
  String? productBaseUrl;
  int? connectTimeout;
  int? receiveTimeout;
  int? sendTimeout;
  int? mesPort;
  String? autoRunWebsocketUrL;

  GlobalConfig(
      {this.localBaseUrl,
      this.devBaseUrl,
      this.productBaseUrl,
      this.connectTimeout,
      this.receiveTimeout,
      this.sendTimeout,
      this.mesPort,
      this.autoRunWebsocketUrL});

  GlobalConfig.fromJson(Map<String, dynamic> json) {
    localBaseUrl = json['localBaseUrl'];
    devBaseUrl = json['DevBaseUrl'];
    productBaseUrl = json['ProductBaseUrl'];
    connectTimeout = json['connectTimeout'];
    receiveTimeout = json['receiveTimeout'];
    sendTimeout = json['sendTimeout'];
    mesPort = json['mesPort'];
    autoRunWebsocketUrL = json['autoRunWebsocketUrL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['localBaseUrl'] = this.localBaseUrl;
    data['DevBaseUrl'] = this.devBaseUrl;
    data['ProductBaseUrl'] = this.productBaseUrl;
    data['connectTimeout'] = this.connectTimeout;
    data['receiveTimeout'] = this.receiveTimeout;
    data['sendTimeout'] = this.sendTimeout;
    data['mesPort'] = this.mesPort;
    data['autoRunWebsocketUrL'] = this.autoRunWebsocketUrL;
    return data;
  }
}

enum Environment {
  Local(value: 'local'),
  Dev(value: 'dev'),
  Product(value: 'product');

  const Environment({required this.value});

  final String value;
}
