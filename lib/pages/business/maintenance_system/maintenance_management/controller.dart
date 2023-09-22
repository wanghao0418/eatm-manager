import 'package:eatm_manager/common/api/maintenance_system_api.dart';
import 'package:eatm_manager/common/utils/http.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:eatm_manager/pages/business/maintenance_system/maintenance_management/models.dart';
import 'package:eatm_manager/pages/business/maintenance_system/models.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class MaintenanceManagementController extends GetxController {
  MaintenanceManagementController();
  List<Equipment> equipmentList = [];
  List<PlutoRow> equipmentTableRows = [];
  late PlutoGridStateManager equipmentStateManager;

  // 设备编号
  TextEditingController equipmentNoController = TextEditingController();

  RxInt currentTabIndex = 0.obs;
  // 保养项目
  List<MaintenanceProgram> maintainProjects = [];
  // 点检项目
  List<MaintenanceProgram> spotCheckPrograms = [];
  late PlutoGridStateManager maintainStateManager;
  late PlutoGridStateManager spotCheckStateManager;
  List<PlutoRow> maintainRows = [];
  List<PlutoRow> spotCheckRows = [];

  // 获取维保项目
  void getMaintainProject() async {
    ResponseApiBody res = await MaintenanceSystemApi.queryMaintenanceItem();
    if (res.success!) {
      maintainProjects = (res.data['maintenance'] as List)
          .map((e) => MaintenanceProgram.fromJson(e))
          .toList();
      spotCheckPrograms = (res.data['spotCheck'] as List)
          .map((e) => MaintenanceProgram.fromJson(e))
          .toList();
      updateProjectRows();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 查询设备
  void queryEquipments() async {
    Map params = {
      'params': {"DeviceNum": equipmentNoController.text}
    };
    ResponseApiBody res = await MaintenanceSystemApi.queryEquipmentList(params);
    if (res.success == true) {
      equipmentList = res.data.map<Equipment>((e) {
        return Equipment.fromJson(e);
      }).toList();
      updateRows();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 更新表格数据
  void updateRows() async {
    equipmentTableRows.clear();
    equipmentStateManager.appendRows(equipmentList
        .map((e) => PlutoRow(cells: {
              'id': PlutoCell(value: e.id),
              'equipmentNo': PlutoCell(value: e.equipmentNo),
              'equipmentName': PlutoCell(value: e.equipmentName),
              'equipmentType': PlutoCell(value: e.equipmentType),
              'equipmentModel': PlutoCell(value: e.equipmentModel),
              'equipmentPosition': PlutoCell(value: e.equipmentPosition),
              'userDepartment': PlutoCell(value: e.userDepartment),
            }))
        .toList());
    _initData();
  }

  void updateProjectRows() {
    maintainRows.clear();
    spotCheckRows.clear();
    maintainStateManager.appendRows(maintainProjects
        .map((e) => PlutoRow(cells: {
              'id': PlutoCell(value: e.id),
              'maintenanceProgram': PlutoCell(value: e.maintenanceProgram),
              'maintenancePosition': PlutoCell(value: e.maintenancePosition),
              'maintenanceContent': PlutoCell(value: e.maintenanceContent),
              'maintenanceStandard': PlutoCell(value: e.maintenanceStandard),
              'remarks': PlutoCell(value: e.remarks),
            }))
        .toList());
    spotCheckStateManager.appendRows(spotCheckPrograms
        .map((e) => PlutoRow(cells: {
              'id': PlutoCell(value: e.id),
              'maintenanceProgram': PlutoCell(value: e.maintenanceProgram),
              'maintenancePosition': PlutoCell(value: e.maintenancePosition),
              'maintenanceContent': PlutoCell(value: e.maintenanceContent),
              'maintenanceStandard': PlutoCell(value: e.maintenanceStandard),
              'remarks': PlutoCell(value: e.remarks),
            }))
        .toList());
    _initData();
  }

  // 新增设备
  void addEquipment(Map params) async {
    ResponseApiBody res =
        await MaintenanceSystemApi.addEquipment({"params": params});
    if (res.success == true) {
      PopupMessage.showSuccessInfoBar('操作成功');
      queryEquipments();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 删除设备
  void deleteEquipment() async {
    ResponseApiBody res = await MaintenanceSystemApi.deleteEquipment({
      "params": {
        "ID": equipmentStateManager.checkedRows.first.cells["id"]!.value
            .toString()
      }
    });
    if (res.success == true) {
      PopupMessage.showSuccessInfoBar('操作成功');
      queryEquipments();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  _initData() {
    update(["maintenance_management"]);
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
