import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../common/utils/customWebSocket.dart';
import 'widgets/StorageMessageState.dart';

class AutoRunningController extends GetxController {
  AutoRunningController();
  late int nShelfNo = 0;
  double dAirPressure = 0.60;
  String strDataTime = "2022-11-15 18:31:30 星期二";
  final String strMessage = "就绪...";
  late int nShelvesNum = 1; //货架配置个数
  late AutoRunLog _autoRunLogJsonData;
  final DataGridController autoRunLogJsonDataController = DataGridController();
  late AutoRunLogDataSource autoRunLogDataSource;
  List<AutoRunLogData> autoRunLogData = <AutoRunLogData>[];
  late Autogenerated _autoGeneratedShel;
  late sigInitZiDongListGenerate _sigInitZiDongListGenerateData =
      sigInitZiDongListGenerate();
  late List<DataStorage> dateList = [
    DataStorage(
        shelfNum: 0,
        storageIndex: 0,
        workPieceType: "",
        stateType: 0,
        processTipInfo: "",
        priorityStatus: false)
  ];
  late StorageStateMessage storageStateMessage = StorageStateMessage(
      sigSetStorageUiStatus: SigSetStorageUiStatus(data: dateList)); //所有货架的货位信息
  final double _dWidthColumn = 100;
  late int ncurStroageNum = 0; //记录前面货架占用的货位总数
  late bool _bIsClickButton = false; //是否点击按钮获取的通讯

  late int curShelRow = 5;
  final List<int> curShelCol = [];
  final GlobalKey treeTableKey = GlobalKey();
  late List<String> columnStringName = [
    'ID',
    'WarehouseNo',
    'ScanId',
    'ModuleNo',
    'PartNo',
    'Specifications',
    'Routing',
    'CurrentProcess',
    'PriorityStatus',
    'CurrentState'
  ];

  late Map<String, double> columnWidths = {
    columnStringName[0]: _dWidthColumn,
    columnStringName[1]: 100,
    columnStringName[2]: 100,
    columnStringName[3]: 350,
    columnStringName[4]: 350,
    columnStringName[5]: 200,
    columnStringName[6]: 200,
    columnStringName[7]: 200,
    columnStringName[8]: 100,
    columnStringName[9]: 300,
  };

