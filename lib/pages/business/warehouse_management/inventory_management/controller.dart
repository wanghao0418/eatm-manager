/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-25 13:37:07
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-07 13:38:13
 * @FilePath: /eatm_manager/lib/pages/business/warehouse_management/shelf_management/controller.dart
 * @Description: 货架管理逻辑层
 */

import 'dart:convert';

import 'package:eatm_manager/common/models/selectOption.dart';
import 'package:eatm_manager/common/utils/http.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../common/api/warehouse_management/index.dart';

class InventoryManagementController extends GetxController {
  InventoryManagementController();
  InventoryManagementSearch search = InventoryManagementSearch(shelfNum: 0);
  List<SelectOption> artifactTypeList = [
    SelectOption(label: '全部', value: null),
    SelectOption(label: '空托盘', value: 0),
    SelectOption(label: '钢件', value: 1),
    SelectOption(label: '电极', value: 2),
  ];
  // List<SelectOption> storageTypeList = [
  //   SelectOption(label: '全部', value: 'NULL'),
  //   SelectOption(label: '异常', value: 'ABNORMOAL'),
  //   SelectOption(label: '完成', value: 'FINISH'),
  //   SelectOption(label: '待加工', value: 'TOPROCESS')
  // ];
  List<String> taskList = [];
  List<int> shelfList = [];
  List<LocationInfo> locationInfoList = [];
  List<PlutoRow> rows = [];
  late final PlutoGridStateManager stateManager;
  final toggle = false.obs;
  final currentTask = ''.obs;
  final showAGV = false.obs;

  _initData() {
    update(["shelf_management"]);
  }

