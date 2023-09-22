import 'package:eatm_manager/common/api/maintenance_system_api.dart';
import 'package:eatm_manager/common/models/selectOption.dart';
import 'package:eatm_manager/common/utils/http.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:eatm_manager/pages/business/maintenance_system/task_creation/models.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TaskCreationController extends GetxController {
  TaskCreationController();
  MaintenanceTaskSearch search = MaintenanceTaskSearch(
    startTime: (DateTime.now().subtract(const Duration(days: 7)))
        .toString()
        .substring(0, 10),
    endTime:
        DateTime.now().add(const Duration(days: 3)).toString().substring(0, 10),
  );
  List<PlutoRow> rows = [];
  late PlutoGridStateManager stateManager;
  List<MaintenanceTask> maintenanceTaskList = [];

  // 保养人员
  TextEditingController maintenancePersonController = TextEditingController();

  // 设备编号
  List<SelectOption> equipmentOptionList = [];

  // 维保周期
  List<SelectOption> cycleOptionList = [
    SelectOption(label: '日', value: '日'),
    SelectOption(label: '周', value: '周'),
    SelectOption(label: '月', value: '月'),
  ];

  // 重置表单
  void resetForm() {
    maintenancePersonController.clear();
    search = MaintenanceTaskSearch(
      startTime: (DateTime.now().subtract(const Duration(days: 7)))
          .toString()
          .substring(0, 10),
      endTime: DateTime.now()
          .add(const Duration(days: 3))
          .toString()
          .substring(0, 10),
    );
    queryMaintenanceTask();
  }

  // 删除任务
  void deleteTask() async {
    var taskIds = stateManager.checkedRows
        .map((e) => e.cells['id']!.value)
        .toList()
        .join(',');
    ResponseApiBody res = await MaintenanceSystemApi.deleteMaintenanceTask({
      "params": {"ID": taskIds}
    });
    if (res.success == true) {
      PopupMessage.showSuccessInfoBar('操作成功');
      queryMaintenanceTask();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

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

  // 查询维保任务
  void queryMaintenanceTask() async {
    PopupMessage.showLoading();
    ResponseApiBody res = await MaintenanceSystemApi.queryMaintenanceTask(
        {"params": search.toMap()});
    PopupMessage.closeLoading();
    if (res.success!) {
      maintenanceTaskList =
          (res.data as List).map((e) => MaintenanceTask.fromJson(e)).toList();
      updateRows();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 更新表格数据
  void updateRows() {
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
          'timeInterval': PlutoCell(value: element.timeInterval),
          // 'data': PlutoCell(value: element),
        })
      ]);
    });
    _initData();
  }

  // 创建维保任务
  void createMaintenanceTask(Map data) async {
    ResponseApiBody res =
        await MaintenanceSystemApi.addMaintenanceTask({"params": data});
    if (res.success == true) {
      PopupMessage.showSuccessInfoBar('创建成功');
      queryMaintenanceTask();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  _initData() {
    update(["task_creation"]);
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
