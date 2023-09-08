/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-06 10:37:03
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-08 13:51:58
 * @FilePath: /eatm_manager/lib/pages/business/home/controller.dart
 * @Description: 逻辑层
 */
import 'dart:async';

import 'package:eatm_manager/common/api/line_body_api.dart';
import 'package:eatm_manager/pages/business/home/models.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  HomeController();
  List<MacRunData> macRunDataList = [];
  TodayMacTaskNum? todayMacTaskNum;
  Map<String, List<CompletedNumData>> totalTaskNumMap = {};
  List<ChartSampleData> chartData = [];
  late Timer timer;
  List<MachineAlarmInfo> machineAlarmInfoList = [];

  // 上午还是下午
  bool get isMorning => DateTime.now().hour < 12;

  // 线体平均稼动率
  double? get averageUtilizationRate => macRunDataList.isNotEmpty
      ? double.tryParse((macRunDataList
                  .map((e) => double.tryParse(
                      (e.utilizationRate != null && e.utilizationRate != '')
                          ? e.utilizationRate!
                          : '0'))
                  .reduce((value, element) => value! + element!)! /
              macRunDataList.length)
          .toStringAsFixed(2))
      : 0;

  // 获取线体运行信息
  void getLineBodyRunData() async {
    var res = await LineBodyApi.getLineRunInfo();
    if (res.success!) {
      macRunDataList =
          (res.data as List).map((e) => MacRunData.fromJson(e)).toList();
      _initData();
    }
  }

  // 获取今日任务
  void getTodayTask() async {
    var res = await LineBodyApi.getTodayTaskNum();
    if (res.success!) {
      todayMacTaskNum = TodayMacTaskNum.fromJson((res.data as List).first);
      _initData();
    }
  }

  // 获取累计任务数
  void getTotalTask() async {
    var res = await LineBodyApi.getTotalFinishNum();
    if (res.success!) {
      TotalTaskNum data = TotalTaskNum.fromJson(res.data);
      totalTaskNumMap = {
        "本日": data.day ?? [],
        "本周": data.week ?? [],
        "本月": data.month ?? [],
        "本年": data.year ?? []
      };
      _initData();
    }
  }

  // 获取机床加工完成情况
  void getMachineProcessInfo() async {
    var res = await LineBodyApi.getMachineProcessInfo();
    if (res.success!) {
      List<MachineWorkInfo> dataList =
          (res.data as List).map((e) => MachineWorkInfo.fromJson(e)).toList();
      chartData = dataList
          .map(
            (e) => ChartSampleData(
                x: e.machineSn ?? '',
                y: e.waitWorkNum ?? 0,
                secondSeriesYValue: e.completeNum ?? 0),
          )
          .toList();
      _initData();
    }
  }

  // 获取报警信息
  void getMachineAlarmInfo() async {
    var res = await LineBodyApi.getMachineAlarmInfo();
    if (res.success!) {
      machineAlarmInfoList =
          (res.data as List).map((e) => MachineAlarmInfo.fromJson(e)).toList();
      _initData();
    }
  }

  // 批量获取数据
  void getDataInBatches() {
    getLineBodyRunData();
    getMachineProcessInfo();
    getMachineAlarmInfo();
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  _initData() {
    update(["home"]);
  }

  @override
  void onReady() {
    super.onReady();
    getTodayTask();
    getTotalTask();
    getDataInBatches();
    timer = Timer.periodic(
        const Duration(seconds: 30), (timer) => getDataInBatches());
    _initData();
  }

  @override
  void onClose() {
    super.onClose();
    timer.cancel();
  }
}
