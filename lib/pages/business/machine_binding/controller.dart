/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-09 15:34:58
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-10 14:03:10
 * @FilePath: /eatm_manager/lib/pages/business/machine_binding/controller.dart
 * @Description: 机床绑定逻辑层
 */
import 'dart:convert';

import 'package:eatm_manager/common/api/machine_binding_api.dart';
import 'package:eatm_manager/common/models/selectOption.dart';
import 'package:eatm_manager/common/utils/http.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class MachineBindingController extends GetxController {
  MachineBindingController();
  MachineBindingSearch search = MachineBindingSearch(
    querySource: 1,
    workpiecetype: 2,
    isSelect: true,
    startTime: DateTime.now().toString().substring(0, 10),
    endTime: DateTime.now().add(Duration(days: 3)).toString().substring(0, 10),
  );
  List<PlutoRow> rows = [];
  late PlutoGridStateManager stateManager;
  List<WorkProcessData> workProcessDataList = [];
  // 选中模号
  List<String> selectedMouldSNList = [];

  // 工件类型
  List<SelectOption> get workpieceTypeList => [
        SelectOption(label: '全部', value: 0),
        SelectOption(label: '电极', value: 1),
        SelectOption(label: '钢件', value: 2),
      ];

  // 机床子程序机台名称映射
  Map<String, List> machineMap = {};

  // 当前选中机床子程序
  String? currentMachineType;

  // 当前选中机台名称
  String? currentMachineName;

  // 机床类型
  List<SelectOption> get machineTypeList => machineMap.keys.isEmpty
      ? [
          SelectOption(label: '全部', value: null),
        ]
      : machineMap.keys.map((e) => SelectOption(label: e, value: e)).toList();

  // 机台编号
  List<SelectOption> get machineNameList => currentMachineType == null
      ? [
          SelectOption(label: '', value: null),
        ]
      : machineMap[currentMachineType]!
          .map((e) => SelectOption(label: e['MacName'], value: e['MacName']))
          .toList();

  _initData() {
    update(["machine_binding"]);
  }

  // 获取机床资源
  void getMachineResource() async {
    ResponseApiBody res = await MachineBindingApi.getMachineResource({});
    if (res.success!) {
      var data = res.data as Map;
      for (var macType in data.keys) {
        for (var macInfo in data[macType]!) {
          // print(macInfo);
          var subProcedureName = macInfo['SubProcedurename'];
          if (machineMap.keys.contains(subProcedureName) == false) {
            machineMap[subProcedureName] = [macInfo];
          } else {
            machineMap[subProcedureName]!.add(macInfo);
          }
        }
      }
      // print(machineMap);
      // 默认选中第一个机床类型
      currentMachineType =
          machineMap.keys.isNotEmpty ? machineMap.keys.first : null;
      // 默认选中第一个机台名称
      if (currentMachineType != null) {
        currentMachineName = machineMap[currentMachineType!]!.isNotEmpty
            ? machineMap[currentMachineType!]!.first['MacName']
            : null;
      }
      _initData();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 查询
  void query() async {
    PopupMessage.showLoading();
    ResponseApiBody res =
        await MachineBindingApi.query({"params": search.toJson()});
    PopupMessage.closeLoading();
    if (res.success!) {
      List<WorkProcessData> data =
          (res.data as List).map((e) => WorkProcessData.fromJson(e)).toList();
      workProcessDataList = data;
      updateRows();
      _initData();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 更新表格
  void updateRows() {
    // 重置表格
    selectedMouldSNList = [];
    stateManager.setFilter(null);
    rows.clear();
    for (var e in workProcessDataList) {
      var index = workProcessDataList.indexOf(e);
      stateManager.appendRows([
        PlutoRow(cells: {
          'number': PlutoCell(value: index + 1),
          'barCode': PlutoCell(value: e.barCode),
          'machineSN': PlutoCell(value: e.machineSn),
          'workpieceType': PlutoCell(value: e.workpieceType),
          'mouldSN': PlutoCell(value: e.mouldsn),
          'partSN': PlutoCell(value: e.partsn),
          'mwpieceCode': PlutoCell(value: e.mwpiececode),
          'mwpieceName': PlutoCell(value: e.mwpiecename),
          'resoucenamedept': PlutoCell(value: e.resoucenamedept),
          'spec': PlutoCell(value: e.spec),
          'data': PlutoCell(value: e.toJson()),
        })
      ]);
    }
    _initData();
  }

  // 模号列表
  List<String> get mouldSNList =>
      workProcessDataList.map((e) => e.mouldsn!).toSet().toList();

  // 绑定
  void binding() async {
    if (currentMachineName == null) {
      PopupMessage.showWarningInfoBar('请选择机台名称');
      return;
    }

    if (stateManager.checkedRows.isEmpty) {
      PopupMessage.showWarningInfoBar('请选择需要绑定的数据');
      return;
    }
    PopupMessage.showLoading();
    ResponseApiBody res = await MachineBindingApi.binding({
      "params": {
        "MacName": currentMachineName,
        "list":
            stateManager.checkedRows.map((e) => e.cells['data']!.value).toList()
      }
    });
    PopupMessage.closeLoading();
    if (res.success!) {
      PopupMessage.showSuccessInfoBar('绑定成功');
      for (var row in stateManager.checkedRows) {
        row.cells['machineSN']!.value = currentMachineName;
      }
      stateManager.toggleAllRowChecked(false);
      _initData();
      // query();
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
    getMachineResource();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}

class MachineBindingSearch {
  int? workmanship;
  int? workpiecetype;
  String? mouldsn;
  String? partsn;
  String? startTime;
  String? endTime;
  String? barcode;
  String? mwpiececode;
  bool? isSelect;
  int? querySource;

  MachineBindingSearch(
      {this.workmanship,
      this.workpiecetype,
      this.mouldsn,
      this.partsn,
      this.startTime,
      this.endTime,
      this.barcode,
      this.mwpiececode,
      this.isSelect,
      this.querySource});

  MachineBindingSearch.fromJson(Map<String, dynamic> json) {
    workmanship = json['workmanship'];
    workpiecetype = json['workpiecetype'];
    mouldsn = json['mouldsn'];
    partsn = json['partsn'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    barcode = json['barcode'];
    mwpiececode = json['Mwpiececode'];
    isSelect = json['isSelect'];
    querySource = json['querySource'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['workmanship'] = this.workmanship;
    data['workpiecetype'] = this.workpiecetype;
    data['mouldsn'] = this.mouldsn;
    data['partsn'] = this.partsn;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['barcode'] = this.barcode;
    data['Mwpiececode'] = this.mwpiececode;
    data['isSelect'] = this.isSelect;
    data['querySource'] = this.querySource;
    return data;
  }
}

///工艺流程信息
class WorkProcessData {
  WorkProcessData({
    this.barCode,
    this.bomType,
    this.clamptype,
    this.curprocorder,
    this.curprocstate,
    this.machineSn,
    this.mouldsn,
    this.mwcount,
    this.mwpiececode,
    this.mwpiecename,
    this.partsn,
    this.procedurename,
    this.processroute,
    this.procetotal,
    this.pstePid,
    this.recordtime,
    this.resoucenamedept,
    this.resourceName,
    this.sn,
    this.spec,
    this.trayType,
    this.workpieceType,
    this.wpstate,
  });

  ///芯片Id
  String? barCode;
  String? bomType;
  String? clamptype;
  int? curprocorder;
  int? curprocstate;

  ///机床编号
  String? machineSn;

  ///模号
  String? mouldsn;
  String? mwcount;

  ///监控编号
  String? mwpiececode;

  ///工件名称
  String? mwpiecename;

  ///件号
  String? partsn;
  String? procedurename;
  String? processroute;
  int? procetotal;
  int? pstePid;
  String? recordtime;

  ///资源名称
  String? resoucenamedept;

  ///资源名称
  String? resourceName;

  ///编号
  String? sn;

  ///规格
  String? spec;
  String? trayType;

  ///工件类型
  String? workpieceType;
  String? wpstate;

  factory WorkProcessData.fromRawJson(String str) =>
      WorkProcessData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WorkProcessData.fromJson(Map<String, dynamic> json) =>
      WorkProcessData(
        barCode: json["BarCode"],
        bomType: json["bomType"],
        clamptype: json["clamptype"],
        curprocorder: json["CURPROCORDER"],
        curprocstate: json["CURPROCSTATE"],
        machineSn: json["MachineSn"],
        mouldsn: json["MOULDSN"],
        mwcount: json["mwcount"],
        mwpiececode: json["Mwpiececode"],
        mwpiecename: json["mwpiecename"],
        partsn: json["PARTSN"],
        procedurename: json["procedurename"],
        processroute: json["PROCESSROUTE"],
        procetotal: json["PROCETOTAL"],
        pstePid: json["PstePid"],
        recordtime: json["RECORDTIME"],
        resoucenamedept: json["resoucenamedept"],
        resourceName: json["ResourceName"],
        sn: json["SN"],
        spec: json["SPEC"],
        trayType: json["TrayType"],
        workpieceType: json["WorkpieceType"],
        wpstate: json["wpstate"],
      );

  Map<String, dynamic> toJson() => {
        "BarCode": barCode,
        "bomType": bomType,
        "clamptype": clamptype,
        "CURPROCORDER": curprocorder,
        "CURPROCSTATE": curprocstate,
        "MachineSn": machineSn,
        "MOULDSN": mouldsn,
        "mwcount": mwcount,
        "Mwpiececode": mwpiececode,
        "mwpiecename": mwpiecename,
        "PARTSN": partsn,
        "procedurename": procedurename,
        "PROCESSROUTE": processroute,
        "PROCETOTAL": procetotal,
        "PstePid": pstePid,
        "RECORDTIME": recordtime,
        "resoucenamedept": resoucenamedept,
        "ResourceName": resourceName,
        "SN": sn,
        "SPEC": spec,
        "TrayType": trayType,
        "WorkpieceType": workpieceType,
        "wpstate": wpstate,
      };
}
