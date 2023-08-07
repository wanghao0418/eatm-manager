/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-27 16:09:22
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-07 14:05:29
 * @FilePath: /eatm_manager/lib/pages/business/warehouse_management/task_management/controller.dart
 * @Description: 任务管理逻辑层
 */
import 'dart:async';

import 'package:eatm_manager/common/api/warehouse_management/index.dart';
import 'package:eatm_manager/common/models/selectOption.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:eatm_manager/pages/business/warehouse_management/task_management/enum.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../common/utils/http.dart';

class TaskManagementController extends GetxController {
  TaskManagementController();
  TaskManagementSearch search = TaskManagementSearch(
    startTime: DateTime.now().toString().substring(0, 10),
    endTime: DateTime.now().toString().substring(0, 10),
  );
  late final PlutoGridStateManager stateManager;
  List<SelectOption> artifactTypeList = [
    SelectOption(label: '钢件', value: 1),
    // SelectOption(label: '电极', value: 2),
  ];
  List<SelectOption> workpieceStatusList = [
    SelectOption(label: '空托盘', value: -1),
    // SelectOption(label: '未加工', value: 0),
    // SelectOption(label: '加工中', value: 1),
    // SelectOption(label: '暂停', value: 2),
    // SelectOption(label: '继续加工中', value: 3),
    SelectOption(label: '完工', value: 4),
  ];
  List<PlutoRow> rows = [];
  List<TaskInfo> taskInfoList = [];
  bool tableLoaded = false;
  int? artifactType = 1;
  int? workpieceStatus;
  late Timer _timer;

  _initData() {
    update(["task_management"]);
  }

  // 查询
  void query() async {
    ResponseApiBody res =
        await TaskManagementApi.query({"params": search.toJson()});
    if (res.success!) {
      List<TaskInfo> data =
          (res.data as List).map((e) => TaskInfo.fromJson(e)).toList();
      taskInfoList = data;
      updateRows();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 刷新表格数据
  void updateRows() {
    rows.clear();
    for (var e in taskInfoList) {
      var index = taskInfoList.indexOf(e);
      stateManager.appendRows([
        PlutoRow(cells: {
          'checked': PlutoCell(value: false),
          'number': PlutoCell(value: index + 1),
          'taskCode': PlutoCell(value: e.taskCode),
          'startTime': PlutoCell(value: e.startTime),
          'endTime': PlutoCell(value: e.endTime),
          'storageNum': PlutoCell(value: e.storageNum),
          'operationType': PlutoCell(value: e.operationType),
          'workpieceSN': PlutoCell(value: e.workpieceSn),
          'trayType': PlutoCell(value: e.trayType),
          'executionStatus': PlutoCell(value: e.executionStatus),
        })
      ]);
    }
    _initData();
  }

  // 定时查询
  void initTimer() {
    const duration = Duration(seconds: 5);
    _timer = Timer.periodic(duration, (Timer timer) {
      query();
    });
  }

  bool isDisabled(PlutoCell cell) {
    return cell.value == ExecutionStatus.executing.value;
  }

  // 是否全选
  bool isAllChecked() {
    var needCheckRows = stateManager.rows
        .where((element) => !isDisabled(element.cells['executionStatus']!));
    return stateManager.checkedRows.length == needCheckRows.length &&
        needCheckRows.isNotEmpty;
  }

  // 取消任务
  void cancelTask() async {
    if (stateManager.checkedRows.isEmpty) {
      PopupMessage.showWarningInfoBar('请选择任务');
      return;
    }
    ResponseApiBody res = await TaskManagementApi.cancelTask({
      "params": {
        "taskCode": stateManager.checkedRows
            .map((e) => e.cells['taskCode']!.value)
            .toList()
      }
    });
    if (res.success!) {
      PopupMessage.showSuccessInfoBar('操作成功');
      query();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 托盘入库
  void trayIn() async {
    ResponseApiBody res = await WarehouseCommonApi.outWarehouse({
      "params": {"storageType": InWarehouseType.tray.value}
    });
    if (res.success!) {
      PopupMessage.showSuccessInfoBar(res.message as String);
      query();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 出库
  void out() async {
    if (workpieceStatus == null) {
      PopupMessage.showWarningInfoBar('请选择工件状态');
      return;
    }
    ResponseApiBody res = await WarehouseCommonApi.outWarehouse({
      "params": {
        "workpieceType": artifactType,
        "workpieceStatus": workpieceStatus
      }
    });
    if (res.success!) {
      PopupMessage.showSuccessInfoBar(res.message as String);
      query();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 工件入库
  void workpieceIn() async {
    ResponseApiBody res = await WarehouseCommonApi.warehouse({
      "params": {"storageType": artifactType}
    });
    if (res.success!) {
      PopupMessage.showSuccessInfoBar(res.message as String);
      query();
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
    _initData();
  }

  @override
  void onClose() {
    super.onClose();
    _timer.cancel();
  }
}

class TaskManagementSearch {
  String? startTime;
  String? endTime;
  int? executionStatus;
  // int? workpieceStatus;

  TaskManagementSearch({this.startTime, this.endTime, this.executionStatus});

  TaskManagementSearch.fromJson(Map<String, dynamic> json) {
    startTime = json['startTime'];
    endTime = json['endTime'];
    executionStatus = json['executionStatus'];
    // workpieceStatus = json['workpieceStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['executionStatus'] = this.executionStatus;
    // data['workpieceStatus'] = this.workpieceStatus;
    return data;
  }
}

class TaskInfo {
  TaskInfo({
    this.endTime,
    this.executionStatus,
    this.operationType,
    this.startTime,
    this.storageNum,
    this.taskCode,
    this.trayType,
    this.workpieceSn,
  });

  ///结束时间
  String? endTime;

  ///执行状态
  int? executionStatus;

  ///操作类型
  int? operationType;

  ///开始时间
  String? startTime;

  ///货位号
  int? storageNum;

  ///任务编号
  String? taskCode;

  ///托盘类型
  String? trayType;

  ///工件SN
  String? workpieceSn;

  factory TaskInfo.fromJson(Map<String, dynamic> json) => TaskInfo(
        endTime: json["endTime"],
        executionStatus: json["executionStatus"],
        operationType: json["operationType"],
        startTime: json["startTime"],
        storageNum: json["storageNum"],
        taskCode: json["taskCode"],
        trayType: json["trayType"],
        workpieceSn: json["workpieceSN"],
      );

  Map<String, dynamic> toJson() => {
        "endTime": endTime,
        "executionStatus": executionStatus,
        "operationType": operationType,
        "startTime": startTime,
        "storageNum": storageNum,
        "taskCode": taskCode,
        "trayType": trayType,
        "workpieceSN": workpieceSn,
      };
}
