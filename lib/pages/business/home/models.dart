/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-06 17:52:22
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-06 17:52:25
 * @FilePath: /eatm_manager/lib/pages/business/home/models.dart
 * @Description: 结构体
 */
class MacRunData {
  String? utilizationRate;
  String? statisRunTime;
  String? machineSn;
  int? machineNum;
  int? status;
  int? type;
  int? number;
  int? machineState;
  String? machineType;
  String? statisticalTime;
  String? workpieceSn;

  MacRunData(
      {this.utilizationRate,
      this.statisRunTime,
      this.machineSn,
      this.machineNum,
      this.status,
      this.type,
      this.number,
      this.machineState,
      this.machineType,
      this.statisticalTime,
      this.workpieceSn});

  MacRunData.fromJson(Map<String, dynamic> json) {
    utilizationRate = json['UtilizationRate'];
    statisRunTime = json['statisRunTime'];
    machineSn = json['MachineSn'];
    machineNum = json['MachineNum'];
    status = json['status'];
    type = json['type'];
    number = json['number'];
    machineState = json['MachineState'];
    machineType = json['MachineType'];
    statisticalTime = json['statisticalTime'];
    workpieceSn = json['WorkpieceSn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UtilizationRate'] = this.utilizationRate;
    data['statisRunTime'] = this.statisRunTime;
    data['MachineSn'] = this.machineSn;
    data['MachineNum'] = this.machineNum;
    data['status'] = this.status;
    data['type'] = this.type;
    data['number'] = this.number;
    data['MachineState'] = this.machineState;
    data['MachineType'] = this.machineType;
    data['statisticalTime'] = this.statisticalTime;
    data['WorkpieceSn'] = this.workpieceSn;
    return data;
  }
}
