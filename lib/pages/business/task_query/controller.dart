/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-08 10:21:35
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-11 16:57:14
 * @FilePath: /eatm_manager/lib/pages/business/task_query/controller.dart
 * @Description: 任务查询逻辑层
 */
import 'dart:async';
import 'dart:convert';

import 'package:eatm_manager/common/api/product_task_query_api.dart';
import 'package:eatm_manager/common/models/selectOption.dart';
import 'package:eatm_manager/common/utils/http.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TaskQueryController extends GetxController {
  TaskQueryController();
  TaskQuerySearch search = TaskQuerySearch(
    startDate: DateTime.now().toString().substring(0, 10),
    endDate: DateTime.now().toString().substring(0, 10),
  );
  List<ProductionTask> productionTaskList = [];
  List<PlutoRow> rows = [];
  late final PlutoGridStateManager stateManager;
  bool tableLoaded = false;
  // 出入库状态
  List<SelectOption> agvDispatchStateOptionList = [
    SelectOption(value: null, label: '全部'),
    SelectOption(value: 0, label: '未入库'),
    SelectOption(value: 1, label: '已入库'),
    SelectOption(value: 2, label: '待出库')
  ];

  // 入库状态
  List<SelectOption> storageStatusOptionList = [
    SelectOption(value: 11, label: '11-发起叫料请求'),
    SelectOption(value: 12, label: '12-搬运物料'),
    SelectOption(value: 13, label: '13-到达接驳站'),
    SelectOption(value: 14, label: '14-通知AGV放料'),
    SelectOption(value: 15, label: '15-物料放置接驳站'),
    SelectOption(value: 16, label: '16-物料接收确认'),
  ];

  // 出库状态
  List<SelectOption> outboundStatusOptionList = [
    SelectOption(value: 23, label: '23-发起搬运请求'),
    SelectOption(value: 24, label: '24-搬运物料'),
    SelectOption(value: 25, label: '25-到达接驳站'),
    SelectOption(value: 26, label: '26-通知AGV取料'),
    SelectOption(value: 27, label: '27-转运物料完成'),
  ];
  int? currentStorageStatus;
  int? currentOutboundStatus;
  // 定时器
  late Timer timer;

  // 获取出入库状态选项列表
  void getInOutStateList() async {
    ResponseApiBody res = await ProductTaskQueryApi.getInOutStateList({});
    if (res.success!) {
      var inTaskOptionList = res.data['inTaskList'] as List;
      var outTaskOptionList = res.data['outTaskList'] as List;
      storageStatusOptionList = inTaskOptionList
          .map((e) => SelectOption(label: e['taskName'], value: e['taskNum']))
          .toList();
      outboundStatusOptionList = outTaskOptionList
          .map((e) => SelectOption(label: e['taskName'], value: e['taskNum']))
          .toList();
      _initData();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 查询
  void query() async {
    ResponseApiBody res =
        await ProductTaskQueryApi.query({"params": search.toJson()});
    if (res.success!) {
      List<ProductionTask> data =
          (res.data as List).map((e) => ProductionTask.fromJson(e)).toList();
      productionTaskList = data;
      updateRows();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 更新表格
  void updateRows() {
    rows.clear();
    for (var e in productionTaskList) {
      var index = productionTaskList.indexOf(e);
      stateManager.appendRows([
        PlutoRow(cells: {
          'number': PlutoCell(value: index + 1),
          'DeviceName': PlutoCell(value: e.DeviceName),
          'BarcodeId': PlutoCell(value: e.BarcodeId),
          'MouldSN': PlutoCell(value: e.MouldSN),
          'Mwpiececode': PlutoCell(value: e.Mwpiececode),
          'Pstepid': PlutoCell(value: e.Pstepid),
          'WorkPieceNorms': PlutoCell(value: e.WorkPieceNorms),
          'programstate': PlutoCell(value: e.programstate),
          'Planstartdate': PlutoCell(value: e.Planstartdate),
          'Planenddate': PlutoCell(value: e.Planenddate),
          'TheoreticalProductTime': PlutoCell(value: e.TheoreticalProductTime),
          'maxfinisheddate': PlutoCell(value: e.maxfinisheddate),
          'Productivelaborflag': PlutoCell(value: e.Productivelaborflag),
          'AgvDispatchState': PlutoCell(value: e.AgvDispatchState),
          'AgvSchedulingstatus': PlutoCell(value: e.AgvSchedulingstatus),
          'checked': PlutoCell(value: false),
          'data': PlutoCell(value: e.toJson()),
        })
      ]);
    }
    _initData();
  }

  // 开关门
  void operatingDoor(String type, int operation) async {
    ResponseApiBody res = await ProductTaskQueryApi.openOrCloseDoor(
        {'TransportShelf': type, 'OpenOrClose': operation});
    if (res.success!) {
      PopupMessage.showSuccessInfoBar('操作成功');
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 修改生产任务出入库状态
  void updateProductTaskState(int type) async {
    ResponseApiBody res = await ProductTaskQueryApi.updateProductTaskState({
      "params": {
        'type': type,
        'state': type == 1 ? currentStorageStatus : currentOutboundStatus,
        'taskList':
            stateManager.checkedRows.map((e) => e.cells['data']!.value).toList()
      }
    });
    if (res.success!) {
      PopupMessage.showSuccessInfoBar('操作成功');
      query();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  _initData() {
    update(["task_query"]);
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    getInOutStateList();
    // 每五分钟刷新一次
    timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      query();
    });
    _initData();
  }

  @override
  void onClose() {
    super.onClose();
    timer.cancel();
  }
}

class TaskQuerySearch {
  TaskQuerySearch(
      {this.agvDispatchState, this.barcodeId, this.startDate, this.endDate});

  ///出入库状态
  int? agvDispatchState;

  ///芯片Id
  String? barcodeId;

  // 开始日期
  String? startDate;
  // 结束日期
  String? endDate;

  factory TaskQuerySearch.fromRawJson(String str) =>
      TaskQuerySearch.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TaskQuerySearch.fromJson(Map<String, dynamic> json) =>
      TaskQuerySearch(
        agvDispatchState: json["AgvDispatchState"],
        barcodeId: json["BarcodeId"],
        startDate: json["StartDate"],
        endDate: json["EndDate"],
      );

  Map<String, dynamic> toJson() => {
        "AgvDispatchState": agvDispatchState,
        "BarcodeId": barcodeId,
        "startDate": startDate,
        "endDate": endDate,
      };
}

// 生产任务类
class ProductionTask {
  String? DeviceName;
  String? BarcodeId;
  String? MouldSN;
  String? Mwpiececode;
  int? Pstepid;
  String? WorkPieceNorms;
  String? programstate;
  String? Planstartdate;
  String? Planenddate;
  num? TheoreticalProductTime;
  String? maxfinisheddate;
  String? Productivelaborflag;
  String? AgvDispatchState;
  int? AgvSchedulingstatus;
  ProductionTask? data;

  ProductionTask(
      {this.DeviceName,
      this.BarcodeId,
      this.MouldSN,
      this.Mwpiececode,
      this.Pstepid,
      this.WorkPieceNorms,
      this.programstate,
      this.Planstartdate,
      this.Planenddate,
      this.TheoreticalProductTime,
      this.maxfinisheddate,
      this.Productivelaborflag,
      this.AgvDispatchState,
      this.AgvSchedulingstatus,
      this.data});

  ProductionTask.fromJson(Map<String, dynamic> json) {
    DeviceName = json['DeviceName'];
    BarcodeId = json['BarcodeId'];
    MouldSN = json['MouldSN'];
    Mwpiececode = json['Mwpiececode'];
    Pstepid = json['Pstepid'];
    WorkPieceNorms = json['WorkPieceNorms'];
    programstate = json['programstate'];
    Planstartdate = json['Planstartdate'];
    Planenddate = json['Planenddate'];
    TheoreticalProductTime = json['TheoreticalProductTime'];
    maxfinisheddate = json['maxfinisheddate'];
    Productivelaborflag = json['Productivelaborflag'];
    AgvDispatchState = json['AgvDispatchState'];
    AgvSchedulingstatus = json['AgvSchedulingstatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DeviceName'] = this.DeviceName;
    data['BarcodeId'] = this.BarcodeId;
    data['MouldSN'] = this.MouldSN;
    data['Mwpiececode'] = this.Mwpiececode;
    data['Pstepid'] = this.Pstepid;
    data['WorkPieceNorms'] = this.WorkPieceNorms;
    data['programstate'] = this.programstate;
    data['Planstartdate'] = this.Planstartdate;
    data['Planenddate'] = this.Planenddate;
    data['TheoreticalProductTime'] = this.TheoreticalProductTime;
    data['maxfinisheddate'] = this.maxfinisheddate;
    data['Productivelaborflag'] = this.Productivelaborflag;
    data['AgvDispatchState'] = this.AgvDispatchState;
    data['AgvSchedulingstatus'] = this.AgvSchedulingstatus;
    return data;
  }
}
