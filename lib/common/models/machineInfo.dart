/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-17 17:37:12
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-17 17:37:29
 * @FilePath: /eatm_manager/lib/common/models/machineInfo.dart
 * @Description: 机床信息
 */
import 'dart:convert';

class MachineInfo {
  MachineInfo({
    this.macBand,
    this.machineName,
    this.machineType,
    this.subProcedurename,
  });

  String? macBand;

  ///机床名称
  String? machineName;

  ///机床类型
  String? machineType;
  String? subProcedurename;

  factory MachineInfo.fromRawJson(String str) =>
      MachineInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MachineInfo.fromJson(Map<String, dynamic> json) => MachineInfo(
        macBand: json["macBand"],
        machineName: json["machineName"],
        machineType: json["machineType"],
        subProcedurename: json["subProcedurename"],
      );

  Map<String, dynamic> toJson() => {
        "macBand": macBand,
        "machineName": machineName,
        "machineType": machineType,
        "subProcedurename": subProcedurename,
      };
}
