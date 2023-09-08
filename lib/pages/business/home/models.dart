/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-06 17:52:22
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-08 13:51:41
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

class TodayMacTaskNum {
  String? cncTotal;
  String? edmTotal;
  String? cmmTotal;
  String? cleanTotal;
  String? dryTotal;

  TodayMacTaskNum(
      {this.cncTotal,
      this.edmTotal,
      this.cmmTotal,
      this.cleanTotal,
      this.dryTotal});

  TodayMacTaskNum.fromJson(Map<String, dynamic> json) {
    cncTotal = json['CNC_TOTAL'];
    edmTotal = json['EDM_TOTAL'];
    cmmTotal = json['CMM_TOTAL'];
    cleanTotal = json['CLEAN_TOTAL'];
    dryTotal = json['DRY_TOTAL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CNC_TOTAL'] = this.cncTotal;
    data['EDM_TOTAL'] = this.edmTotal;
    data['CMM_TOTAL'] = this.cmmTotal;
    data['CLEAN_TOTAL'] = this.cleanTotal;
    data['DRY_TOTAL'] = this.dryTotal;
    return data;
  }
}

class TotalTaskNum {
  List<CompletedNumData>? day;
  List<CompletedNumData>? week;
  List<CompletedNumData>? month;
  List<CompletedNumData>? year;

  TotalTaskNum({this.day, this.week, this.month, this.year});

  TotalTaskNum.fromJson(Map<String, dynamic> json) {
    if (json['Day'] != null) {
      day = <CompletedNumData>[];
      json['Day'].forEach((v) {
        day!.add(CompletedNumData.fromJson(v));
      });
    }
    if (json['Week'] != null) {
      week = <CompletedNumData>[];
      json['Week'].forEach((v) {
        week!.add(CompletedNumData.fromJson(v));
      });
    }
    if (json['Month'] != null) {
      month = <CompletedNumData>[];
      json['Month'].forEach((v) {
        month!.add(CompletedNumData.fromJson(v));
      });
    }
    if (json['Year'] != null) {
      year = <CompletedNumData>[];
      json['Year'].forEach((v) {
        year!.add(CompletedNumData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.day != null) {
      data['Day'] = this.day!.map((v) => v.toJson()).toList();
    }
    if (this.week != null) {
      data['Week'] = this.week!.map((v) => v.toJson()).toList();
    }
    if (this.month != null) {
      data['Month'] = this.month!.map((v) => v.toJson()).toList();
    }
    if (this.year != null) {
      data['Year'] = this.year!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CompletedNumData {
  int? numberCompletedCNC;
  int? numberCompletedEDM;
  int? numberCompletedCMM;
  int? numberCompletedCLEAN;
  int? numberCompletedDRY;

  CompletedNumData(
      {this.numberCompletedCNC,
      this.numberCompletedEDM,
      this.numberCompletedCMM,
      this.numberCompletedCLEAN,
      this.numberCompletedDRY});

  CompletedNumData.fromJson(Map<String, dynamic> json) {
    numberCompletedCNC = json['NumberCompleted_CNC'];
    numberCompletedEDM = json['NumberCompleted_EDM'];
    numberCompletedCMM = json['NumberCompleted_CMM'];
    numberCompletedCLEAN = json['NumberCompleted_CLEAN'];
    numberCompletedDRY = json['NumberCompleted_DRY'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NumberCompleted_CNC'] = this.numberCompletedCNC;
    data['NumberCompleted_EDM'] = this.numberCompletedEDM;
    data['NumberCompleted_CMM'] = this.numberCompletedCMM;
    data['NumberCompleted_CLEAN'] = this.numberCompletedCLEAN;
    data['NumberCompleted_DRY'] = this.numberCompletedDRY;
    return data;
  }
}

class ChartSampleData {
  String x;
  num y;
  num? secondSeriesYValue;
  num? thirdSeriesYValue;
  String? text;
  ChartSampleData(
      {required this.x,
      required this.y,
      this.secondSeriesYValue,
      this.thirdSeriesYValue,
      this.text});
}

class MachineWorkInfo {
  String? machineSn;
  int? waitWorkNum;
  int? completeNum;
  int? machineNum;

  MachineWorkInfo(
      {this.machineSn, this.waitWorkNum, this.completeNum, this.machineNum});

  MachineWorkInfo.fromJson(Map<String, dynamic> json) {
    machineSn = json['MachineSn'];
    waitWorkNum = json['WaitWorkNum'];
    completeNum = json['CompleteNum'];
    machineNum = json['MachineNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MachineSn'] = this.machineSn;
    data['WaitWorkNum'] = this.waitWorkNum;
    data['CompleteNum'] = this.completeNum;
    data['MachineNum'] = this.machineNum;
    return data;
  }
}

class MachineAlarmInfo {
  String? machineNum;
  String? macAlarmInfo;
  String? alarmTime;

  MachineAlarmInfo({this.machineNum, this.macAlarmInfo, this.alarmTime});

  MachineAlarmInfo.fromJson(Map<String, dynamic> json) {
    machineNum = json['MachineNum'];
    macAlarmInfo = json['MacAlarmInfo'];
    alarmTime = json['AlarmTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MachineNum'] = this.machineNum;
    data['MacAlarmInfo'] = this.macAlarmInfo;
    data['AlarmTime'] = this.alarmTime;
    return data;
  }
}