  late List<String> columnStringNameCh = [
    '序号',
    '库位号',
    '扫描ID',
    '模号',
    '件号',
    '规格',
    '工艺路线',
    '当前路线',
    '优先状态',
    '当前状态'
  ];
  List treeDataList = [];
  // 折叠上方部分
  bool expandTop = false;
  late CustomWebSocket _customWebSocket;
  //声明星期变量
  var weekday = [" ", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"];
  //加一个定时器 更新时间
  late String strTemp;
  late Timer _timer;

  //获取当前货位号的货位信息
  //货架号，行和列的信息，分行的一样和不一样的情况
  void ShelRowColData() {
    if (true == _autoGeneratedShel.shelfInfo?.success) {
      nShelvesNum = _autoGeneratedShel.shelfInfo!.data!.length;
      nShelvesNum = nShelvesNum > 0 ? nShelvesNum : 1;
      curShelCol.clear();
      for (int i = 0; i < _autoGeneratedShel.shelfInfo!.data!.length; i++) {
        if (nShelfNo + 1 == _autoGeneratedShel.shelfInfo!.data![i].shelfNum) {
          //计算当前货架行和列总数、行最大值
          int ShelRow = 0;
          int nShelfSpecifications = _autoGeneratedShel
              .shelfInfo!.data![i].shelfSpecifications!.length;
          for (int j = 0; j < nShelfSpecifications; j++) {
            ShelRow += _autoGeneratedShel
                .shelfInfo!.data![i].shelfSpecifications![j].row!;
            for (int m = 0;
                m <
                    _autoGeneratedShel
                        .shelfInfo!.data![i].shelfSpecifications![j].row!;
                m++) {
              curShelCol.add(_autoGeneratedShel
                  .shelfInfo!.data![i].shelfSpecifications![j].coll!);
            }
          }

          curShelRow = ShelRow;
          break;
        }
      }

      ncurStroageNum = 0;
      for (int i = 0; i < _autoGeneratedShel.shelfInfo!.data!.length; i++) {
        if (nShelfNo + 1 > _autoGeneratedShel.shelfInfo!.data![i].shelfNum!) {
          int nShelfSpecifications = _autoGeneratedShel
              .shelfInfo!.data![i].shelfSpecifications!.length;
          for (int j = 0; j < nShelfSpecifications; j++) {
            for (int m = 0;
                m <
                    _autoGeneratedShel
                        .shelfInfo!.data![i].shelfSpecifications![j].row!;
                m++) {
              ncurStroageNum += _autoGeneratedShel
                  .shelfInfo!.data![i].shelfSpecifications![j].coll!;
            }
          }
        }
      }
    }
  }

  //增加或更新一个或多个货位的信息
  void StorageIndexAddAndUpdates(StorageStateMessage storageState) {
    bool bIsOk = false; //判断是更新过

    for (int kk = 0;
        kk < storageState.sigSetStorageUiStatus!.data!.length;
        kk++) {
      for (int i = 0;
          i < storageStateMessage.sigSetStorageUiStatus!.data!.length;
          i++) {
        //货架和货位都要对应上
        if (storageState.sigSetStorageUiStatus!.data![kk].shelfNum ==
                storageStateMessage.sigSetStorageUiStatus!.data![i].shelfNum &&
            storageState.sigSetStorageUiStatus!.data![kk].storageIndex ==
                storageStateMessage
                    .sigSetStorageUiStatus!.data![i].storageIndex) {
          storageStateMessage.sigSetStorageUiStatus!.data![i] =
              storageState.sigSetStorageUiStatus!.data![kk];

          //修改一个 删除一个，方便后面增加
          storageState.sigSetStorageUiStatus!.data!.removeAt(kk);
          break;
        }
      }
    }

    if (storageState.sigSetStorageUiStatus!.data!.isNotEmpty) {
      for (int kk = 0;
          kk < storageState.sigSetStorageUiStatus!.data!.length;
          kk++) {
        storageStateMessage.sigSetStorageUiStatus!.data!
            .add(storageState.sigSetStorageUiStatus!.data![kk]);
      }
    }

    storageStateMessage.sigSetStorageUiStatus!.data!
        .sort((a, b) => (a.storageIndex!).compareTo(b.storageIndex!));

    // print("rrrrrrrrrrr ${storageStateMessage.toJson()}");
  }

  //初始化树表数据
  void _initTreeDataList(List<Map> dataList) async {
    treeDataList = [];
    for (int i = 0; i < dataList.length; i++) {
      Map itemData = dataList[i]['item'];
      Map mainData = itemData['MainWorkpieceData'];
      List children = itemData['MoreWorkoieceData'];
      mainData['children'] = children;
      treeDataList.add(mainData);
    }
    _refreshIds();
  }

  // 刷新Id
  void _refreshIds() {
    treeDataList.forEach((element) {
      element['Id'] = treeDataList.indexOf(element) + 1;
    });
    update(['auto_running']);
    ;
  }

  //更新树表数据
  void _updateTreeDataList(List<Map> dataList) {
    for (var i = 0; i < dataList.length; i++) {
      Map mainData = dataList[i]['item']['MainWorkpieceData'];
      List children = dataList[i]['item']['MoreWorkoieceData'];
      var StorageIndex = mainData['StorageIndex'];
      var updateDataIndex = treeDataList
          .indexWhere((data) => data['StorageIndex'] == StorageIndex);
      mainData['children'] = children;
      print('updateDataIndex: $updateDataIndex');
      if (updateDataIndex != -1) {
        treeDataList[updateDataIndex] = mainData;
      } else {
        treeDataList.add(mainData);
      }
    }
    _refreshIds();
  }

  //删除树表数据
  void _deleteTreeDataList(Map deleteOption) {
    switch (deleteOption['DeleteMark']) {
      // 删除所有数据
      case -1:
        treeDataList.clear();
        break;
      // 根据库位号
      case 0:
        var StorageIndex = deleteOption['StorageIndex'];
        treeDataList = treeDataList
            .where((data) => data['StorageIndex'] != StorageIndex)
            .toList();
        break;
      // 根据条码
      case 1:
        var BarCode = deleteOption['BarCode'];
        treeDataList =
            treeDataList.where((data) => data['BarCode'] != BarCode).toList();
        break;
      // 根据模号
      case 2:
        var MouldSN = deleteOption['MouldSN'];
        treeDataList =
            treeDataList.where((data) => data['MouldSN'] != MouldSN).toList();
        break;
      // 根据件号
      case 3:
        var PartSN = deleteOption['PartSN'];
        treeDataList =
            treeDataList.where((data) => data['PartSN'] != PartSN).toList();
        break;
      default:
    }
    _refreshIds();
  }

  // 初始化websocket
  void initWebSocket() async {
    // String url = await Utils.getConfigField('autoRunWebsocketUrL');
    String url = "ws://127.0.0.1:8092";
    _customWebSocket = CustomWebSocket(
      connectUrl: url,
      onMessage: (message) {
        // print('message: $message');
        // var data = json.decode(message);
        final jsonResponseShel = json.decode(message.toString());
        // print("$jsonResponseShel");
        if (jsonResponseShel["ShelfInfo"] != null) {
          Autogenerated curAutoGeneratedShel =
              Autogenerated.fromJson(jsonResponseShel);
          if (true == curAutoGeneratedShel.shelfInfo!.success) {
            _autoGeneratedShel = Autogenerated.fromJson(jsonResponseShel);
            ShelRowColData();

            if (!_bIsClickButton) {
              //发送通讯,获取所有货位信息
              _customWebSocket.send('{"sigSetStorageUiStatus": {}}');
              // _webSocketUtilityAutoRunView
              //     .sendMessage('{"sigSetStorageUiStatus": {}}');

              //增加一个延时
              Future.delayed(const Duration(milliseconds: 100), () {
                _customWebSocket.send('{"sigInitZiDongList": {}}');
                // _webSocketUtilityAutoRunView
                //     .sendMessage('{"sigInitZiDongList": {}}');
              });
            }
          } else {
            _autoGeneratedShel = Autogenerated.fromJson(jsonResponseShel);
            ShelRowColData();
          }
        } else if (jsonResponseShel["sigSetStorageUiStatus"] != null) {
          StorageStateMessage curStorageState =
              StorageStateMessage.fromJson(jsonResponseShel);
          // print("货位信息： ${curStorageState.toJson()}");
          StorageIndexAddAndUpdates(curStorageState);
          // if (curStorageState.sigSetStorageUiStatus!.shelfNum == _nShelfNo + 1) {

          // }

          // setState(() {});
          update(['auto_running']);
        } else if (jsonResponseShel["sigInitZiDongList"] != null) {
          _sigInitZiDongListGenerateData =
              sigInitZiDongListGenerate.fromJson(jsonResponseShel);

          print("ZiDongList信息： ${_sigInitZiDongListGenerateData.toJson()}");
          var sigInitZiDongList =
              _sigInitZiDongListGenerateData.toJson()['sigInitZiDongList'];
          List<Map> dataList = sigInitZiDongList['data'];
          if (dataList.length > 1) {
            _initTreeDataList(dataList);
          } else {
            _updateTreeDataList(dataList);
          }
        } else if (jsonResponseShel["sigDeleteIndexRow"] != null) {
          var sigDeleteIndexRow = jsonResponseShel['sigDeleteIndexRow'];
          _deleteTreeDataList(sigDeleteIndexRow);
        }
      },
      onOpen: () {
        // print('WebSocket连接成功');
        _customWebSocket.send('{"ShelfInfo": {}}');
      },
      onClose: () {
        print('WebSocket连接关闭');
      },
      onError: (error) {
        print('WebSocket连接错误: $error');
      },
    );
    _customWebSocket.connect();
  }

  start() {}

  stop() {}

  detailedInformation(int nAction, int nId) {
    if (nAction == 1) {
      nShelfNo = nId;
      _bIsClickButton = true;
      ShelRowColData();
      update(['auto_running']);
    } else {
      // 跳转
      // Utils.openTab('42');
      expandTop = !expandTop;
      update(['auto_running']);
    }
  }

  _initData() {
    update(["auto_running"]);
  }

  void onTap() {}

  @override
  void onInit() {
    super.onInit();
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      DateTime now = DateTime.now();
      strDataTime =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}"
          " ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}"
          " ${weekday[now.weekday]}";
    });
    initWebSocket();
    autoRunLogDataSource = AutoRunLogDataSource(employees: autoRunLogData);
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    super.onClose();
    if (_timer != null) {
      _timer.cancel();
    }
    _customWebSocket.close();
  }
}

