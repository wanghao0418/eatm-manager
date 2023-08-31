/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-23 14:00:43
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-31 15:41:58
 * @FilePath: /eatm_manager/lib/pages/business/data_entry/controller.dart
 * @Description: 数据录入逻辑层
 */
import 'package:eatm_manager/common/api/data_entry_api.dart';
import 'package:eatm_manager/common/models/selectOption.dart';
import 'package:eatm_manager/common/utils/log.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pluto_grid/pluto_grid.dart';

class DataEntryController extends GetxController {
  DataEntryController();
  EnteredDataSearch search = EnteredDataSearch(
    workmanship: 2,
    startTime: DateTime.now().toString().substring(0, 10),
    endTime:
        DateTime.now().add(const Duration(days: 3)).toString().substring(0, 10),
  );
  List<EnteredData> enteredDataList = [];
  List<PlutoRow> rows = [];
  late PlutoGridStateManager stateManager;
  final GetStorage employeeStorage = GetStorage('employeeList');

  // 作业单状态选项列表
  final List<SelectOption> processRouteList = [
    SelectOption(label: '全部', value: 0),
    SelectOption(label: '已绑定', value: 1),
    SelectOption(label: '待绑定', value: 2),
  ];

  // 作业单号输入控制器
  TextEditingController mouldSNController = TextEditingController();
  // 芯片Id输入控制器
  TextEditingController barCodeController = TextEditingController();
  // 操作员输入控制器
  TextEditingController employeeController = TextEditingController();
  // 铸件号输入控制器
  TextEditingController partSNController = TextEditingController();

  // 操作员缓存
  List? get employees => employeeStorage.read('employeeList');

  // 操作员选项列表
  List<String> get employeeList {
    List<String> data = employees == null
        ? []
        : List.from(employees!).map((e) => e.toString()).toList();
    return data;
  }

