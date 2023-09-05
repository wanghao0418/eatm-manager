/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-16 15:04:20
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-05 09:18:52
 * @FilePath: /eatm_manager/lib/pages/business/scheduling/single_machine_operation/controller.dart
 * @Description: 单机负荷逻辑层
 */
import 'dart:async';
import 'dart:convert';

import 'package:eatm_manager/common/store/config.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:eatm_manager/common/utils/webSocket_utility.dart';
import 'package:eatm_manager/pages/business/scheduling/models.dart';
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

  // 当前选中的机床名称
  String? currentMachineName;

  // 当前选中的机床
  DeviceResources? currentMachine;

  // 监听当前选中的机床
  ValueNotifier<DeviceResources?> currentMachineNotifier =
      ValueNotifier<DeviceResources?>(null);

  // 当前加工工件信息
  ProductionOrders? get currentProductionOrder => currentMachine != null
      ? (currentMachine!.productionOrders!.isNotEmpty
          ? currentMachine!.productionOrders!.first
          : null)
      : null;

  // 当前预警刀具信息
  List<DeviceAlarmToolNoArr>? get currentAlarmTools =>
      currentMachine?.deviceAlarmToolNoArr ?? [];

  Timer? timer;

  _initData() {
    update(["single_machine_operation"]);
  }

  // 初始化WebSocket,失败则读取本地数据
  void initWebSocket() {
    var connectUrl = ConfigStore.instance.schedulingWebsocketUrl;
    webSocketUtility = WebSocketUtility(
        connectUrl: connectUrl!,
        onOpen: () {
          // 获取机床列表
          webSocketUtility?.sendMessage('SendStart#3#0#SendEnd');
        },
        onError: (e) {
          if (e.toString().contains('Connection refused') ||
              e.toString().contains('connection failed')) {
            readLocalData();
          }
        },
        onMessage: (message) {
          var data = json.decode(message);
          if (data is List) return;
          final jsonData = MacSchedulingData.fromJson(data);
          // 获取机床列表消息
          if (jsonData.allMachineName != null) {
            machineList = jsonData.allMachineName!;
            // 查询第一台机床信息
            currentMachineName = machineList[0];
            webSocketUtility
                ?.sendMessage('SendStart#2#$currentMachineName#SendEnd');
            // 定时获取当前机床数据
            timerGetMachineData();
          } else if (jsonData.deviceResources != null) {
            // 获取机床信息消息
            machineInfoList = jsonData.deviceResources!;
            currentMachineNotifier.value = machineInfoList.firstWhereOrNull(
                (element) => element.deviceName == currentMachineName);
          }
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
    final jsonData = MacSchedulingData.fromJson(json.decode(jsonStr));
    machineList = jsonData.allMachineName ?? [];
    machineInfoList = jsonData.deviceResources ?? [];
    currentMachineName = machineList[0];
    currentMachineNotifier.value =
        machineInfoList.isNotEmpty ? machineInfoList[0] : null;
  }

  // 定时获取当前机床数据
  void timerGetMachineData() {
    if (timer != null) {
      timer?.cancel();
    }
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      webSocketUtility?.sendMessage('SendStart#2#$currentMachineName#SendEnd');
    });
  }

  // 选择机床
  void selectMachine(String machineName) {
    if (machineName == currentMachineName) {
      return;
    }
    currentMachineName = machineName;
    webSocketUtility?.sendMessage('SendStart#4#$machineName#SendEnd');
    _initData();
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
