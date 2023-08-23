import 'package:eatm_manager/common/api/tool_management/externalToolMagazine_api.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class ToolMagazineOutsideMacController extends GetxController {
  ToolMagazineOutsideMacController();
  late final PlutoGridStateManager stateManager;
  final List<PlutoRow> rows = [];
  final List<Tool> dataList = [];
  TextEditingController toolNumController = TextEditingController();
  List<Shelf> shelfList = [];
  late Shelf? currentShelf;

  // 获取刀库列表
  void getToolMagazineList() async {
    List<Future> futures = [
      ExternalToolMagazineApi.getMachineOutToolBaseInfo(),
      ExternalToolMagazineApi.getMachineOutToolQuery({}),
    ];
    // ResponseBodyApi res =
    //     await ExternalToolMagazineApi.getMachineOutToolBaseInfo({});
    // // 获取所有数据
    // ResponseBodyApi allDataRes =
    //     await ExternalToolMagazineApi.getMachineOutToolQuery({});

    List result = await Future.wait(futures);
    var flag = result.every((element) => element.success == true);

    if (flag == false) {
      return;
    }

    var shelfRes = (result[0].data as List).map((e) => e).toList();
    var toolRes =
        (result[1].data as List).map((e) => Tool.fromJson(e)).toList();

    dataList.clear();
    dataList.addAll(toolRes);

    var list = shelfRes.map((e) {
      e['list'] = toolRes
          .where((element) => int.parse(element.deviceName!) == e.shelfNo)
          .toList();
      return Shelf.fromJson(e);
    }).toList();

    shelfList = list;
    currentShelf = list.isNotEmpty ? list[0] : null;
    updateTableRows();
  }

  updateTableRows() {
    rows.clear();
    if (currentShelf != null) {
      for (var e in currentShelf!.list) {
        stateManager.appendRows([
          PlutoRow(cells: {
            "deviceName": PlutoCell(value: e.deviceName),
            'storageNum': PlutoCell(value: e.storageNum),
            'toolNum': PlutoCell(value: e.toolNum),
            'toolFullName': PlutoCell(value: e.toolFullName),
            'toolLength': PlutoCell(value: e.toolLength),
            'toolType': PlutoCell(value: e.toolType),
            'toolHiltType': PlutoCell(value: e.toolHiltType),
            'theoreticalLife': PlutoCell(value: e.theoreticalLife),
            'usedLife': PlutoCell(value: e.usedLife),
            'recordTime': PlutoCell(value: e.recordTime)
          })
        ]);
      }
    }
    _initData();
  }

  query() {
    List<Map<String, dynamic>> list;
    if (currentShelf == null) {
      list = dataList.map((e) => e.toJson()).toList();
    } else {
      list = currentShelf!.toJson()['list'];
    }
    var listData = queryData(list, {'toolNum': toolNumController.text});
    currentShelf!.list = listData.map((e) => Tool.fromJson(e)).toList();
    updateTableRows();
  }

  // 筛选 支持多个查询条件
  List queryData(List data, Map<String, dynamic> filters) {
    List<Map<String, dynamic>> result = [];
    for (Map<String, dynamic> item in data) {
      bool match = true;
      for (String key in filters.keys) {
        if (!item.containsKey(key) ||
            (filters[key] != null && item[key] != filters[key])) {
          match = false;
          continue;
        }
      }
      if (match) {
        result.add(item);
      }
    }
    return result;
  }

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

class Shelf {
  int? shelfNo;
  List<Tool> list;
  int? min;
  int? max;
  Shelf(
      {required this.shelfNo, required this.list, this.min = 0, this.max = 0});

  factory Shelf.fromJson(Map<String, dynamic> json) {
    return Shelf(
      shelfNo: json['ShelfNo'] != null
          ? int.parse(json['ShelfNo'].toString())
          : null,
      list: (json['list'] as List).map((e) => Tool.fromJson(e)).toList(),
      min: json['min'] != null ? int.parse(json['min'].toString()) : 0,
      max: json['max'] != null ? int.parse(json['max'].toString()) : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ShelfNo': shelfNo,
      'list': list.map((e) => e.toJson()).toList(),
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
