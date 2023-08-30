/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-28 14:09:16
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-30 17:35:12
 * @FilePath: /eatm_manager/lib/pages/business/programming/controller.dart
 * @Description: 程式编程逻辑层
 */
import 'package:eatm_manager/common/api/discharge_api.dart';
import 'package:eatm_manager/common/api/work_process_binding_api.dart';
import 'package:eatm_manager/common/models/machineInfo.dart';
import 'package:eatm_manager/common/models/selectOption.dart';
import 'package:eatm_manager/common/store/index.dart';
import 'package:eatm_manager/common/utils/hive.dart';
import 'package:eatm_manager/common/utils/log.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:eatm_manager/common/utils/router.dart';
import 'package:eatm_manager/pages/business/discharge/programming/model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:intl/intl.dart';

class ProgrammingController extends GetxController {
  ProgrammingController();
  List<SteelEDMData> steelEDMDataList = [];
  List<SteelEDMData> showSteelList = [];
  int currentSteelEDMDataIndex = -1;
  SteelEDMData? get currentSteelEDMData => steelEDMDataList.isNotEmpty
      ? steelEDMDataList[currentSteelEDMDataIndex]
      : null;

  // 机台型号下拉选项
  List<SelectOption> machineBandOptions = [];
  // 机台型号名称集合
  Map<String, List> machineNameMap = {};

  // 当前机台型号
  String? currentMachineBand;
  // 当前机台名称
  String? currentMachineName;

  // 当前机台名称下拉选项
  List<SelectOption> get machineNameOptions =>
      machineNameMap[currentMachineBand] != null
          ? machineNameMap[currentMachineBand]!
              .map((e) => SelectOption(label: e, value: e))
              .toList()
          : [];

  // 放电表格控制器
  late PlutoGridStateManager dischargeStateManager;
  List<PlutoRow> dischargeRows = [];

  // 放电信息
  List<EdmElecInfo> edmElecInfoList = [];

  // 跑位表格控制器
  late PlutoGridStateManager runningPosManager;
  List<PlutoRow> runningPosRows = [];

  // 跑位信息
  List<RunningPos> runningPosList = [];

