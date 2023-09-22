import 'package:eatm_manager/common/api/maintenance_system_api.dart';
import 'package:eatm_manager/common/models/selectOption.dart';
import 'package:eatm_manager/common/utils/http.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:eatm_manager/pages/business/maintenance_system/history_query/models.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class HistoryQueryController extends GetxController {
  HistoryQueryController();
  List<PlutoRow> rows = [];
  late PlutoGridStateManager stateManager;
  HistoryQuery search =
      HistoryQuery(finishTime: DateTime.now().toString().substring(0, 10));
  List<TaskHistory> taskHistoryList = [];

  // 设备编号
  List<SelectOption> equipmentOptionList = [];

  // 获取设备列表
  void getEquipmentList() async {
    ResponseApiBody res = await MaintenanceSystemApi.queryEquipmentList({});
    if (res.success!) {
      equipmentOptionList = (res.data as List).map((e) {
        return SelectOption(label: e['equipmentNo'], value: e['equipmentNo']);
      }).toList();
      _initData();
    }
  }

  // 查询
  void query() async {
    ResponseApiBody res = await MaintenanceSystemApi.queryTaskHistory(
        {"params": search.toJson()});
    if (res.success!) {
      taskHistoryList = (res.data as List)
          .map<TaskHistory>((e) => TaskHistory.fromJson(e))
          .toList();
      updateRows();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 更新表格
  void updateRows() {
    rows.clear();
    stateManager.appendRows(taskHistoryList
        .map((e) => PlutoRow(cells: {
              'id': PlutoCell(value: e.id),
              'maintenanceType': PlutoCell(value: e.maintenanceType),
              'equipmentNo': PlutoCell(value: e.equipmentNo),
              'maintenanceProject': PlutoCell(value: e.maintenanceProject),
              'maintenancePosition': PlutoCell(value: e.maintenancePosition),
              'maintenanceContent': PlutoCell(value: e.maintenanceContent),
              'exceptionDescription': PlutoCell(value: e.exceptionDescription),
              'maintenancePersonnel': PlutoCell(value: e.maintenancePersonnel),
              'maintenanceStatus': PlutoCell(value: e.maintenanceStatus),
              'startTime': PlutoCell(value: e.startTime),
              'endTime': PlutoCell(value: e.endTime),
            }))
        .toList());
    _initData();
  }

  // 重置表单
  void resetForm() {
    search =
        HistoryQuery(finishTime: DateTime.now().toString().substring(0, 10));
    query();
  }

  _initData() {
    update(["history_query"]);
  }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    getEquipmentList();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
