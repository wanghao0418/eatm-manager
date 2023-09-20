import 'package:eatm_manager/common/api/maintenance_system_api.dart';
import 'package:eatm_manager/common/models/selectOption.dart';
import 'package:eatm_manager/common/utils/http.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:eatm_manager/pages/business/maintenance_system/enum.dart';
import 'package:eatm_manager/pages/business/maintenance_system/todo_today/models.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TodoTodayController extends GetxController {
  TodoTodayController();
  MaintenanceTasksSearch search = MaintenanceTasksSearch();
  List<PlutoRow> rows = [];
  late PlutoGridStateManager stateManager;

  // 设备编号
  List<SelectOption> equipmentOptionList = [];

  // 维保任务
  List<MaintenanceTask> maintenanceTaskList = [];

  // 获取设备列表
  void getEquipmentList() async {
    ResponseApiBody res = await MaintenanceSystemApi.queryEquipmentList();
    if (res.success!) {
      equipmentOptionList = (res.data as List).map((e) {
        return SelectOption(label: e['equipmentNo'], value: e['equipmentNo']);
      }).toList();
      _initData();
    }
  }

  // 查询
  void query() async {
    PopupMessage.showLoading();
    ResponseApiBody res =
        await MaintenanceSystemApi.queryTodoToday({"params": search.toJson()});
    PopupMessage.closeLoading();
    if (res.success!) {
      maintenanceTaskList = (res.data as List).map((e) {
        return MaintenanceTask.fromJson(e);
      }).toList();
      updateRow();
    }
  }

  // 更新表格数据
  void updateRow() {
    rows.clear();
    maintenanceTaskList.forEach((element) {
      stateManager.appendRows([
        PlutoRow(cells: {
          'id': PlutoCell(value: element.id),
          'maintenanceType': PlutoCell(value: element.maintenanceType),
          'maintenanceProject': PlutoCell(value: element.maintenanceProject),
          'equipmentNo': PlutoCell(value: element.equipmentNo),
          'maintenancePosition': PlutoCell(value: element.maintenancePosition),
          'maintenanceContent': PlutoCell(value: element.maintenanceContent),
          'maintenanceStandard': PlutoCell(value: element.maintenanceStandard),
          'maintenanceCycle': PlutoCell(value: element.maintenanceCycle),
          'maintenancePersonnel':
              PlutoCell(value: element.maintenancePersonnel),
          'maintenanceStatus': PlutoCell(value: element.maintenanceStatus),
          'maintenanceTime': PlutoCell(value: element.maintenanceTime),
          'isAbnormal': PlutoCell(value: element.isAbnormal),
          'exceptionDescription':
              PlutoCell(value: element.exceptionDescription),
          'data': PlutoCell(value: element),
        })
      ]);
    });
    _initData();
  }

  // 修改任务是否异常
  void updateIsAbnormal(int id, bool isAbnormal, {String? abnormalText}) async {
    ResponseApiBody res = await MaintenanceSystemApi.updateIsAbnormal({
      "params": {
        'ID': id,
        'IsAbnormal': isAbnormal,
        'ExceptionDes': isAbnormal ? abnormalText : ''
      }
    });
    if (res.success!) {
      MaintenanceTask task =
          maintenanceTaskList.firstWhere((element) => element.id == id);
      task.isAbnormal = isAbnormal;

      // 异常 显示异常信息
      if (isAbnormal) {
        task.exceptionDescription = abnormalText;
        updateRow();
      } else {
        // 取消 去掉异常信息
        task.exceptionDescription = '';
        updateRow();
      }
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 维保处理
  void maintenanceHandle(int id) async {
    ResponseApiBody res = await MaintenanceSystemApi.maintenanceHandle({
      "params": {
        'ID': id,
      }
    });
    if (res.success!) {
      PopupMessage.showSuccessInfoBar('操作成功');
      MaintenanceTask task =
          maintenanceTaskList.firstWhere((element) => element.id == id);
      task.maintenanceStatus =
          MaintenanceStatus.fromValue(task.maintenanceStatus!)!.handle()!.value;
      updateRow();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 修改维保人员
  void updateMaintenanceUser(int id, String name) async {
    ResponseApiBody res =
        await MaintenanceSystemApi.updateMaintenancePersonnel({
      "params": {
        'ID': id,
        'AfterName': name,
      }
    });
    if (res.success!) {
      PopupMessage.showSuccessInfoBar('操作成功');
      MaintenanceTask task =
          maintenanceTaskList.firstWhere((element) => element.id == id);
      task.maintenancePersonnel = name;
      updateRow();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  _initData() {
    update(["todo_today"]);
  }

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
