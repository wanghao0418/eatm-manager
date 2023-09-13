import 'package:eatm_manager/common/utils/http.dart';
import 'package:eatm_manager/common/api/tool_management/externalToolMagazine_api.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:eatm_manager/pages/business/tool_management/tool_magazine_outside_mac/widgets/add_tool_form.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class ToolMagazineOutsideMacController extends GetxController {
  ToolMagazineOutsideMacController();
  late final PlutoGridStateManager stateManager;
  ExternalToolSearch search = ExternalToolSearch();
  final List<PlutoRow> rows = [];
  List<Tool> dataList = [];
  TextEditingController toolNumController = TextEditingController();
  List<Shelf> shelfList = [];
  late Shelf? currentShelf;
  // 货位集合
  Map<int, Tool?> shelfToolMap = {};

  // 获取刀具货架列表
  void getShelfList() async {
    var res = await ExternalToolMagazineApi.getMachineOutToolBaseInfo();
    if (res.success!) {
      shelfList = (res.data as List).map((e) => Shelf.fromJson(e)).toList();
      currentShelf = shelfList.isNotEmpty ? shelfList.first : null;
      search.shelfNo = currentShelf == null ? null : currentShelf!.shelfNo;
      _initData();
      // 查询第一个货架的数据
      query();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 初始化货位
  void initStorages(Shelf shelf) {
    shelfToolMap = {};
    for (int i = shelf.min!; i <= shelf.max!; i++) {
      shelfToolMap[i] = null;
    }
  }

  // 查询
  void query() async {
    if (currentShelf != null) {
      initStorages(currentShelf!);
    }
    var res = await ExternalToolMagazineApi.getMachineOutToolQuery(
        {"params": search.toJson()});
    if (res.success!) {
      dataList = (res.data as List).map((e) => Tool.fromJson(e)).toList();
      // dataList.sort((a, b) => a.storageNum!.compareTo(b.storageNum!));
      for (var i = 0; i < dataList.length; i++) {
        var data = dataList[i];
        if (shelfToolMap.containsKey(data.storageNum)) {
          shelfToolMap[dataList[i].storageNum!] = dataList[i];
        }
      }
      updateTableRows();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 修改
  void toolUpdate(ToolAdd tool) async {
    var res = await ExternalToolMagazineApi.machineOutToolUpdate(
        {"params": tool.toMap()});
    if (res.success!) {
      PopupMessage.showSuccessInfoBar('操作成功');
      query();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 删除
  void toolDelete() async {
    if (stateManager.checkedRows.isEmpty) {
      PopupMessage.showWarningInfoBar('请选择刀具');
      return;
    }
    List storageNumList = stateManager.checkedRows
        .map((e) => e.cells['storageNum']!.value)
        .toList();
    var res = await ExternalToolMagazineApi.machineOutToolDelete({
      "params": {"storageNum": storageNumList}
    });
    if (res.success!) {
      PopupMessage.showSuccessInfoBar('操作成功');
      query();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 获取刀库列表
  // void getToolMagazineList() async {
  //   List<Future<ResponseApiBody>> futures = [
  //     ExternalToolMagazineApi.getMachineOutToolBaseInfo(),
  //     ExternalToolMagazineApi.getMachineOutToolQuery({}),
  //   ];
  //   // ResponseBodyApi res =
  //   //     await ExternalToolMagazineApi.getMachineOutToolBaseInfo({});
  //   // // 获取所有数据
  //   // ResponseBodyApi allDataRes =
  //   //     await ExternalToolMagazineApi.getMachineOutToolQuery({});

  //   List<ResponseApiBody> result = await Future.wait(futures);
  //   var flag = result.every((element) => element.success == true);

  //   if (flag == false) {
  //     return;
  //   }

  //   var shelfRes = (result[0].data as List);
  //   var toolRes =
  //       (result[1].data as List).map((e) => Tool.fromJson(e)).toList();

  //   dataList.clear();
  //   dataList.addAll(toolRes);

  //   var list = shelfRes.map((e) {
  //     e['list'] = toolRes
  //         .where((element) => int.parse(element.deviceName!) == e['ShelfNo'])
  //         .map((e) => e.toJson())
  //         .toList();
  //     return Shelf.fromJson(e);
  //   }).toList();

  //   shelfList = list;
  //   currentShelf = list.isNotEmpty ? list[0] : null;
  //   updateTableRows();
  // }

  updateTableRows() {
    rows.clear();
    if (currentShelf != null) {
      for (var e in shelfToolMap.entries) {
        stateManager.appendRows([
          PlutoRow(cells: {
            "deviceName": PlutoCell(value: currentShelf!.shelfNo),
            'storageNum': PlutoCell(value: e.key),
            'toolNum': PlutoCell(value: e.value?.toolNum ?? ''),
            'toolFullName': PlutoCell(value: e.value?.toolFullName ?? ''),
            'toolLength': PlutoCell(value: e.value?.toolLength ?? ''),
            'toolType': PlutoCell(value: e.value?.toolType ?? ''),
            'toolHiltType': PlutoCell(value: e.value?.toolHiltType ?? ''),
            'theoreticalLife': PlutoCell(value: e.value?.theoreticalLife ?? ''),
            'usedLife': PlutoCell(value: e.value?.usedLife ?? ''),
            'recordTime': PlutoCell(value: e.value?.recordTime ?? ''),
            'data': PlutoCell(value: e.value)
          })
        ]);
      }
    }
    _initData();
  }

  // query() {
  //   List<Map<String, dynamic>> list;
  //   if (currentShelf == null) {
  //     list = dataList.map((e) => e.toJson()).toList();
  //   } else {
  //     list = dataList
  //         .where((element) =>
  //             int.parse(element.deviceName!) == currentShelf!.shelfNo)
  //         .map((e) => e.toJson())
  //         .toList();
  //   }
  //   if (toolNumController.text.isEmpty) {
  //     currentShelf!.list = list.map((e) => Tool.fromJson(e)).toList();
  //     updateTableRows();
  //     return;
  //   }

  //   var listData = queryData(list, {'toolNum': toolNumController.text});
  //   currentShelf!.list = listData.map((e) => Tool.fromJson(e)).toList();
  //   updateTableRows();
  // }

  // // 筛选 支持多个查询条件
  // List queryData(List data, Map<String, dynamic> filters) {
  //   List<Map<String, dynamic>> result = [];
  //   for (Map<String, dynamic> item in data) {
  //     bool match = true;
  //     for (String key in filters.keys) {
  //       if (!item.containsKey(key) ||
  //           (filters[key] != null && item[key] != filters[key])) {
  //         match = false;
  //         continue;
  //       }
  //     }
  //     if (match) {
  //       result.add(item);
  //     }
  //   }
  //   return result;
  // }

  _initData() {
    update(["tool_magazine_outside_mac"]);
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

class ExternalToolSearch {
  int? shelfNo;
  String? toolNum;

  ExternalToolSearch({this.shelfNo, this.toolNum});

  ExternalToolSearch.fromJson(Map<String, dynamic> json) {
    shelfNo = json['shelfNo'];
    toolNum = json['toolNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shelfNo'] = this.shelfNo;
    data['toolNum'] = this.toolNum;
    return data;
  }
}

class Shelf {
  int? shelfNo;
  // List<Tool> list;
  int? min;
  int? max;
  Shelf({required this.shelfNo, this.min = 0, this.max = 0});

  factory Shelf.fromJson(Map<String, dynamic> json) {
    return Shelf(
      shelfNo: json['ShelfNo'] != null
          ? int.parse(json['ShelfNo'].toString())
          : null,
      // list: (json['list'] as List).map((e) => Tool.fromJson(e)).toList(),
      min: json['min'] != null ? int.parse(json['min'].toString()) : 0,
      max: json['max'] != null ? int.parse(json['max'].toString()) : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ShelfNo': shelfNo,
      // 'list': list.map((e) => e.toJson()).toList(),
      'min': min,
      'max': max,
    };
  }
}

class Tool {
  String? deviceName;
  int? storageNum;
  String? toolNum;
  String? toolFullName;
  String? toolLength;
  String? toolType;
  String? toolHiltType;
  String? theoreticalLife;
  String? usedLife;
  String? recordTime;

  Tool(
      {this.deviceName,
      this.storageNum,
      this.toolNum,
      this.toolFullName,
      this.toolLength,
      this.toolType,
      this.toolHiltType,
      this.theoreticalLife,
      this.usedLife,
      this.recordTime});

  Tool.fromJson(Map<String, dynamic> json) {
    deviceName = json['DeviceName'];
    storageNum = json['StorageNum'];
    toolNum = json['ToolNum'];
    toolFullName = json['ToolFullName'];
    toolLength = json['ToolLength'];
    toolType = json['ToolType'];
    toolHiltType = json['ToolHiltType'];
    theoreticalLife = json['TheoreticalLife'];
    usedLife = json['UesdLife'];
    recordTime = json['RecordTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DeviceName'] = this.deviceName;
    data['StorageNum'] = this.storageNum;
    data['ToolNum'] = this.toolNum;
    data['ToolFullName'] = this.toolFullName;
    data['ToolLength'] = this.toolLength;
    data['ToolType'] = this.toolType;
    data['ToolHiltType'] = this.toolHiltType;
    data['TheoreticalLife'] = this.theoreticalLife;
    data['UesdLife'] = this.usedLife;
    data['RecordTime'] = this.recordTime;
    return data;
  }
}
