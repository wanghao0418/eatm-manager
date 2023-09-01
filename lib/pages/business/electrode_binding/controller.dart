/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-01 10:02:57
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-01 18:30:03
 * @FilePath: /eatm_manager/lib/pages/business/electrode_binding/controller.dart
 * @Description: 多电极绑定视图层
 */
import 'dart:convert';

import 'package:eatm_manager/common/store/config.dart';
import 'package:eatm_manager/common/utils/log.dart';
import 'package:eatm_manager/common/utils/webSocket_utility.dart';
import 'package:eatm_manager/pages/business/electrode_binding/models.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ElectrodeBindingController extends GetxController {
  ElectrodeBindingController();

  // 当前选中索引
  int? currentIndex;

  // WebSocket
  WebSocketUtility? webSocketUtility;
  List<ChipBindData> chipBindDataList = [];

  // 初始化WebSocket,失败则读取本地数据
  void initWebSocket() {
    var connectUrl = ConfigStore.instance.chipBindingWebsocketUrl;
    webSocketUtility = WebSocketUtility(
        connectUrl: connectUrl!,
        onOpen: () {
          LogUtil.t('WebSocket连接成功');
        },
        onMessage: (data) {
          LogUtil.t('WebSocket接收到消息：$data');
          var json = jsonDecode(data);
          // var schedulingData = MacSchedulingData.fromJson(json);
          // machineSchedulingInfoList = schedulingData.deviceResources ?? [];
          _initData();
        },
        onError: (e) {
          LogUtil.f('WebSocket连接发生错误：$e');
          if (e.toString().contains('Connection refused') ||
              e.toString().contains('connection failed')) {
            readLocalData();
          }
        },
        onClose: () {
          LogUtil.f('WebSocket连接关闭：');
        });
    webSocketUtility!.connect();
  }

  // 读取本地数据
  void readLocalData() async {
    var str =
        await rootBundle.loadString('assets/json/test_chip_binding_json.json');
    var json = jsonDecode(str);
    chipBindDataList = (json['chipBindStl'] as List)
        .map((e) => ChipBindData.fromMap(e))
        .toList();
    _initData();
  }

  _initData() {
    update(["electrode_binding"]);
  }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    initWebSocket();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
