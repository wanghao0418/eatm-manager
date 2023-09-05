/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-22 09:04:32
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-04 19:05:45
 * @FilePath: /eatm_manager/lib/pages/business/scheduling/multiple_machine_operation/controller.dart
 * @Description: 多机负荷逻辑层
 */
import 'dart:convert';

import 'package:eatm_manager/common/store/config.dart';
import 'package:eatm_manager/common/utils/log.dart';
import 'package:eatm_manager/common/utils/webSocket_utility.dart';
import 'package:eatm_manager/pages/business/scheduling/models.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MultipleMachineOperationController extends GetxController {
  MultipleMachineOperationController();
  // 机床排产信息列表
  List<DeviceResources> machineSchedulingInfoList = [];
  // 无人值守时长
  double duration = 4.0;
  // websocket
  WebSocketUtility? webSocketUtility;

  // 初始化WebSocket,失败则读取本地数据
  void initWebSocket() {
    var connectUrl = ConfigStore.instance.schedulingWebsocketUrl;
    webSocketUtility = WebSocketUtility(
        connectUrl: connectUrl!,
        onOpen: () {
          LogUtil.t('WebSocket连接成功');
          webSocketUtility!.sendMessage('SendStart#2#0#SendEnd');
        },
        onMessage: (data) {
          // LogUtil.t('WebSocket接收到消息：$data');
          var json = jsonDecode(data);
          if (json.toString().contains('deviceResources')) {
            var schedulingData = MacSchedulingData.fromJson(json);
            machineSchedulingInfoList = schedulingData.deviceResources ?? [];
            _initData();
          }
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
        await rootBundle.loadString('assets/json/test_multiple_mac_json.json');
    var schedulingData = MacSchedulingData.fromJson(jsonDecode(str));
    machineSchedulingInfoList = schedulingData.deviceResources ?? [];
    _initData();
  }

  _initData() {
    update(["multiple_machine_operation"]);
  }

  @override
  void onInit() {
    super.onInit();
    initWebSocket();
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
