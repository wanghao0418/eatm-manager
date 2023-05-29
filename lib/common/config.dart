import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';

class GlobalConfig {
  String? localBaseUrl;
  String? devBaseUrl;
  String? productBaseUrl;
  int? connectTimeout;
  int? receiveTimeout;
  int? sendTimeout;
  int? mesPort;
  String? autoRunWebsocketUrL;

  GlobalConfig._();

  static GlobalConfig? _instance;

  static GlobalConfig get instance => _getInstance();

  static GlobalConfig _getInstance() {
    if (_instance == null) {
      _instance = GlobalConfig._();
    }
    return _instance!;
  }

  Map beanMap = Map();
  late GlobalConfig application;

  init() async {
    await loadApplication();
  }

  loadApplication() async {
    String config = await rootBundle.loadString('config/application.json');
    application = GlobalConfig.fromJson(json.decode(config));
  }

  addBean(String key, object) {
    beanMap[key] = object;
  }

  getBean(String key) {
    return beanMap[key];
  }

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
