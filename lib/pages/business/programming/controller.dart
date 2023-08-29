/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-28 14:09:16
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-29 17:41:07
 * @FilePath: /eatm_manager/lib/pages/business/programming/controller.dart
 * @Description: 程式编程逻辑层
 */
import 'package:eatm_manager/common/api/discharge_api.dart';
import 'package:eatm_manager/common/api/work_process_binding_api.dart';
import 'package:eatm_manager/common/models/machineInfo.dart';
import 'package:eatm_manager/common/models/selectOption.dart';
import 'package:eatm_manager/common/utils/log.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:eatm_manager/pages/business/programming/model.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

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
    var res =
        await DischargeApi.getDischargeData(currentSteelEDMData!.toJson());
    if (res.success!) {
      edmElecInfoList =
          (res.data as List).map((e) => EdmElecInfo.fromJson(e)).toList();
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
      });
      dischargeStateManager.appendRows([row]);
    }
    _initData();
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
