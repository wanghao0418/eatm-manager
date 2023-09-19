/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-08 17:24:56
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-18 10:20:47
 * @FilePath: /eatm_manager/lib/pages/business/equipment_operation/enum.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';

enum EquipmentUtilizations {
  availability(
      status: 1, label: '可利用率', color: Color.fromARGB(255, 98, 208, 255)),
  utilization(
      status: 2, label: '利用率', color: Color.fromARGB(215, 106, 225, 104)),
  cuttingRate(status: 3, label: '切削率', color: Color.fromARGB(210, 34, 147, 51));

  final int status;
  final String label;
  final Color color;
  const EquipmentUtilizations(
      {required this.status, required this.label, required this.color});

  static EquipmentUtilizations? findByStatus(int status) {
    var index = EquipmentUtilizations.values.indexWhere(
        (EquipmentUtilizations element) => element.status == status);
    return index >= 0 ? EquipmentUtilizations.values[index] : null;
  }
}