  // 获取资源信息
  void getMachineResource() async {
    var res = await WorkProcessBindingApi.getMachineResource({});
    if (res.success!) {
      MachineResource data = MachineResource.fromJson(res.data);
      var edmList = data.EDM;
      if (edmList != null) {
        for (var edmMac in edmList) {
          if (machineNameMap[edmMac!.macBand.toString()] == null) {
            machineBandOptions.add(SelectOption(
                label: edmMac.macBand, value: edmMac.macBand.toString()));
            machineNameMap[edmMac.macBand.toString()] = [];
          } else {
            machineNameMap[edmMac.macBand.toString()]!.add(edmMac.machineName);
          }
        }
      }
      // 默认选中第一个
      currentMachineBand =
          machineBandOptions.isNotEmpty ? machineBandOptions[0].value : null;
      currentMachineName =
          machineNameOptions.isNotEmpty ? machineNameOptions[0].value : null;
      _initData();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 获取钢件EDM信息
  Future<bool> getSteelEDMData() async {
    var res = await DischargeApi.getSteelEDMData();
    if (res.success!) {
      steelEDMDataList =
          (res.data as List).map((e) => SteelEDMData.fromJson(e)).toList();
      return true;
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
      return false;
    }
  }

  // 保存钢件信息
  onSteelDataSave(SteelEDMData data) {
    var sn = data.steelSN;
    if (sn != null) {
      var index = showSteelList.indexWhere((element) => element.steelSN == sn);
      if (index != -1) {
        showSteelList[index] = data;
      } else {
        showSteelList.add(data);
      }
    }
    _initData();
  }

  // 获取放电信息
  void getDischargeData() async {
    PopupMessage.showLoading();
    var res =
        await DischargeApi.getDischargeData(currentSteelEDMData!.toJson());
    PopupMessage.closeLoading();
    if (res.success!) {
      edmElecInfoList = (res.data as List).map((e) {
        var data = EdmElecInfo.fromJson(e);
        data.steelMouldsn = currentSteelEDMData!.steelMouldSN;
        data.steelPartsn = currentSteelEDMData!.steelPartSN;
        data.steelBarcode = currentSteelEDMData!.steelBarcode;
        data.steelsn = currentSteelEDMData!.steelSN;
        data.oilTankHeight = currentSteelEDMData!.oilTankHeight;
        data.beginPoint = currentSteelEDMData!.beginPoint;
        data.steelProceduName = currentSteelEDMData!.steelProceduName;
        data.steelPstepid = currentSteelEDMData!.steelPstepid;
        return data;
      }).toList();

      updateDischargeRows();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 更新放电表格
  void updateDischargeRows() {
    dischargeRows.clear();
    for (var data in edmElecInfoList) {
      int index = edmElecInfoList.indexOf(data);
      var row = PlutoRow(cells: {
        'index': PlutoCell(value: index + 1),
        'elecMouldsn': PlutoCell(value: data.elecMouldsn),
        'elecPartsn': PlutoCell(value: data.elecPartsn),
        'elecsn': PlutoCell(value: data.elecsn),
        'elecEdmType': PlutoCell(value: data.elecedmtype),
        'elecNodeMark': PlutoCell(value: data.elecNodeMark),
        'shakingMode': PlutoCell(value: data.shakingmode),
        'steelTexture': PlutoCell(value: data.steelTexture),
        'elecTexture': PlutoCell(value: data.elecTexture),
        'fireNum': PlutoCell(value: data.frienum),
        'elecSpec': PlutoCell(value: data.elecSpec),
        'steelMouldsn': PlutoCell(value: data.steelMouldsn),
        'steelPartsn': PlutoCell(value: data.steelPartsn),
        'data': PlutoCell(value: data),
      });
      dischargeStateManager.appendRows([row]);
    }
    _initData();
  }

  // 更新跑位信息
  void updateRunningPosData() {
    runningPosList.clear();
    var dataRows = dischargeStateManager.checkedRows;
    for (var row in dataRows) {
      var data = row.cells['data']!.value as EdmElecInfo;
      List<RunningPos> runPosList = [
        RunningPos(
            runningPosX: data.runningPosX1,
            runningPosY: data.runningPosY1,
            runningPosZ: data.runningPosZ1,
            cAxisRotationAngle: data.cAxisRotationAngle1),
        RunningPos(
            runningPosX: data.runningPosX2,
            runningPosY: data.runningPosY2,
            runningPosZ: data.runningPosZ2,
            cAxisRotationAngle: data.cAxisRotationAngle2),
        RunningPos(
            runningPosX: data.runningPosX3,
            runningPosY: data.runningPosY3,
            runningPosZ: data.runningPosZ3,
            cAxisRotationAngle: data.cAxisRotationAngle3),
        RunningPos(
            runningPosX: data.runningPosX4,
            runningPosY: data.runningPosY4,
            runningPosZ: data.runningPosZ4,
            cAxisRotationAngle: data.cAxisRotationAngle4),
        RunningPos(
            runningPosX: data.runningPosX5,
            runningPosY: data.runningPosY5,
            runningPosZ: data.runningPosZ5,
            cAxisRotationAngle: data.cAxisRotationAngle5),
        RunningPos(
            runningPosX: data.runningPosX6,
            runningPosY: data.runningPosY6,
            runningPosZ: data.runningPosZ6,
            cAxisRotationAngle: data.cAxisRotationAngle6),
        RunningPos(
            runningPosX: data.runningPosX7,
            runningPosY: data.runningPosY7,
            runningPosZ: data.runningPosZ7,
            cAxisRotationAngle: data.cAxisRotationAngle7),
        RunningPos(
            runningPosX: data.runningPosX8,
            runningPosY: data.runningPosY8,
            runningPosZ: data.runningPosZ8,
            cAxisRotationAngle: data.cAxisRotationAngle8),
      ].where((pos) => pos.isNotOrigin).toList();
      runningPosList.addAll(runPosList);
    }
    updateRunningPosRows();
  }

  // 更新跑位表格
  void updateRunningPosRows() {
    runningPosRows.clear();
    for (var data in runningPosList) {
      var row = PlutoRow(cells: {
        'runningPosx': PlutoCell(value: data.runningPosX),
        'runningPosy': PlutoCell(value: data.runningPosY),
        'runningPosz': PlutoCell(value: data.runningPosZ),
        'cAxisRotationAngle': PlutoCell(value: data.cAxisRotationAngle),
        // 'data': PlutoCell(value: data),
      });
      runningPosManager.appendRows([row]);
    }
    _initData();
  }

  // 添加放电任务事件
  void onAddDischargeTask() async {
    if (dischargeStateManager.checkedRows.isEmpty) {
      PopupMessage.showWarningInfoBar('请先选择电极');
      return;
    }
    var dataList = dischargeStateManager.checkedRows.map((e) {
      EdmElecInfo data = e.cells['data']!.value;
      var total = dischargeStateManager.checkedRows.length;
      return {
        "SteelBARCODE": data.steelBarcode,
        "SteelMOULDSN": data.steelMouldsn,
        "SteelPARTSN": data.steelPartsn,
        "STEELSN": data.steelsn,
        "SteelSPEC": data.steelSpec,
        "MACHINESN": currentMachineName,
        "TOTAL": total,
        "ElecBARCODE": data.elecBarcode,
        "ElecMOULDSN": data.elecMouldsn,
        "ElecPARTSN": data.elecPartsn,
        "ELECSN": data.elecsn,
        "ElecSPEC": data.elecSpec,
        "FRIENUM": data.frienum,
        "ELECEDMTYPE": data.elecedmtype,
        "OilTankHeight": data.oilTankHeight,
        "BeginPoint": data.beginPoint,
        "SteelProceduName": data.steelProceduName,
        "SteelPstepid": data.steelPstepid,
        "ElecProceduName": data.elecProceduName,
        "ElecPstepid": data.elecPstepid,
        "ElecNodeMark": data.elecNodeMark
      };
    }).toList();
    PopupMessage.showLoading();
    var res = await DischargeApi.getEdmTaskInfo(dataList);
    PopupMessage.closeLoading();
    if (res.success!) {
      List<EdmTaskData> edmTaskDataList =
          (res.data as List).map((e) => EdmTaskData.fromJson(e)).toList();
      GetStorage edmTaskStorage = GetStorage('edmTask');
      edmTaskStorage.write('edmTaskDataList', edmTaskDataList);
      // var edmTaskBox = HiveUtil.instance.edmTaskBox;
      // var edmInfoBox = HiveUtil.instance.edmInfoBox;
      var edmTaskBox = await Hive.openBox('edmTask');
      var edmInfoBox = await Hive.openBox('edmInfo');
      var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      Map<String, dynamic> taskData = {
        'EdmTaskId': edmTaskDataList.first.edmTaskId,
        'TaskState': '初始状态',
        'CreateTime': "${formatter.format(DateTime.now())}",
        'CreateAuther': UserStore.instance.getCurrentUserInfo().nickName,
        'StateChangeTime': '',
        'StateChangeAuther': '',
        'SteelMOULDSN': edmTaskDataList.first.steelMOULDSN,
        'fixtureType': currentMachineName
      };
      edmTaskBox.put(edmTaskBox.length, taskData);
      List infoDataList = edmTaskDataList.map((e) {
        Map<String, dynamic> infoData = {
          'ElecMOULDSN': edmTaskDataList.first.elecMOULDSN,
          'ElecPARTSN': edmTaskDataList.first.elecPARTSN,
          'DischargeOrder': edmTaskDataList.first.edmOrder.toString(),
          'CurState': '初始状态',
          'StateChangeAuthor': '',
          'StartTime': '',
          'EndTime': ''
        };
        return infoData;
      }).toList();
      edmInfoBox.put(edmTaskDataList.first.edmTaskId, infoDataList);
      // 跳转到EDM任务
      RouterUtils.jumpToChildPage('/EDMTask');
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  _initData() {
    update(["programming"]);
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
