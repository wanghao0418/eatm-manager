/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-21 14:33:18
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-12 18:51:17
 * @FilePath: /eatm_manager/lib/pages/business/scheduling/plan_gantt_chart/controller.dart
 * @Description: 计划甘特图逻辑层
 */
import 'dart:convert';

import 'package:eatm_manager/common/store/config.dart';
import 'package:eatm_manager/common/utils/log.dart';
import 'package:eatm_manager/common/utils/webSocket_utility.dart';
import 'package:eatm_manager/pages/business/scheduling/plan_gantt_chart/models.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PlanGanttChartController extends GetxController {
  PlanGanttChartController();
  late DateTime fromDate;
  late DateTime toDate;
  // 时间间隔
  double interval = 1;
  // 时间间隔宽度
  double get intervalWidth => 200.r;
  final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
  WebSocketUtility? webSocketUtility;

  // 时间间隔数量
  int get viewNum => 24 ~/ interval.ceil();

  // 机床排产信息列表
  List<MachineSchedulingInfo> machineSchedulingInfoList = [];

  // 初始化WebSocket,失败则读取本地数据
  void initWebSocket() {
    var connectUrl = ConfigStore.instance.schedulingWebsocketUrl;
    webSocketUtility = WebSocketUtility(
        connectUrl: connectUrl!,
        onOpen: () {
          webSocketUtility?.sendMessage('SendStart#1#0#SendEnd');
        },
        onError: (e) {
          if (e.toString().contains('Connection refused') ||
              e.toString().contains('connection failed')) {
            readLocalData();
          }
        },
        onMessage: (message) {
          if (!message.contains('deviceResources')) {
            var list = json.decode(message);
            if (list is List) {
              machineSchedulingInfoList.clear();
              machineSchedulingInfoList =
                  list.map((e) => MachineSchedulingInfo.fromJson(e)).toList();
              _updateCharts();
            }
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
        await rootBundle.loadString('assets/json/test_plan_gantt_json.json');
    machineSchedulingInfoList = (json.decode(jsonStr) as List)
        .map((e) => MachineSchedulingInfo.fromJson(e))
        .toList();
    _updateCharts();
  }

  // 初始化数据
  _updateCharts() {
    // 获取最早的开始时间
    DateTime? earliestStartTime;
    for (var macData in machineSchedulingInfoList) {
      var minTimeOrder = macData.list!.reduce((value, element) =>
          DateTime.parse(element.startTime!)
                  .isBefore(DateTime.parse(value.startTime!))
              ? element
              : value);
      if (earliestStartTime == null) {
        earliestStartTime = DateTime.parse(minTimeOrder.startTime!);
      } else if (DateTime.parse(minTimeOrder.startTime!)
              .isBefore(earliestStartTime) &&
          (minTimeOrder.startTime != minTimeOrder.endTime)) {
        earliestStartTime = DateTime.parse(minTimeOrder.startTime!);
      }
    }
    LogUtil.i('最早时间');
    LogUtil.i(earliestStartTime.toString());
    // 更新开始时间
    if (earliestStartTime != null) {
      fromDate = DateTime(earliestStartTime.year, earliestStartTime.month,
          earliestStartTime.day, earliestStartTime.hour, 0);
      toDate = fromDate.add(const Duration(days: 1));
      _initData();
    }
  }

  _initData() {
    update(["plan_gantt_chart"]);
  }

  @override
  void onInit() {
    super.onInit();
    initWebSocket();
    fromDate = DateTime.now();
    toDate = DateTime.now().add(const Duration(days: 1));
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
