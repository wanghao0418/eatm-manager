/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-16 15:04:20
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-18 10:22:56
 * @FilePath: /eatm_manager/lib/pages/business/scheduling/single_machine_operation/controller.dart
 * @Description: 单机负荷逻辑层
 */
import 'dart:convert';

import 'package:eatm_manager/common/store/config.dart';
import 'package:eatm_manager/common/utils/webSocket_utility.dart';
import 'package:eatm_manager/pages/business/scheduling/single_machine_operation/models.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SingleMachineOperationController extends GetxController {
  SingleMachineOperationController();
  WebSocketUtility? webSocketUtility;

  // 机床列表
  List<String> machineList = [];

  // 当前选中的机床
  String? currentMachine;

  _initData() {
    update(["single_machine_operation"]);
  }

  // 初始化WebSocket,失败则读取本地数据
  void initWebSocket() {
    var connectUrl = ConfigStore.instance.schedulingWebsocketUrL;
    webSocketUtility = WebSocketUtility(
        connectUrl: connectUrl!,
        onOpen: () {},
        onError: (e) {
          readLocalData();
        },
        onMessage: (message) {
          print(message);
        },
        onClose: () {
          webSocketUtility = null;
        });
    webSocketUtility!.connect();
  }

  // 读取本地数据
  void readLocalData() async {
    String jsonStr =
        await rootBundle.loadString('assets/json/test_single_mac_json.json');
    final jsonData = SingleMacSchedulingData.fromJson(json.decode(jsonStr));
    machineList = jsonData.allMachineName ?? [];
  }

  void selectMachine(String machineName) {
    currentMachine = machineName;
    _initData();
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
