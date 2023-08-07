/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-27 11:32:57
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-07 13:39:17
 * @FilePath: /eatm_manager/lib/pages/business/warehouse_management/storage_records/controller.dart
 * @Description: 入库记录逻辑层
 */
import 'package:eatm_manager/common/api/warehouse_management/exit_storage_records_api.dart';
import 'package:eatm_manager/common/models/selectOption.dart';
import 'package:eatm_manager/common/utils/http.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class ExitStorageRecordsController extends GetxController {
  ExitStorageRecordsController();
  ExitStorageRecordsSearch search = ExitStorageRecordsSearch(
    startTime: DateTime.now().toString().substring(0, 10),
    endTime: DateTime.now().toString().substring(0, 10),
  );
  List<SelectOption> operationTypeList = [
    SelectOption(label: '全部', value: null),
    SelectOption(label: '入库', value: 1),
    SelectOption(label: '出库', value: 2),
  ];
  List<ExitStorageRecords> storageRecordsList = [];
  List<PlutoRow> rows = [];
  late final PlutoGridStateManager stateManager;

  // 查询
  void query() async {
    ResponseApiBody res =
        await ExitStorageRecordsApi.query({"params": search.toJson()});
    if (res.success!) {
      List<ExitStorageRecords> data = (res.data as List)
          .map((e) => ExitStorageRecords.fromJson(e))
          .toList();
      storageRecordsList = data;
      updateRows();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 更新表格
  void updateRows() {
    rows.clear();
    for (var e in storageRecordsList) {
      var index = storageRecordsList.indexOf(e);
      stateManager.appendRows([
        PlutoRow(cells: {
          'number': PlutoCell(value: index + 1),
          'taskCode': PlutoCell(value: e.taskCode),
          'startTime': PlutoCell(value: e.startTime),
          'endTime': PlutoCell(value: e.endTime),
          'operationType': PlutoCell(value: e.operationType),
          'storageNum': PlutoCell(value: e.storageNum),
          'workpieceSN': PlutoCell(value: e.workpieceSN),
          'trayType': PlutoCell(value: e.trayType),
        })
      ]);
    }
    _initData();
  }

  _initData() {
    update(["storage_records"]);
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}

class ExitStorageRecordsSearch {
  String? startTime;
  String? endTime;
  int? operationType;

  ExitStorageRecordsSearch({this.startTime, this.endTime, this.operationType});

  ExitStorageRecordsSearch.fromJson(Map<String, dynamic> json) {
    startTime = json['startTime'];
    endTime = json['endTime'];
    operationType = json['operationType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['operationType'] = this.operationType;
    return data;
  }
}

class ExitStorageRecords {
  String? taskCode;
  String? startTime;
  String? endTime;
  int? operationType;
  int? storageNum;
  String? workpieceSN;
  String? trayType;

  ExitStorageRecords(
      {this.taskCode,
      this.startTime,
      this.endTime,
      this.operationType,
      this.storageNum,
      this.workpieceSN,
      this.trayType});

  ExitStorageRecords.fromJson(Map<String, dynamic> json) {
    taskCode = json['taskCode'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    operationType = json['operationType'];
    storageNum = json['storageNum'];
    workpieceSN = json['workpieceSN'];
    trayType = json['trayType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['taskCode'] = this.taskCode;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['operationType'] = this.operationType;
    data['storageNum'] = this.storageNum;
    data['workpieceSN'] = this.workpieceSN;
    data['trayType'] = this.trayType;
    return data;
  }
}
