/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-06 10:21:53
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-13 15:08:05
 * @FilePath: /flutter-mesui/lib/pages/tool_management/mac_tool_magazine_management/controller.dart
 */
import 'package:eatm_manager/common/api/tool_management/mac_tool_magazine_management_api.dart';
import 'package:eatm_manager/common/utils/http.dart';
import 'package:eatm_manager/common/utils/log.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:excel/excel.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class MacToolMagazineManagementController extends GetxController {
  MacToolMagazineManagementController();
  late final PlutoGridStateManager stateManager;
  final List<PlutoRow> rows = [];
  final List<MacToolMagazineData> dataList = [];
  MacToolInfo? currentMachine;
  var importMachine = '';
  List<MacToolInfo> machineList = [];
  // 当前机床刀具容量
  int currentMachineToolMaxNum = 60;

  _initData() {
    update(["mac_tool_magazine_management"]);
  }

  initToolData() {}

  query() async {
    ResponseApiBody res = await MacToolMagazineManagementApi.query({
      "params": {
        "machineName": currentMachine?.machineName,
      }
    });
    if (res.success == true) {
      var datas = (res.data as List)
          .map((e) => MacToolMagazineData.fromJson(e))
          .toList();
      currentMachineToolMaxNum =
          int.parse(currentMachine?.magazineToolMaxNum ?? '60');
      dataList.clear();
      dataList.addAll(List.generate(
          currentMachineToolMaxNum,
          (index) => MacToolMagazineData(
                number: (index + 1).toString(),
                magazineNo: 'T${index + 1}',
              )));

      // 根据库号匹配
      for (var element in datas) {
        if (dataList.any((e) => e.magazineNo == element.magazineNo)) {
          dataList[dataList
              .indexWhere((e) => e.magazineNo == element.magazineNo)] = element;
        }
      }

      updateTableRows();

      // updateTableRows();
      // dataList.clear();
      // dataList.addAll((res.data as List)
      //     .map((e) => MacToolMagazineData.fromJson(e))
      //     .toList());
      // updateTableRows();
    } else {
      // dataList.clear();
      // updateTableRows();
    }
  }

  updateTableRows() {
    rows.clear();
    for (var e in dataList) {
      var index = dataList.indexOf(e);
      stateManager.appendRows([
        PlutoRow(cells: {
          "id": PlutoCell(value: e.id),
          'number': PlutoCell(value: index + 1),
          'machineName': PlutoCell(value: e.machineName ?? ''),
          'magazineNo': PlutoCell(value: e.magazineNo ?? ''),
          'toolName': PlutoCell(value: e.toolName ?? ''),
          'realToolRatedLife': PlutoCell(value: e.realToolRatedLife ?? ''),
          'realToolUsedLife': PlutoCell(value: e.realToolUsedLife ?? ''),
          'realToolLastLife': PlutoCell(value: e.realToolLastLife ?? ''),
          'lengthWear': PlutoCell(value: e.lengthWear ?? ''),
          'radiusWear': PlutoCell(value: e.radiusWear ?? ''),
          'protrudingLength': PlutoCell(value: e.protrudingLength ?? ''),
          'toolCode': PlutoCell(value: e.toolCode ?? ''),
          'handleCode': PlutoCell(value: e.handleCode ?? ''),
          'lengthTolerance': PlutoCell(value: e.lengthTolerance ?? ''),
          'toolType': PlutoCell(value: e.toolType ?? ''),
          'toolSettingMode': PlutoCell(value: e.toolSettingMode ?? ''),
          'radiusTolerance': PlutoCell(value: e.radiusTolerance ?? ''),
          'toolRadius': PlutoCell(value: e.toolRadius ?? ''),
          'measuringDepth': PlutoCell(value: e.measuringDepth ?? ''),
          'remark': PlutoCell(value: e.remark ?? ''),
          'useParam1': PlutoCell(value: e.useParam1 ?? ''),
          'useParam2': PlutoCell(value: e.useParam2 ?? ''),
          'useParam3': PlutoCell(value: e.useParam3 ?? ''),
          'useParam4': PlutoCell(value: e.useParam4 ?? ''),
          'createDate': PlutoCell(value: e.createDate ?? ''),
          'creator': PlutoCell(value: e.creator ?? ''),
          'editor': PlutoCell(value: e.editor ?? ''),
          'editTime': PlutoCell(value: e.editTime ?? ''),
          'toolId': PlutoCell(value: e.toolId ?? ''),
        })
      ]);
    }
    _initData();
  }

  // 导入Excel
  void importFile() async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'excel',
      extensions: <String>['xlsx'],
    );
    final XFile? file =
        await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
    if (file != null) {
      SmartDialog.showLoading(msg: '解析中...');
      final bytes = await file.readAsBytes();
      var excel = Excel.decodeBytes(bytes);
      SmartDialog.dismiss();
      initExcel(excel);
      // _initData(excel);
    }
  }

  initExcel(Excel excelData) {
    try {
      for (var table in excelData.tables.keys) {
        var rows = excelData.tables[table]!.rows;
        //去掉表头
        rows.removeAt(0);
        List<MacToolMagazineData> tools = [];
        for (var row in rows) {
          var values = row.map((e) => e?.value).toList();
          LogUtil.i(values);
          tools.add(MacToolMagazineData(
              magazineNo: values.elementAt(0)?.toString(),
              toolName: values.elementAt(1)?.toString(),
              realToolRatedLife: values.elementAt(2)?.toString(),
              realToolUsedLife: values.elementAt(3)?.toString(),
              realToolLastLife: values.elementAt(4)?.toString(),
              lengthWear: values.elementAt(5)?.toString(),
              radiusWear: values.elementAt(6)?.toString(),
              protrudingLength: values.elementAt(7)?.toString(),
              toolCode: values.elementAt(8)?.toString(),
              handleCode: values.elementAt(9)?.toString(),
              lengthTolerance: values.elementAt(10)?.toString(),
              toolType: values.elementAt(11)?.toString(),
              toolSettingMode: values.elementAt(12)?.toString(),
              radiusTolerance: values.elementAt(13)?.toString(),
              toolRadius: values.elementAt(14)?.toString(),
              measuringDepth: values.elementAt(15)?.toString(),
              remark: values.elementAt(16)?.toString()));
        }
        LogUtil.i(tools.map((e) => e.toJson()).toList());
      }
    } catch (e) {
      LogUtil.w(e);
      PopupMessage.showFailInfoBar('解析失败，请检查表格格式或联系管理员');
    }
    // try {
    //   for (var table in excelData.tables.keys) {
    //     String currentProjectName = table;
    //     List<ProjectOperation> currentProjectOperationList = [];
    //     Map<String, ProjectOperationMonth> monthMap = {};
    //     // 记一个最近日期 如当前行没有日期 则使用最近的日期
    //     String latestDate = '';
    //     // 遍历不同行
    //     for (var row in excelData.tables[table]!.rows) {
    //       var logoutReason = row.elementAt(2)?.value.toString();
    //       var logDate = row.elementAt(0)?.value.toString();
    //       // 过滤无用行
    //       if (logoutReason == null || logoutReason == '关软件原因') continue;

    //       if (logDate?.isNotEmpty == true) {
    //         latestDate = logDate!;
    //       }

    //       bool isAppendLog = logDate == '';

    //       if (latestDate!.isEmpty == true) continue;

    //       late int status;
    //       if (logoutReason.contains('无异常运行')) {
    //         status = RunStatus.Normal.status;
    //       } else if (logoutReason.contains('崩溃') || logoutReason.contains('闪退')) {
    //         status = RunStatus.Error.status;
    //       } else {
    //         status = RunStatus.Warning.status;
    //       }

    //       if (!isAppendLog) {
    //         currentProjectOperationList.add(ProjectOperation(
    //             projectName: currentProjectName,
    //             date: logDate!,
    //             status: status,
    //             logList: [logoutReason]));
    //       } else {
    //         int index = currentProjectOperationList.indexWhere((element) =>
    //             DateUtils.isSameDay(DateTime.parse(element.date), DateTime.parse(latestDate)));
    //         if (index >= 0) {
    //           currentProjectOperationList[index].logList.add(logoutReason);
    //         }
    //       }

    //       var currentMonth = latestDate?.substring(0, 7);
    //       if (!monthMap.keys.contains(currentMonth) && !isAppendLog) {
    //         monthMap[currentMonth!] =
    //             ProjectOperationMonth(projectName: currentProjectName, operationList: []);
    //       }
    //     }

    //     // 根据月份分组
    //     for (var project in currentProjectOperationList) {
    //       var currentMonth = project.date.substring(0, 7);
    //       monthMap[currentMonth]!.operationList.add(project);
    //     }

    //     // Log.w(monthMap);

    //     for (var month in monthMap.keys) {
    //       if (_dataMap[month] != null) {
    //         _dataMap[month]!.add(monthMap[month]!);
    //       } else {
    //         _dataMap[month] = [monthMap[month]!];
    //       }
    //     }
    //   }

    //   SmartDialog.dismiss();

    //   // Log.i(_dataMap);
    //   // map已完成
    //   _monthList = _dataMap.keys.map((e) => SelectOptionVO(label: e, value: e)).toList();
    //   setState(() {
    //     _currentMonth = _dataMap.keys.toList().last;
    //   });
    // } catch (e) {
    //   SmartDialog.dismiss();
    //   showAlertDialog(context, '警告', '解析失败,请联系管理员');
    //   _dataMap = {};
    //   _monthList = [];
    //   setState(() {
    //     _currentMonth = '';
    //   });
    //   // SmartDialog.showToast('解析失败');
    // }
  }

  // 获取线体机床列表
  queryMacList() async {
    ResponseApiBody res = await MacToolMagazineManagementApi.getMachineList({});
    if (res.success == true) {
      machineList =
          ((res.data as List).map((e) => MacToolInfo.fromJson(e)).toList());
      currentMachine = machineList.isNotEmpty ? machineList[0] : null;
      initToolData();
      query();
      _initData();
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
    queryMacList();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}

class MacToolInfo {
  String? machineName;
  String? magazineToolMaxNum;

  MacToolInfo({this.machineName, this.magazineToolMaxNum});

  MacToolInfo.fromJson(Map<String, dynamic> json) {
    machineName = json['machineName'];
    magazineToolMaxNum = json['magazineToolMaxNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['machineName'] = this.machineName;
    data['magazineToolMaxNum'] = this.magazineToolMaxNum;
    return data;
  }
}

class MacToolMagazineData {
  String? id;
  String? number;
  String? machineName;
  String? magazineNo;
  String? toolId;
  String? toolName;
  String? realToolRatedLife;
  String? realToolUsedLife;
  String? realToolLastLife;
  String? lengthWear;
  String? radiusWear;
  String? protrudingLength;
  String? toolCode;
  String? handleCode;
  String? lengthTolerance;
  String? toolType;
  String? toolSettingMode;
  String? radiusTolerance;
  String? toolRadius;
  String? measuringDepth;
  String? remark;
  String? useParam1;
  String? useParam2;
  String? useParam3;
  String? useParam4;
  String? createDate;
  String? creator;
  String? editor;
  String? editTime;

  MacToolMagazineData(
      {this.id,
      this.number,
      this.machineName,
      this.magazineNo,
      this.toolId,
      this.toolName,
      this.realToolRatedLife,
      this.realToolUsedLife,
      this.realToolLastLife,
      this.lengthWear,
      this.radiusWear,
      this.protrudingLength,
      this.toolCode,
      this.handleCode,
      this.lengthTolerance,
      this.toolType,
      this.toolSettingMode,
      this.radiusTolerance,
      this.toolRadius,
      this.measuringDepth,
      this.remark,
      this.useParam1,
      this.useParam2,
      this.useParam3,
      this.useParam4,
      this.createDate,
      this.creator,
      this.editor,
      this.editTime});

  MacToolMagazineData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    machineName = json['machineName'];
    magazineNo = json['magazineNo'];
    toolId = json['toolId'];
    toolName = json['toolName'];
    realToolRatedLife = json['realToolRatedLife'];
    realToolUsedLife = json['realToolUsedLife'];
    realToolLastLife = json['realToolLastLife'];
    lengthWear = json['lengthWear'];
    radiusWear = json['radiusWear'];
    protrudingLength = json['protrudingLength'];
    toolCode = json['toolCode'];
    handleCode = json['handleCode'];
    lengthTolerance = json['lengthTolerance'];
    toolType = json['toolType'];
    toolSettingMode = json['toolSettingMode'];
    radiusTolerance = json['radiusTolerance'];
    toolRadius = json['toolRadius'];
    measuringDepth = json['measuringDepth'];
    remark = json['remark'];
    useParam1 = json['useParam1'];
    useParam2 = json['useParam2'];
    useParam3 = json['useParam3'];
    useParam4 = json['useParam4'];
    createDate = json['createDate'];
    creator = json['creator'];
    editor = json['editor'];
    editTime = json['editTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['number'] = this.number;
    data['machineName'] = this.machineName;
    data['magazineNo'] = this.magazineNo;
    data['toolId'] = this.toolId;
    data['toolName'] = this.toolName;
    data['realToolRatedLife'] = this.realToolRatedLife;
    data['realToolUsedLife'] = this.realToolUsedLife;
    data['realToolLastLife'] = this.realToolLastLife;
    data['lengthWear'] = this.lengthWear;
    data['radiusWear'] = this.radiusWear;
    data['protrudingLength'] = this.protrudingLength;
    data['toolCode'] = this.toolCode;
    data['handleCode'] = this.handleCode;
    data['lengthTolerance'] = this.lengthTolerance;
    data['toolType'] = this.toolType;
    data['toolSettingMode'] = this.toolSettingMode;
    data['radiusTolerance'] = this.radiusTolerance;
    data['toolRadius'] = this.toolRadius;
    data['measuringDepth'] = this.measuringDepth;
    data['remark'] = this.remark;
    data['useParam1'] = this.useParam1;
    data['useParam2'] = this.useParam2;
    data['useParam3'] = this.useParam3;
    data['useParam4'] = this.useParam4;
    data['createDate'] = this.createDate;
    data['creator'] = this.creator;
    data['editor'] = this.editor;
    data['editTime'] = this.editTime;
    return data;
  }
}
