/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-08 17:39:27
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-08 17:39:30
 * @FilePath: /eatm_manager/lib/pages/business/equipment_operation/models.dart
 * @Description: 结构体
 */
class EquipmentRunStatusData {
  String? machineName;
  String? startTime;
  String? endTime;
  String? state;
  String? machineNum;

  EquipmentRunStatusData(
      {this.machineName,
      this.startTime,
      this.endTime,
      this.state,
      this.machineNum});

  EquipmentRunStatusData.fromJson(Map<String, dynamic> json) {
    machineName = json['machineName'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    state = json['state'];
    machineNum = json['machineNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['machineName'] = this.machineName;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['state'] = this.state;
    data['machineNum'] = this.machineNum;
    return data;
  }
}
