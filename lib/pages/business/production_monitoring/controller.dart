/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-11 10:05:54
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-11 11:25:37
 * @FilePath: /eatm_manager/lib/pages/business/production_monitoring/controller.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';

class ProductionMonitoringController extends GetxController {
  ProductionMonitoringController();

  _initData() {
    update(["production_monitoring"]);
  }

  void onTap() {}

  @override
  void onInit() {
    super.onInit();
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