class AutoRunLog {
  List<AutoRunLogJson>? autoRunLogJson;

  AutoRunLog({this.autoRunLogJson});

  AutoRunLog.fromJson(Map<String, dynamic> json) {
    if (json['AutoRunLogJson'] != null) {
      autoRunLogJson = <AutoRunLogJson>[];
      json['AutoRunLogJson'].forEach((v) {
        autoRunLogJson!.add(new AutoRunLogJson.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.autoRunLogJson != null) {
      data['AutoRunLogJson'] =
          this.autoRunLogJson!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AutoRunLogJson {
  String? strId;
  String? strWarehouseNo;
  String? strScanId;
  String? strModuleNo;
  String? strPartNo;
  String? strSpecifications;
  String? strRouting;
  String? strCurrentProcess;
  String? strPriorityStatus;
  String? strCurrentState;

  AutoRunLogJson(
      {this.strId,
      this.strWarehouseNo,
      this.strScanId,
      this.strModuleNo,
      this.strPartNo,
      this.strSpecifications,
      this.strRouting,
      this.strCurrentProcess,
      this.strPriorityStatus,
      this.strCurrentState});

  AutoRunLogJson.fromJson(Map<String, dynamic> json) {
    strId = json['strId'];
    strWarehouseNo = json['strWarehouseNo'];
    strScanId = json['strScanId'];
    strModuleNo = json['strModuleNo'];
    strPartNo = json['strPartNo'];
    strSpecifications = json['strSpecifications'];
    strRouting = json['strRouting'];
    strCurrentProcess = json['strCurrentProcess'];
    strPriorityStatus = json['strPriorityStatus'];
    strCurrentState = json['strCurrentState'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['strId'] = this.strId;
    data['strWarehouseNo'] = this.strWarehouseNo;
    data['strScanId'] = this.strScanId;
    data['strModuleNo'] = this.strModuleNo;
    data['strPartNo'] = this.strPartNo;
    data['strSpecifications'] = this.strSpecifications;
    data['strRouting'] = this.strRouting;
    data['strCurrentProcess'] = this.strCurrentProcess;
    data['strPriorityStatus'] = this.strPriorityStatus;
    data['strCurrentState'] = this.strCurrentState;
    return data;
  }
}

class AutoRunLogData {
  AutoRunLogData(
      this.strId,
      this.strWarehouseNo,
      this.strScanId,
      this.strModuleNo,
      this.strPartNo,
      this.strSpecifications,
      this.strRouting,
      this.strCurrentProcess,
      this.strPriorityStatus,
      this.strCurrentState);

  /*'序号',
    '库位号',
    '扫描ID',
    '模号',
    '件号'
    '规格'
    '工艺路线',
    '当前工艺',
    '优先状态',
    '当前状态'*/

  String? strId;
  String? strWarehouseNo;
  String? strScanId;
  String? strModuleNo;
  String? strPartNo;
  String? strSpecifications;
  String? strRouting;
  String? strCurrentProcess;
  String? strPriorityStatus;
  String? strCurrentState;
}

class AutoRunLogDataSource extends DataGridSource {
  AutoRunLogDataSource({required List<AutoRunLogData> employees}) {
    _employeeData = employees
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: columnStringName[0], value: e.strId),
              DataGridCell<String>(
                  columnName: columnStringName[1], value: e.strWarehouseNo),
              DataGridCell<String>(
                  columnName: columnStringName[2], value: e.strScanId),
              DataGridCell<String>(
                  columnName: columnStringName[3], value: e.strModuleNo),
              DataGridCell<String>(
                  columnName: columnStringName[4], value: e.strPartNo),
              DataGridCell<String>(
                  columnName: columnStringName[5], value: e.strSpecifications),
              DataGridCell<String>(
                  columnName: columnStringName[6], value: e.strRouting),
              DataGridCell<String>(
                  columnName: columnStringName[7], value: e.strCurrentProcess),
              DataGridCell<Text>(
                  columnName: columnStringName[8],
                  value: Text(e.strPriorityStatus!,
                      style: TextStyle(color: Color(0xFF45DA4D)))),
              DataGridCell<String>(
                  columnName: columnStringName[9], value: e.strCurrentState),
            ]))
        .toList();
  }

  late List<String> columnStringName = [
    'strId',
    'strWarehouseNo',
    'strScanId',
    'strModuleNo',
    'strPartNo',
    'strSpecifications',
    'strRouting',
    'strCurrentProcess',
    'strPriorityStatus',
    'strCurrentState'
  ];

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  Future<void> handleLoadMoreRows() async {
    await Future.delayed(Duration(milliseconds: 300));
    notifyListeners();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: (e.columnName == "strPriorityStatus")
            ? e.value
            : Text(e.value.toString()),
      );
    }).toList());
  }
}

