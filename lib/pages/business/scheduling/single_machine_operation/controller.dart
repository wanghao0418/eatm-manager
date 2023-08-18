/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-16 15:04:20
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-18 17:35:24
 * @FilePath: /eatm_manager/lib/pages/business/scheduling/single_machine_operation/controller.dart
 * @Description: 单机负荷逻辑层
 */
import 'dart:convert';

import 'package:eatm_manager/common/store/config.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:eatm_manager/common/utils/webSocket_utility.dart';
import 'package:eatm_manager/pages/business/scheduling/single_machine_operation/models.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class SingleMachineOperationController extends GetxController {
  SingleMachineOperationController();
  WebSocketUtility? webSocketUtility;
  List<PlutoRow> rows = [];
  late final PlutoGridStateManager stateManager;

  // 机床列表
  List<String> machineList = [];

  // 机床信息列表
  List<DeviceResources> machineInfoList = [];

  // 当前选中的机床
  DeviceResources? currentMachine;

  // 监听当前选中的机床
  ValueNotifier<DeviceResources?> currentMachineNotifier =
      ValueNotifier<DeviceResources?>(null);

  // 当前加工工件信息
  ProductionOrders? get currentProductionOrder =>
      currentMachine?.productionOrders?.first;

  // 当前预警刀具信息
  List<DeviceAlarmToolNoArr>? get currentAlarmTools =>
      currentMachine?.deviceAlarmToolNoArr ?? [];

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
    machineInfoList = jsonData.deviceResources ?? [];
    currentMachineNotifier.value =
        machineInfoList.isNotEmpty ? machineInfoList[0] : null;
  }

  // 选择机床
  void selectMachine(String machineName) {
    // currentMachine = machineName;
    currentMachine = machineInfoList
        .firstWhere((element) => element.deviceName == machineName);
    if (currentMachine != null) {
      _initData();
    }
  }

  // 更新刀具报警表格
  void updateRows() {
    rows.clear();
    for (var data in currentAlarmTools!) {
      stateManager.appendRows([
        PlutoRow(
          cells: {
            'toolTypeNo': PlutoCell(value: data.toolTypeNo),
            'theoreticalTime': PlutoCell(value: data.theoreticalTime),
            'usedTime': PlutoCell(value: data.usedTime),
            'alarmTip': PlutoCell(value: data.alarmTip),
          },
        )
      ]);
    }
    _initData();
  }

  @override
  void onInit() {
    super.onInit();
    initWebSocket();
    currentMachineNotifier.addListener(() {
      currentMachine = currentMachineNotifier.value;
      updateRows();
    });
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    super.onClose();
    webSocketUtility?.closeSocket();
    currentMachineNotifier.dispose();
  }
}