  // 查询
  void query({bool selectRow = false}) async {
    var res = await DataEntryApi.getHomeworkSheetList(search.toMap());
    if (res.success!) {
      enteredDataList = (res.data! as List)
          .map<EnteredData>((e) => EnteredData.fromJson(e))
          .toList();
      updateRows(selectRow: selectRow);
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 更新表格
  void updateRows({bool selectRow = false}) {
    rows.clear();
    for (var e in enteredDataList) {
      var index = enteredDataList.indexOf(e);
      var newRow = PlutoRow(cells: {
        'number': PlutoCell(value: index + 1),
        'mouldSn': PlutoCell(value: e.mouldSn),
        'productCode': PlutoCell(value: e.productCode ?? ''),
        'productBatch': PlutoCell(value: e.productBatch ?? ''),
        'mwPieceName': PlutoCell(value: e.mwPieceName ?? ''),
        'spec': PlutoCell(value: e.spec ?? ''),
        'machineSn': PlutoCell(value: e.machineSn ?? ''),
        'mwCount': PlutoCell(value: e.mwCount ?? ''),
        'boundCount': PlutoCell(value: e.boundCount ?? ''),
        'partSn': PlutoCell(value: e.partSn ?? ''),
        'samplingFrequency': PlutoCell(value: e.samplingFrequency ?? 0),
        'username': PlutoCell(value: e.username ?? ''),
        'sn': PlutoCell(value: e.sn ?? ''),
        'barCode': PlutoCell(value: e.barCode ?? ''),
        'workpieceType': PlutoCell(value: e.workPieceType ?? ''),
        'processRoute': PlutoCell(value: e.processRoute ?? ''),
        'curProcOrder': PlutoCell(value: e.curProcOrder ?? ''),
        'recordTime': PlutoCell(value: e.recordTime ?? ''),
      });
      stateManager.appendRows([newRow]);

      // 选中导入作业单号数据行
      if (selectRow && e.mouldSn == mouldSNController.text) {
        stateManager.setRowChecked(newRow, true);
      }
    }

    _initData();
  }

  // 新增员工
  void addEmployee(String employee) {
    if (employees == null || !employees!.contains(employee)) {
      var list = employees ?? [];
      list.add(employee);
      employeeStorage.write('employeeList', list);
    }
    _initData();
  }

  // 作业单导入
  void importHomeworkSheet() async {
    var mouldSN = mouldSNController.text;
    var userName = employeeController.text;
    if (mouldSN.isEmpty || userName.isEmpty) {
      PopupMessage.showFailInfoBar("作业单号和操作员不能为空");
      return;
    }
    addEmployee(userName);
    var res = await DataEntryApi.dataImport({
      "params": {
        "mouldSN": mouldSN,
        "userName": userName,
      }
    });
    if (res.success!) {
      PopupMessage.showSuccessInfoBar("导入成功");
      query(selectRow: true);
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 删除
  void delete() async {
    if (stateManager.checkedRows.isEmpty) {
      PopupMessage.showWarningInfoBar("请选择要删除的作业单");
      return;
    }

    PopupMessage.showConfirmDialog(
        title: '确认',
        message: '是否删除选中记录',
        onConfirm: () async {
          var moulds = stateManager.checkedRows.map((e) {
            return {"MOULDSN": e.cells['mouldSn']!.value};
          }).toList();
          var res =
              await DataEntryApi.delete({"paramsDelete": moulds, "flag": '2'});
          if (res.success!) {
            PopupMessage.showSuccessInfoBar("删除成功");
            query();
          } else {
            PopupMessage.showFailInfoBar(res.message as String);
          }
        });
  }

  // 芯片绑定
  void bind() async {
    if (stateManager.checkedRows.isEmpty) {
      PopupMessage.showWarningInfoBar("请选择一条记录");
      return;
    } else if (stateManager.checkedRows.length > 1) {
      PopupMessage.showWarningInfoBar("只能选择一条记录");
      return;
    }

    var barCode = barCodeController.text;
    var partSN = partSNController.text;

    if (barCode.isEmpty || partSN.isEmpty) {
      PopupMessage.showWarningInfoBar("芯片Id和铸件号不能为空");
      return;
    }

    var res = await DataEntryApi.barCodeBind({
      "params": {
        "BarCode": barCode,
        "PartSn": partSN,
        "mouldSN": stateManager.checkedRows.first.cells['mouldSn']!.value,
        "PROCESSROUTE": '3' // 默认钢件
      }
    });
    if (res.success!) {
      PopupMessage.showSuccessInfoBar("绑定成功");
      barCodeController.clear();
      partSNController.clear();
      // 如果没绑定完就更新数据 绑定完了刷新数据
      EnteredData data = enteredDataList.firstWhere((e) =>
          e.mouldSn == stateManager.checkedRows.first.cells['mouldSn']!.value);
      var boundCount = int.parse(data.boundCount ?? '0');
      var mwCount = int.parse(data.mwCount ?? '0');
      if (boundCount < mwCount - 1) {
        // 没绑定完
        data.boundCount = (boundCount + 1).toString();
        stateManager.checkedRows.first.cells['boundCount']!.value =
            (boundCount + 1).toString();
        _initData();
      } else {
        query();
      }
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 修改抽检频率
  void updateField(int rowIndex, String value) async {
    var rowData = enteredDataList[rowIndex];
    var samplingFrequency = rowData.samplingFrequency;
    if (samplingFrequency == value) return;
    var res = await DataEntryApi.updateByMouldSn({
      "params": {"MouldSn": rowData.mouldSn, "samplingFrequency": value},
    });
    if (res.success!) {
      PopupMessage.showSuccessInfoBar('修改成功');
      enteredDataList[rowIndex].samplingFrequency = value;
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  _initData() {
    update(["data_entry"]);
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

class EnteredDataSearch {
  int? workmanship;
  String? mouldSN;
  String? barCode;
  String? startTime;
  String? endTime;
  int querySource = 2;
  String? partSN;

  EnteredDataSearch(
      {this.workmanship,
      this.mouldSN,
      this.barCode,
      this.startTime,
      this.endTime,
      this.partSN});

  Map<String, dynamic> toMap() {
    return {
      "workmanship": workmanship,
      "MouldSn": mouldSN,
      "Barcode": barCode,
      "startTime": startTime,
      "endTime": endTime,
      "querySource": querySource,
      "partSN": partSN
    };
  }

  init() {
    workmanship = 0;
    mouldSN = null;
    barCode = null;
  }
}

class EnteredData {
  String? barCode;
  int? curProcOrder;
  int? curProcState;
  String? mouldSn;
  String? machineSn;
  String? mwPieceCode;
  String? partSn;
  String? processRoute;
  int? proCeTotal;
  int? pStePid;
  String? recordTime;
  String? resourceName;
  String? sn;
  String? spec;
  String? trayType;
  String? workPieceType;
  String? bomType;
  String? clampType;
  String? mwCount;
  String? boundCount;
  String? mwPieceName;
  String? productCode;
  String? productBatch;
  String? username;
  String? wpState;
  String? samplingFrequency;

  EnteredData(
      {this.barCode,
      this.curProcOrder,
      this.curProcState,
      this.mouldSn,
      this.machineSn,
      this.mwPieceCode,
      this.partSn,
      this.processRoute,
      this.proCeTotal,
      this.pStePid,
      this.recordTime,
      this.resourceName,
      this.sn,
      this.spec,
      this.trayType,
      this.workPieceType,
      this.bomType,
      this.clampType,
      this.mwCount,
      this.boundCount,
      this.mwPieceName,
      this.productCode,
      this.productBatch,
      this.username,
      this.wpState,
      this.samplingFrequency});

  EnteredData.fromJson(Map<String, dynamic> json) {
    barCode = json['BARCODE'];
    curProcOrder = json['CURPROCORDER'];
    curProcState = json['CURPROCSTATE'];
    mouldSn = json['MOULDSN'];
    machineSn = json['MachineSn'];
    mwPieceCode = json['Mwpiececode'];
    partSn = json['PARTSN'];
    processRoute = json['PROCESSROUTE'];
    proCeTotal = json['PROCETOTAL'];
    pStePid = json['PstePid'];
    recordTime = json['RECORDTIME'];
    resourceName = json['ResourceName'];
    sn = json['SN'];
    spec = json['SPEC'];
    trayType = json['TrayType'];
    workPieceType = json['WORKPIECETYPE'];
    bomType = json['bomType'];
    clampType = json['clamptype'];
    mwCount = json['mwcount'];
    boundCount = json['boundcount'];
    mwPieceName = json['mwpiecename'];
    productCode = json['productcode'];
    productBatch = json['productbatch'];
    username = json['username'];
    wpState = json['wpstate'];
    samplingFrequency = json['samplingFrequency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BARCODE'] = this.barCode;
    data['CURPROCORDER'] = this.curProcOrder;
    data['CURPROCSTATE'] = this.curProcState;
    data['MOULDSN'] = this.mouldSn;
    data['MachineSn'] = this.machineSn;
    data['Mwpiececode'] = this.mwPieceCode;
    data['PARTSN'] = this.partSn;
    data['PROCESSROUTE'] = this.processRoute;
    data['PROCETOTAL'] = this.proCeTotal;
    data['PstePid'] = this.pStePid;
    data['RECORDTIME'] = this.recordTime;
    data['ResourceName'] = this.resourceName;
    data['SN'] = this.sn;
    data['SPEC'] = this.spec;
    data['TrayType'] = this.trayType;
    data['WORKPIECETYPE'] = this.workPieceType;
    data['bomType'] = this.bomType;
    data['clamptype'] = this.clampType;
    data['mwcount'] = this.mwCount;
    data['boundcount'] = this.boundCount;
    data['mwpiecename'] = this.mwPieceName;
    data['productcode'] = this.productCode;
    data['productbatch'] = this.productBatch;
    data['username'] = this.username;
    data['wpstate'] = this.wpState;
    data['samplingFrequency'] = this.samplingFrequency;
    return data;
  }
}
