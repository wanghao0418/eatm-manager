/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-16 15:04:20
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-17 17:03:18
 * @FilePath: /eatm_manager/lib/pages/business/scheduling/single_machine_operation/controller.dart
 * @Description: 单机负荷逻辑层
 */
import 'package:get/get.dart';

class SingleMachineOperationController extends GetxController {
  SingleMachineOperationController();

  // 机床列表
  List machineList = [
    'okuma01',
    'okuma02',
    'okuma03',
    'okuma04',
    'okuma05',
    'okuma06',
    'okuma07',
  ];

  // 当前选中的机床
  String? currentMachine = 'okuma01';

  _initData() {
    update(["single_machine_operation"]);
  }

  void selectMachine(String machineName) {
    currentMachine = machineName;
    _initData();
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

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
