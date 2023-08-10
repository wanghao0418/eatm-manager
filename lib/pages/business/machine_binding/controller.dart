/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-09 15:34:58
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-10 09:21:27
 * @FilePath: /eatm_manager/lib/pages/business/machine_binding/controller.dart
 * @Description: 机床绑定逻辑层
 */
import 'package:eatm_manager/common/api/machine_binding_api.dart';
import 'package:eatm_manager/common/models/selectOption.dart';
import 'package:eatm_manager/common/utils/http.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:get/get.dart';

class MachineBindingController extends GetxController {
  MachineBindingController();
  MachineBindingSearch search = MachineBindingSearch(
    workpiecetype: 0,
    startTime: DateTime.now().toString().substring(0, 10),
    endTime: DateTime.now().add(Duration(days: 3)).toString().substring(0, 10),
  );
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
          print(macInfo);
          var subProcedureName = macInfo['SubProcedurename'];
          if (machineMap.keys.contains(subProcedureName) == false) {
            machineMap[subProcedureName] = [macInfo];
          } else {
            machineMap[subProcedureName]!.add(macInfo);
          }
        }
      }
      print(machineMap);

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