  // 获取货架列表
  void getShelfList() async {
    ResponseApiBody res = await InventoryManagementApi.getShelfCount({});
    if (res.success!) {
      int count = res.data['ShelfCount'] ?? 0;
      shelfList = List.generate(count, (index) => index + 1);
      update(["shelf_management"]);
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 查询
  void query() async {
    ResponseApiBody res =
        await InventoryManagementApi.query({"params": search.toJson()});
    if (res.success!) {
      List<LocationInfo> data =
          (res.data as List).map((e) => LocationInfo.fromJson(e)).toList();
      locationInfoList = data;
      updateRows();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 出库
  void out() async {
    if (stateManager.checkedRows.isEmpty) {
      PopupMessage.showWarningInfoBar('请选择货位');
      return;
    }
    ResponseApiBody res = await WarehouseCommonApi.outWarehouse({
      "params": {
        "StorageNums": stateManager.checkedRows.first.cells['storageNum']!.value
      }
    });
    if (res.success!) {
      PopupMessage.showSuccessInfoBar(res.message as String);
      query();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 修改货位状态
  void changeStorageState(
      PlutoColumnRendererContext rendererContext, bool value) async {
    ResponseApiBody res = await InventoryManagementApi.changeStorageState({
      "params": {
        "storageNum": rendererContext.row.cells['storageNum']!.value,
        "useable": value
      }
    });
    if (res.success!) {
      PopupMessage.showSuccessInfoBar('操作成功');
      // 0 不禁用  其他 禁用
      rendererContext.cell.value = value ? 1 : 0;
      _initData();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  void onTap() {
    PopupMessage.showWarningInfoBar('暂未开放');
  }

  // 更新表格数据
  void updateRows() {
    rows.clear();
    for (var e in locationInfoList) {
      var index = locationInfoList.indexOf(e);
      stateManager.appendRows([
        PlutoRow(cells: {
          'number': PlutoCell(value: index + 1),
          'storageNum': PlutoCell(value: e.storageNum),
          'workpieceSN': PlutoCell(value: e.workpieceSn),
          'workpieceType': PlutoCell(value: e.workpieceType),
          'trayType': PlutoCell(value: e.trayType),
          'trayWeight': PlutoCell(value: e.trayWeight),
          'recordTime': PlutoCell(value: e.recordTime),
          'checked': PlutoCell(value: false),
          'useable': PlutoCell(value: e.useable),
          'currentState': PlutoCell(value: e.currentState),
        })
      ]);
    }
    _initData();
  }

  // bool isDisabled(PlutoCell cell) {
  //   return cell.value != 0;
  // }

  // // 是否全选
  // bool isAllChecked() {
  //   var needCheckRows = stateManager.rows
  //       .where((element) => !isDisabled(element.cells['uSABLE']!));
  //   return stateManager.checkedRows.length == needCheckRows.length &&
  //       needCheckRows.isNotEmpty;
  // }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    getShelfList();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}

// 查询表单类
class InventoryManagementSearch {
  int? artifactType;
  String? storageType;
  int? aGVStorageNum;
  int? shelfNum;

  InventoryManagementSearch(
      {this.artifactType, this.storageType, this.aGVStorageNum, this.shelfNum});

  InventoryManagementSearch.fromJson(Map<String, dynamic> json) {
    artifactType = json['artifactType'];
    storageType = json['storageType'];
    aGVStorageNum = json['AGVStorageNum'];
    shelfNum = json['shelfNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['workpieceType'] = this.artifactType;
    data['currState'] = this.storageType;
    data['AGVStorageNum'] = this.aGVStorageNum;
    data['shelfNum'] = this.shelfNum;
    return data;
  }
}

// // 货架信息类
// class LocationInfo {
//   int? number;
//   String? warehouseName;
//   int? storageNum;
//   String? barcode;
//   String? trayType;
//   String? trayHeight;
//   String? mOULDSN;
//   String? pARTSN;
//   String? workpieceSN;
//   String? recordTime;
//   String? wORKPIECETYPE;
//   int? nShelfNum;
//   String? cURRSTATE;
//   int? uSABLE;

//   LocationInfo(
//       {this.number,
//       this.warehouseName,
//       this.storageNum,
//       this.barcode,
//       this.trayType,
//       this.trayHeight,
//       this.mOULDSN,
//       this.pARTSN,
//       this.workpieceSN,
//       this.recordTime,
//       this.wORKPIECETYPE,
//       this.nShelfNum,
//       this.cURRSTATE,
//       this.uSABLE});

//   LocationInfo.fromJson(Map<String, dynamic> json) {
//     warehouseName = json['WarehouseName'];
//     storageNum = json['StorageNum'];
//     barcode = json['Barcode'];
//     trayType = json['TrayType'];
//     trayHeight = json['TrayHeight'];
//     mOULDSN = json['MOULDSN'];
//     pARTSN = json['PARTSN'];
//     workpieceSN = json['WorkpieceSN'];
//     recordTime = json['RecordTime'];
//     wORKPIECETYPE = json['WORKPIECETYPE'];
//     nShelfNum = json['nShelfNum'];
//     cURRSTATE = json['CURRSTATE'];
//     uSABLE = json['USABLE'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['WarehouseName'] = this.warehouseName;
//     data['StorageNum'] = this.storageNum;
//     data['Barcode'] = this.barcode;
//     data['TrayType'] = this.trayType;
//     data['TrayHeight'] = this.trayHeight;
//     data['MOULDSN'] = this.mOULDSN;
//     data['PARTSN'] = this.pARTSN;
//     data['WorkpieceSN'] = this.workpieceSN;
//     data['RecordTime'] = this.recordTime;
//     data['WORKPIECETYPE'] = this.wORKPIECETYPE;
//     data['nShelfNum'] = this.nShelfNum;
//     data['CURRSTATE'] = this.cURRSTATE;
//     data['USABLE'] = this.uSABLE;
//     return data;
//   }
// }

//  货位信息
class LocationInfo {
  LocationInfo({
    this.barcode,
    this.currentState,
    this.mouldSn,
    this.partSn,
    this.recordTime,
    this.shelfNum,
    this.storageNum,
    this.trayType,
    this.trayWeight,
    this.useable,
    this.warehouseName,
    this.workpieceSn,
    this.workpieceType,
  });

  ///条形码
  String? barcode;

  ///当前状态
  String? currentState;

  ///模号
  String? mouldSn;

  ///件号
  String? partSn;

  ///记录更新时间
  String? recordTime;

  ///货架号
  int? shelfNum;

  ///货位号
  int? storageNum;

  ///托盘类型
  String? trayType;

  ///托盘重量
  String? trayWeight;

  ///禁用状态，0不禁用，其他禁用
  int? useable;

  ///仓库名称
  String? warehouseName;

  ///工件编号
  String? workpieceSn;

  ///工件类型
  String? workpieceType;

  factory LocationInfo.fromRawJson(String str) =>
      LocationInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LocationInfo.fromJson(Map<String, dynamic> json) => LocationInfo(
        barcode: json["barcode"],
        currentState: json["currentState"],
        mouldSn: json["mouldSN"],
        partSn: json["partSN"],
        recordTime: json["recordTime"],
        shelfNum: json["shelfNum"],
        storageNum: json["storageNum"],
        trayType: json["trayType"],
        trayWeight: json["trayWeight"],
        useable: json["useable"],
        warehouseName: json["warehouseName"],
        workpieceSn: json["workpieceSN"],
        workpieceType: json["workpieceType"],
      );

  Map<String, dynamic> toJson() => {
        "barcode": barcode,
        "currentState": currentState,
        "mouldSN": mouldSn,
        "partSN": partSn,
        "recordTime": recordTime,
        "shelfNum": shelfNum,
        "storageNum": storageNum,
        "trayType": trayType,
        "trayWeight": trayWeight,
        "useable": useable,
        "warehouseName": warehouseName,
        "workpieceSN": workpieceSn,
        "workpieceType": workpieceType,
      };
}
