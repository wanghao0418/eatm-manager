/*
 * @Description: 生产线控制逻辑层
 */
import 'dart:math';

import 'package:eatm_manager/common/api/line_body_api.dart';
import 'package:eatm_manager/pages/business/home/models.dart';
import 'package:get/get.dart';

class ProductionLineControlController extends GetxController {
  ProductionLineControlController();
  List<MacRunData> macRunDataList = [];
  List<MachineWorkInfo> macOrderList = [];

  _initData() {
    update(["production_line_control"]);
  }

  // 获取线体运行信息
  void getLineBodyRunData() async {
    var res = await LineBodyApi.getLineRunInfo();
    if (res.success!) {
      macRunDataList =
          (res.data as List).map((e) => MacRunData.fromJson(e)).toList();
      _initData();
    }
  }

  // 获取机床加工完成情况
  void getMachineProcessInfo() async {
    var res = await LineBodyApi.getMachineProcessInfo();
    if (res.success!) {
      List<MachineWorkInfo> dataList =
          (res.data as List).map((e) => MachineWorkInfo.fromJson(e)).toList();
      macOrderList = dataList;
      _initData();
    }
  }

  // 获取 0 到 10 随机 double
  double getRandomDouble(double min, double max) {
    Random random = Random();
    return min + random.nextDouble() * (max - min);
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    getLineBodyRunData();
    getMachineProcessInfo();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
