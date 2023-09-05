/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-17 17:37:12
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-05 13:49:14
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

  factory MachineInfo.fromCapitalJson(Map<String, dynamic> json) => MachineInfo(
        macBand: json["MacBand"],
        machineName: json["MacName"],
        subProcedurename: json["SubProcedurename"],
      );

  Map<String, dynamic> toCapitalJson() => {
        "MacBand": macBand,
        "MacName": machineName,
        "SubProcedurename": subProcedurename,
      };
}

class MachineResource {
  List<MachineInfo?>? CNC;
  List<MachineInfo?>? EDM;
  List<MachineInfo?>? CMM;
  List<MachineInfo?>? CLEAN;

  MachineResource({this.CNC, this.EDM, this.CMM, this.CLEAN});

  factory MachineResource.fromRawJson(String str) =>
      MachineResource.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MachineResource.fromJson(Map<String, dynamic> json) =>
      MachineResource(
        CNC: json["CNC"] != null
            ? List<MachineInfo>.from(
                json["CNC"].map((x) => MachineInfo.fromCapitalJson(x)))
            : [],
        EDM: json["EDM"] != null
            ? List<MachineInfo>.from(
                json["EDM"].map((x) => MachineInfo.fromCapitalJson(x)))
            : [],
        CMM: json["CMM"] != null
            ? List<MachineInfo>.from(
                json["CMM"].map((x) => MachineInfo.fromCapitalJson(x)))
            : [],
        CLEAN: json["CLEAN"] != null
            ? List<MachineInfo>.from(
                json["CLEAN"].map((x) => MachineInfo.fromCapitalJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "CNC": List<dynamic>.from(CNC!.map((x) => x!.toCapitalJson())),
        "EDM": List<dynamic>.from(EDM!.map((x) => x!.toCapitalJson())),
        "CMM": List<dynamic>.from(CMM!.map((x) => x!.toCapitalJson())),
        "CLEAN": List<dynamic>.from(CLEAN!.map((x) => x!.toCapitalJson())),
      };
}
