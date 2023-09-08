/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-08 17:24:56
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-08 17:28:33
 * @FilePath: /eatm_manager/lib/pages/business/equipment_operation/enum.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';

enum EquipmentRunStatus {
  idle(status: 1, label: '空闲', color: Color(0xffc783ff)),
  running(status: 2, label: '正常', color: Color(0xff75d874)),
  debugging(status: 3, label: '未知', color: Color(0xffC0C0C0));

  final int status;
  final String label;
  final Color color;
  const EquipmentRunStatus(
      {required this.status, required this.label, required this.color});

  static EquipmentRunStatus? findByStatus(int status) {
    var index = EquipmentRunStatus.values
        .indexWhere((EquipmentRunStatus element) => element.status == status);
    return index >= 0 ? EquipmentRunStatus.values[index] : null;
  }
}