class sigInitZiDongListGenerate {
  SigInitZiDongList? sigInitZiDongList;

  sigInitZiDongListGenerate({this.sigInitZiDongList});

  sigInitZiDongListGenerate.fromJson(Map<String, dynamic> json) {
    sigInitZiDongList = json['sigInitZiDongList'] != null
        ? SigInitZiDongList.fromJson(json['sigInitZiDongList'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (sigInitZiDongList != null) {
      data['sigInitZiDongList'] = sigInitZiDongList!.toJson();
    }
    return data;
  }
}

class SigInitZiDongList {
  List<SigInitData>? data;

  SigInitZiDongList({this.data});

  SigInitZiDongList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SigInitData>[];
      json['data'].forEach((v) {
        data!.add(SigInitData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SigInitData {
  int? state;
  int? moreWorkpieceMark;
  SigInitItem? item;

  SigInitData({this.state, this.moreWorkpieceMark, this.item});

  SigInitData.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    moreWorkpieceMark = json['MoreWorkpieceMark'];
    item = json['item'] != null ? SigInitItem.fromJson(json['item']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['state'] = state;
    data['MoreWorkpieceMark'] = moreWorkpieceMark;
    if (item != null) {
      data['item'] = item!.toJson();
    }
    return data;
  }
}

class SigInitItem {
  MainWorkpieceData? mainWorkpieceData;
  List<MoreWorkoieceData>? moreWorkoieceData;

  SigInitItem({this.mainWorkpieceData, this.moreWorkoieceData});

  SigInitItem.fromJson(Map<String, dynamic> json) {
    mainWorkpieceData = json['MainWorkpieceData'] != null
        ? MainWorkpieceData.fromJson(json['MainWorkpieceData'])
        : null;
    if (json['MoreWorkoieceData'] != null) {
      moreWorkoieceData = <MoreWorkoieceData>[];
      json['MoreWorkoieceData'].forEach((v) {
        moreWorkoieceData!.add(MoreWorkoieceData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (mainWorkpieceData != null) {
      data['MainWorkpieceData'] = mainWorkpieceData!.toJson();
    }
    if (moreWorkoieceData != null) {
      data['MoreWorkoieceData'] =
          moreWorkoieceData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MainWorkpieceData {
  int? storageIndex;
  String? barCode;
  String? mouldSN;
  String? partSN;
  String? precision;
  String? quadrant;
  String? specifications;
  String? processRoute;
  String? curProcessType;
  String? priorityStatus;
  String? electrodeSatusInfo;
  String? schStaTime;
  int? orderNum;

  MainWorkpieceData(
      {this.storageIndex,
      this.barCode,
      this.mouldSN,
      this.partSN,
      this.precision,
      this.quadrant,
      this.specifications,
      this.processRoute,
      this.curProcessType,
      this.priorityStatus,
      this.electrodeSatusInfo,
      this.schStaTime,
      this.orderNum});

  MainWorkpieceData.fromJson(Map<String, dynamic> json) {
    storageIndex = json['StorageIndex'];
    barCode = json['BarCode'];
    mouldSN = json['MouldSN'];
    partSN = json['PartSN'];
    precision = json['Precision'];
    quadrant = json['Quadrant'];
    specifications = json['Specifications'];
    processRoute = json['ProcessRoute'];
    curProcessType = json['CurProcessType'];
    priorityStatus = json['PriorityStatus'];
    electrodeSatusInfo = json['ElectrodeSatusInfo'];
    schStaTime = json['SchStaTime'];
    orderNum = json['orderNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StorageIndex'] = storageIndex;
    data['BarCode'] = barCode;
    data['MouldSN'] = mouldSN;
    data['PartSN'] = partSN;
    data['Precision'] = precision;
    data['Quadrant'] = quadrant;
    data['Specifications'] = specifications;
    data['ProcessRoute'] = processRoute;
    data['CurProcessType'] = curProcessType;
    data['PriorityStatus'] = priorityStatus;
    data['ElectrodeSatusInfo'] = electrodeSatusInfo;
    data['SchStaTime'] = schStaTime;
    data['orderNum'] = orderNum;
    return data;
  }
}

class MoreWorkoieceData {
  int? storageIndex;
  String? barCode;
  String? mouldSN;
  String? partSN;
  String? precision;
  String? quadrant;
  String? specifications;
  String? processRoute;
  String? curProcessType;
  String? priorityStatus;
  String? electrodeSatusInfo;
  String? schStaTime;
  int? orderNum;

  MoreWorkoieceData(
      {this.storageIndex,
      this.barCode,
      this.mouldSN,
      this.partSN,
      this.precision,
      this.quadrant,
      this.specifications,
      this.processRoute,
      this.curProcessType,
      this.priorityStatus,
      this.electrodeSatusInfo,
      this.schStaTime,
      this.orderNum});

  MoreWorkoieceData.fromJson(Map<String, dynamic> json) {
    storageIndex = json['StorageIndex'];
    barCode = json['BarCode'];
    mouldSN = json['MouldSN'];
    partSN = json['PartSN'];
    precision = json['Precision'];
    quadrant = json['Quadrant'];
    specifications = json['Specifications'];
    processRoute = json['ProcessRoute'];
    curProcessType = json['CurProcessType'];
    priorityStatus = json['PriorityStatus'];
    electrodeSatusInfo = json['ElectrodeSatusInfo'];
    schStaTime = json['SchStaTime'];
    orderNum = json['orderNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StorageIndex'] = storageIndex;
    data['BarCode'] = barCode;
    data['MouldSN'] = mouldSN;
    data['PartSN'] = partSN;
    data['Precision'] = precision;
    data['Quadrant'] = quadrant;
    data['Specifications'] = specifications;
    data['ProcessRoute'] = processRoute;
    data['CurProcessType'] = curProcessType;
    data['PriorityStatus'] = priorityStatus;
    data['ElectrodeSatusInfo'] = electrodeSatusInfo;
    data['SchStaTime'] = schStaTime;
    data['orderNum'] = orderNum;
    return data;
  }
}

class Autogenerated {
  ShelfInfo? shelfInfo;

  Autogenerated({this.shelfInfo});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    shelfInfo = json['ShelfInfo'] != null
        ? ShelfInfo.fromJson(json['ShelfInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (shelfInfo != null) {
      data['ShelfInfo'] = shelfInfo!.toJson();
    }
    return data;
  }
}

class ShelfInfo {
  List<Data>? data;
  String? message;
  bool? success;

  ShelfInfo({this.data, this.message, this.success});

  ShelfInfo.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    message = json['message'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['success'] = success;
    return data;
  }
}

class Data {
  int? shelfNum;
  int? startIndex;
  int? endIndex;
  List<ShelfSpecifications>? shelfSpecifications;
  String? shelfType;

  Data(
      {this.shelfNum,
      this.startIndex,
      this.endIndex,
      this.shelfSpecifications,
      this.shelfType});

  Data.fromJson(Map<String, dynamic> json) {
    shelfNum = json['ShelfNum'];
    startIndex = json['StartIndex'];
    endIndex = json['EndIndex'];
    if (json['ShelfSpecifications'] != null) {
      shelfSpecifications = <ShelfSpecifications>[];
      json['ShelfSpecifications'].forEach((v) {
        shelfSpecifications!.add(ShelfSpecifications.fromJson(v));
      });
    }
    shelfType = json['ShelfType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ShelfNum'] = shelfNum;
    data['StartIndex'] = startIndex;
    data['EndIndex'] = endIndex;
    if (shelfSpecifications != null) {
      data['ShelfSpecifications'] =
          shelfSpecifications!.map((v) => v.toJson()).toList();
    }
    data['ShelfType'] = shelfType;
    return data;
  }
}

class ShelfSpecifications {
  int? row;
  int? coll;

  ShelfSpecifications({this.row, this.coll});

  ShelfSpecifications.fromJson(Map<String, dynamic> json) {
    row = json['row'];
    coll = json['Coll'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['row'] = row;
    data['Coll'] = coll;
    return data;
  }
}

// class StorageStateMessage {
//   SigSetStorageUiStatus? sigSetStorageUiStatus;

//   StorageStateMessage({this.sigSetStorageUiStatus});

//   StorageStateMessage.fromJson(Map<String, dynamic> json) {
//     sigSetStorageUiStatus = json['sigSetStorageUiStatus'] != null
//         ? SigSetStorageUiStatus.fromJson(json['sigSetStorageUiStatus'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (sigSetStorageUiStatus != null) {
//       data['sigSetStorageUiStatus'] = sigSetStorageUiStatus!.toJson();
//     }
//     return data;
//   }
// }

// class SigSetStorageUiStatus {
//   List<DataStorage>? data;

//   SigSetStorageUiStatus({this.data});

//   SigSetStorageUiStatus.fromJson(Map<String, dynamic> json) {
//     if (json['data'] != null) {
//       data = <DataStorage>[];
//       json['data'].forEach((v) {
//         data!.add(DataStorage.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class DataStorage {
//   int? shelfNum;
//   int? storageIndex;
//   String? workPieceType;
//   int? stateType;
//   String? processTipInfo;
//   bool? priorityStatus;

//   DataStorage(
//       {this.shelfNum,
//       this.storageIndex,
//       this.workPieceType,
//       this.stateType,
//       this.processTipInfo,
//       this.priorityStatus});

//   DataStorage.fromJson(Map<String, dynamic> json) {
//     shelfNum = json['ShelfNum'];
//     storageIndex = json['StorageIndex'];
//     workPieceType = json['WorkPieceType'];
//     stateType = json['StateType'];
//     processTipInfo = json['ProcessTipInfo'];
//     priorityStatus = json['PriorityStatus'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['ShelfNum'] = shelfNum;
//     data['StorageIndex'] = storageIndex;
//     data['WorkPieceType'] = workPieceType;
//     data['StateType'] = stateType;
//     data['ProcessTipInfo'] = processTipInfo;
//     data['PriorityStatus'] = priorityStatus;
//     return data;
//   }
// }
