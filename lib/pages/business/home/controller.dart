/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-06 10:37:03
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-07 10:29:43
 * @FilePath: /eatm_manager/lib/pages/business/home/controller.dart
 * @Description: 逻辑层
 */
import 'package:eatm_manager/common/api/line_body_api.dart';
import 'package:eatm_manager/common/utils/log.dart';
import 'package:eatm_manager/pages/business/home/models.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  HomeController();
  List<MacRunData> macRunDataList = [];

  // 上午还是下午
  bool get isMorning => DateTime.now().hour < 12;

  // 线体平均稼动率
  double? get averageUtilizationRate => double.tryParse((macRunDataList
              .map((e) => double.tryParse(e.utilizationRate ?? '0'))
              .reduce((value, element) => value! + element!)! /
          macRunDataList.length)
      .toStringAsFixed(2));

  _initData() {
    update(["home"]);
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

  // 获取今日任务
  void getTodayTask() async {
    var res = await LineBodyApi.getTodayTaskNum();
    LogUtil.i(res);
    if (res.success!) {}
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    getLineBodyRunData();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
