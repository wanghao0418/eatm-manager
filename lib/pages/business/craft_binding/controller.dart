/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-10 15:41:34
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-28 13:51:58
 * @FilePath: /eatm_manager/lib/pages/business/craft_binding/controller.dart
 * @Description: 工艺绑定逻辑层
 */
import 'dart:convert';

import 'package:eatm_manager/common/api/work_process_binding_api.dart';
import 'package:eatm_manager/common/models/selectOption.dart';
import 'package:eatm_manager/common/models/workProcess.dart';
import 'package:eatm_manager/common/utils/http.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class CraftBindingController extends GetxController {
  CraftBindingController();
  WorkProcessSearch search = WorkProcessSearch(
    workmanship: 0,
    querySource: 0,
    workpiecetype: 2,
    isSelect: true,
    startTime: DateTime.now().toString().substring(0, 10),
    endTime:
        DateTime.now().add(const Duration(days: 3)).toString().substring(0, 10),
  );
  List<PlutoRow> rows = [];
  late PlutoGridStateManager stateManager;
  List<WorkProcessData> workProcessDataList = [];

  // // 芯片Id
  // String? barCode;
  // // 监控编号
  // String? mwpiececode;
  // // 模号
  // String? mouldsn;
  // 装料台
  String? currentResourceName;
  // 托盘类型
  String? currentTrayType;
  // 装夹方式
  String? currentClampType;

  // 工艺路线
  List<SelectOption> get processRouteList => [
        SelectOption(label: '全部', value: 0),
        SelectOption(label: '已绑定', value: 1),
        SelectOption(label: '未绑定', value: 2),
      ];

  // 工件类型
  List<SelectOption> get workpieceTypeList => [
        SelectOption(label: '全部', value: 0),
        SelectOption(label: '电极', value: 1),
        SelectOption(label: '钢件', value: 2),
      ];

  // 装料台选项
  List<SelectOption> resourceList = [
    SelectOption(label: '', value: null),
  ];

  // 托盘类型选项
  List<SelectOption> get trayTypeList => search.workpiecetype == 1
      ? electrodeTrayTypeList
      : search.workpiecetype == 2
          ? steelTrayTypeList
          : [];

  // 电极托盘类型选项
  List<SelectOption> electrodeTrayTypeList = [];

  // 钢件托盘类型选项
  List<SelectOption> steelTrayTypeList = [];

  // 装夹方式选项
  List<SelectOption> get clampTypeList => search.workpiecetype == 1
      ? electrodeClampTypeList
      : search.workpiecetype == 2
          ? steelClampTypeList
          : [];

  // 电极装夹方式选项
  List<SelectOption> electrodeClampTypeList = [];

  // 钢件装夹方式选项
  List<SelectOption> steelClampTypeList = [];

  // 选中模号
  List<String> selectedMouldSNList = [];

  // 模号列表
  List<String> get mouldSNList =>
      workProcessDataList.map((e) => e.mouldsn!).toSet().toList();

  // 已选数据集合
  Map<String, WorkProcessData> selectedDataMap = {};

  _initData() {
    update(["craft_binding"]);
  }

  // 判断是否为同一数据 模号和件号相同
  bool isSameWorkProcessData(WorkProcessData data1, WorkProcessData data2) {
    return data1.mouldsn == data2.mouldsn && data1.partsn == data2.partsn;
  }

  // 查询
  void query() async {
    PopupMessage.showLoading();
    ResponseApiBody res =
        await WorkProcessBindingApi.query({"params": search.toJson()});
    PopupMessage.closeLoading();
    if (res.success!) {
      List<WorkProcessData> data =
          (res.data as List).map((e) => WorkProcessData.fromJson(e)).toList();
      workProcessDataList = data;
      // 重置模号列表
      selectedMouldSNList = [];
      stateManager.setFilter(null);
      updateRows();
      _initData();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 更新表格
  void updateRows() {
    bool hasFilter = stateManager.hasFilter;
    if (hasFilter) {
      stateManager.setFilter(null);
    }
    rows.clear();
    for (var e in workProcessDataList) {
      var index = workProcessDataList.indexOf(e);
      var row = PlutoRow(cells: {
        'number': PlutoCell(value: index + 1),
        'barCode': PlutoCell(value: e.barCode),
        'clampType': PlutoCell(value: e.clamptype),
        'trayType': PlutoCell(value: e.trayType),
        'workpieceType': PlutoCell(value: e.workpieceType),
        'mouldSN': PlutoCell(value: e.mouldsn),
        'partSN': PlutoCell(value: e.partsn),
        'mwpieceCode': PlutoCell(value: e.mwpiececode),
        'mwpieceName': PlutoCell(value: e.mwpiecename),
        // 'resoucenamedept': PlutoCell(value: e.resoucenamedept),
        'spec': PlutoCell(value: e.spec),
        // 'isCheck': PlutoCell(value: 0),
        'data': PlutoCell(value: e),
      });
      stateManager.appendRows([row]);

      var key = e.mouldsn! + e.partsn!;
      if (selectedDataMap.containsKey(key)) {
        // row.cells['isCheck']!.value = 1;
        // stateManager.insertRows(0, [row]);
        stateManager.setRowChecked(row, true);
      }
      stateManager.moveRowsByIndex(stateManager.checkedRows, 0);
      if (hasFilter) {
        stateManager.setFilter((element) => selectedMouldSNList
            .contains(element.cells['mouldSN']!.value.toString()));
      }
    }
    // stateManager.sortDescending(stateManager.columns
    //     .firstWhere((element) => element.field == 'isCheck'));
    _initData();
  }

  // 获取绑定资源
  void getBindingResource() async {
    ResponseApiBody res = await WorkProcessBindingApi.getBindingResource({});
    if (res.success!) {
      var data = res.data as List?;
      if (data == null) {
        PopupMessage.showFailInfoBar("装料台数据为空");
        return;
      }
      resourceList = data
          .map((e) => SelectOption(
                label: e['LoadStation'],
                value: e['LoadStation'],
              ))
          .toList();
      currentResourceName = resourceList.isEmpty ? null : resourceList[0].value;
      _initData();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 获取托盘类型
  void getTrayTypeInfo() async {
    ResponseApiBody res = await WorkProcessBindingApi.getTrayTypeInfo({});
    if (res.success!) {
      var data = res.data as Map<String, dynamic>;
      electrodeTrayTypeList = (data['ELEC'] as List)
          .map((e) => SelectOption(
                label: e,
                value: e,
              ))
          .toList();
      steelTrayTypeList = (data['STEEL'] as List)
          .map((e) => SelectOption(
                label: e,
                value: e,
              ))
          .toList();
      var currentTrayTypeList = search.workpiecetype == 1
          ? electrodeTrayTypeList
          : search.workpiecetype == 2
              ? steelTrayTypeList
              : [];
      currentTrayType =
          currentTrayTypeList.isEmpty ? null : currentTrayTypeList[0].value;
      // 不知道啥用
      // var matchType = data['MatchType'];
      _initData();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 获取装夹方式
  void getClampTypeInfo() async {
    ResponseApiBody res = await WorkProcessBindingApi.getClampTypeInfo({});
    if (res.success!) {
      var data = res.data as Map<String, dynamic>;
      electrodeClampTypeList = (data['ELEC'] as List)
          .map((e) => SelectOption(
                label: e,
                value: e,
              ))
          .toList();
      steelClampTypeList = (data['STEEL'] as List)
          .map((e) => SelectOption(
                label: e,
                value: e,
              ))
          .toList();
      var currentClampTypeList = search.workpiecetype == 1
          ? electrodeClampTypeList
          : search.workpiecetype == 2
              ? steelClampTypeList
              : [];
      currentClampType =
          currentClampTypeList.isEmpty ? null : currentClampTypeList[0].value;
      _initData();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 绑定
  void binding() async {
    if (selectedDataMap.isEmpty) {
      PopupMessage.showWarningInfoBar("请选择需要绑定的数据");
      return;
    }
    if (search.barcode == null || search.barcode!.isEmpty) {
      PopupMessage.showWarningInfoBar("请填写条码");
      return;
    }
    // 二次确认
    PopupMessage.showConfirmDialog(
        title: '注意',
        message: '请确认托盘类型和装卸台编号是否选择正确！',
        onConfirm: () async {
          // List<PlutoRow> selectedRows = stateManager.checkedRows;
          // var list = [];
          // for (var row in selectedRows) {
          //   var data = row.cells['data']!.value as WorkProcessData;
          //   data.barCode = search.barcode;
          //   data.trayType = currentTrayType;
          //   data.clamptype = currentClampType;
          //   data.resourceName = currentResourceName;
          //   list.add(data.toJson());
          // }
          var list = [];
          List<WorkProcessData> selectedDataList =
              selectedDataMap.values.toList();
          for (var data in selectedDataList) {
            data.barCode = search.barcode;
            data.trayType = currentTrayType;
            data.clamptype = currentClampType;
            data.resourceName = currentResourceName;
            list.add(data.toJson());
          }
          ResponseApiBody res = await WorkProcessBindingApi.binding({
            "params": {
              "list": list,
            }
          });
          if (res.success!) {
            PopupMessage.showSuccessInfoBar("绑定成功");
            query();
            // var hasFilter = stateManager.hasFilter;
            // // 更新选中行数据
            // if (hasFilter) {
            //   stateManager.setFilter(null);
            // }
            // for (var row in stateManager.checkedRows) {
            //   var data = row.cells['data']!.value as WorkProcessData;
            //   data.barCode = search.barcode;
            //   row.cells['barCode']!.value = search.barcode;
            //   if (currentTrayType != null) {
            //     data.trayType = currentTrayType;
            //     row.cells['trayType']!.value = currentTrayType;
            //   }
            //   if (currentClampType != null) {
            //     data.clamptype = currentClampType;
            //     row.cells['clampType']!.value = currentClampType;
            //   }
            //   if (currentResourceName != null) {
            //     data.resourceName = currentResourceName;
            //   }
            //   row.cells['data']!.value = data;
            // }
            // selectedDataMap.clear();
            // var oldSelectedMouldSNList = selectedMouldSNList;
            // updateRows();
            // selectedMouldSNList = oldSelectedMouldSNList;
            // if (hasFilter) {
            //   stateManager.setFilter((element) => selectedMouldSNList
            //       .contains(element.cells['mouldSN']!.value.toString()));
            // }
            _initData();
          } else {
            PopupMessage.showFailInfoBar(res.message as String);
          }
        });
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    getBindingResource();
    getTrayTypeInfo();
    getClampTypeInfo();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
