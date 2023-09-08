/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-08 17:14:16
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-08 17:46:20
 * @FilePath: /eatm_manager/lib/pages/business/equipment_operation/controller.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:eatm_manager/common/api/line_body_api.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:eatm_manager/pages/business/equipment_operation/models.dart';
import 'package:get/get.dart';

class EquipmentOperationController extends GetxController {
  EquipmentOperationController();
  Map<String, List<EquipmentRunStatusData>> equipmentRunMap = {};

  _initData() {
    update(["equipment_operation"]);
  }

  // 获取设备运行状态信息
  void getEquipmentRunStatus() async {
    var res = await LineBodyApi.getEquipmentRunStatus();
    if (res.success!) {
      for (var info in res.data as List) {
        EquipmentRunStatusData data = EquipmentRunStatusData.fromJson(info);
        if (!equipmentRunMap.containsKey(data.machineNum)) {
          equipmentRunMap[data.machineNum!] = [data];
        } else {
          equipmentRunMap[data.machineNum!]!.add(data);
        }
      }
      _initData();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    getEquipmentRunStatus();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
