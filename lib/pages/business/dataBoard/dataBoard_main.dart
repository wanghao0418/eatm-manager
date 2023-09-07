/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-03-28 14:27:46
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-06 18:48:12
 * @FilePath: /mesui/lib/pages/dataBoard/dataBoard_main.dart
 * @Description: 数据看板主页面
 */
import 'package:eatm_manager/common/components/title_card.dart';
import 'package:eatm_manager/pages/business/dataBoard/machineRunInfo.dart';
import 'package:eatm_manager/pages/business/dataBoard/modularBox.dart';
import 'package:eatm_manager/pages/business/dataBoard/silo.dart';
import 'package:eatm_manager/pages/business/dataBoard/timeNow.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'dart:math';

class DataBoard extends StatefulWidget {
  const DataBoard({Key? key}) : super(key: key);

  @override
  State<DataBoard> createState() => _DataBoardState();
}

class _DataBoardState extends State<DataBoard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List _machineToolList = [
    'CNC1',
    'CNC2',
    'CNC3',
  ];

  List _workmanshipList = [
    {
      "label": '大工件加工',
      "dataList": [
        {"machineName": "CNC1", "number": 20},
        {"machineName": "CNC2", "number": 30},
        {"machineName": "CNC3", "number": 22}
      ]
    },
    {
      "label": '小工件加工',
      "dataList": [
        {"machineName": "CNC4", "number": 42},
        {"machineName": "CNC5", "number": 33},
        {"machineName": "CNC6", "number": 22}
      ]
    }
  ];

  List<Tool> _toolsList = List.generate(
      30,
      (index) => Tool(
          toolMagazineNumber: index,
          length: 2.1,
          radius: 3.3,
          life: 100,
          usedTime: 30));

  List<Warning> _warningList = List.generate(
      30,
      (index) => Warning(
          equipmentName: '刀具名称', toolNum: index, life: 100, usedTime: 30));

  List<_ChartData>? _chartData;
  Timer? _timer;

  Widget _renderTitleLine() {
    return Row(
      children: [
        Expanded(
            child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                      height: 80,
                      // color: Colors.red,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/dataBoard/titleBg.png'),
                              fit: BoxFit.fitHeight)),
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            colors: <Color>[
                              Color(0xff0072FF),
                              Color(0xff00EAFF),
                              Color(0xff01AAFF)
                            ],
                            tileMode: TileMode.mirror,
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.srcATop,
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: Text(
                            '大屏数据看板',
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 5),
                          ),
                        ),
                      )),
                ),
              ],
            ),
            Positioned(
                right: 20,
                top: 10,
                child:
                    Align(alignment: Alignment.centerRight, child: TimeNow())),
          ],
        )),
      ],
    );
  }

  Widget _renderContent() {
    return Row(
      children: [
        SizedBox(
          width: 20,
        ),
        Container(
          width: 400,
          child: _renderLeftColumn(),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: _renderCenterColumn(),
        ),
        SizedBox(
          width: 20,
        ),
        Container(
          width: 400,
          child: _renderRightColumn(),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }

  Widget _renderLeftColumn() {
    return Column(
      children: [
        Expanded(
            child: ModularBox(
                title: '工艺',
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: ListView(
                    // children: _renderToolList(),
                    itemExtent: 300,
                    children: _workmanshipList
                        .map((e) => _renderWorkmanShipItem(e))
                        .toList(),
                  ),
                ))),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: ModularBox(
              title: '刀具报警信息',
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    color: Color.fromRGBO(25, 87, 192, 0.7),
                    child: _buildWarningDataGrid(
                        WarningDataSource(warningData: _warningList)),
                  ))),
        ),
      ],
    );
  }

  /// Get the cartesian chart
  SfCartesianChart _buildAnimationColumnChart(dataList) {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: CategoryAxis(
            majorGridLines: const MajorGridLines(width: 0),
            labelStyle: TextStyle(color: Colors.white)),
        primaryYAxis: NumericAxis(
            majorTickLines: const MajorTickLines(color: Colors.transparent),
            axisLine: const AxisLine(width: 0),
            minimum: 0,
            maximum: 100,
            labelStyle: TextStyle(color: Colors.white)),
        series: _getDefaultColumnSeries(dataList));
  }

  /// Get the column series
  List<ColumnSeries<_ChartData, String>> _getDefaultColumnSeries(dataList) {
    return <ColumnSeries<_ChartData, String>>[
      ColumnSeries<_ChartData, String>(
        color: Colors.blueAccent,
        dataSource: _getChartData(dataList)!,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y,
      ),
    ];
  }

  Widget _renderWorkmanShipItem(workmanshipInfo) {
    return Container(
      height: 300,
      margin: EdgeInsets.only(bottom: 10),
      width: double.infinity,
      child: TitleCard(
          cardBackgroundColor: Color.fromRGBO(25, 87, 192, 0.7),
          containChild: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    workmanshipInfo['label'],
                    style: TextStyle(
                        fontSize: 14,
                        height: 2,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: _buildAnimationColumnChart(
                          workmanshipInfo['dataList'])),
                )
              ],
            ),
          )),
    );
  }

  Widget _renderRightColumn() {
    return Column(children: [
      Expanded(
          child: ModularBox(
              title: '刀具库',
              child: Container(
                padding: EdgeInsets.all(10),
                child: ListView(
                  // children: _renderToolList(),
                  itemExtent: 350,
                  children:
                      _machineToolList.map((e) => _renderToolItem(e)).toList(),
                ),
              ))),
    ]);
  }

  Widget _renderToolItem(machineToolInfo) {
    return Container(
      height: 350,
      margin: EdgeInsets.only(bottom: 10),
      width: double.infinity,
      child: TitleCard(
          cardBackgroundColor: Color.fromRGBO(25, 87, 192, 0.7),
          containChild: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    machineToolInfo,
                    style: TextStyle(
                        fontSize: 14,
                        height: 2,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.all(10),
                  child:
                      _buildToolDataGrid(ToolDataSource(toolData: _toolsList)),
                ))
              ],
            ),
          )),
    );
  }

  Widget _renderCenterColumn() {
    return Column(
      children: [
        Expanded(
            flex: 4,
            // child: Image.asset(
            //   'assets/img/kaihua.png',
            //   fit: BoxFit.cover,
            // )
            child: Container(
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Image.asset(
                      'assets/images/dataBoard/line_body.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  // 机床1
                  LayoutBuilder(builder: (context, constraints) {
                    return Transform.translate(
                      offset: Offset(constraints.maxWidth * 0.08,
                          constraints.maxHeight * 0.1),
                      child: Container(
                        child: MachineRunInfo(
                          width: constraints.maxHeight * 0.22,
                          height: constraints.maxHeight * 0.2,
                          rotateAngle: 180,
                          machineName: '机床1',
                          status: MachineStatus.paused,
                        ),
                      ),
                    );
                  }),
                  // 机床2
                  LayoutBuilder(builder: (context, constraints) {
                    return Transform.translate(
                      offset: Offset(constraints.maxWidth * 0.24,
                          constraints.maxHeight * 0.1),
                      child: Container(
                        child: MachineRunInfo(
                          width: constraints.maxHeight * 0.22,
                          height: constraints.maxHeight * 0.2,
                          rotateAngle: 180,
                          machineName: '机床2',
                          status: MachineStatus.running,
                        ),
                      ),
                    );
                  }),
                  // 机床3
                  LayoutBuilder(builder: (context, constraints) {
                    return Transform.translate(
                      offset: Offset(constraints.maxWidth * 0.4,
                          constraints.maxHeight * 0.1),
                      child: Container(
                        child: MachineRunInfo(
                          width: constraints.maxHeight * 0.22,
                          height: constraints.maxHeight * 0.2,
                          rotateAngle: 180,
                          machineName: '机床3',
                          status: MachineStatus.error,
                        ),
                      ),
                    );
                  }),
                  // 机床4
                  LayoutBuilder(builder: (context, constraints) {
                    return Transform.translate(
                      offset: Offset(constraints.maxWidth * 0.58,
                          constraints.maxHeight * 0.1),
                      child: Container(
                        child: MachineRunInfo(
                            width: constraints.maxHeight * 0.22,
                            height: constraints.maxHeight * 0.2,
                            rotateAngle: 180,
                            machineName: '机床4',
                            status: MachineStatus.idle),
                      ),
                    );
                  }),
                  // 机床5
                  LayoutBuilder(builder: (context, constraints) {
                    return Transform.translate(
                      offset: Offset(constraints.maxWidth * 0.76,
                          constraints.maxHeight * 0.1),
                      child: Container(
                        child: MachineRunInfo(
                            width: constraints.maxHeight * 0.22,
                            height: constraints.maxHeight * 0.2,
                            rotateAngle: 180,
                            machineName: '机床5',
                            status: MachineStatus.idle),
                      ),
                    );
                  }),
                  // 机床6
                  LayoutBuilder(builder: (context, constraints) {
                    return Transform.translate(
                      offset: Offset(constraints.maxWidth * 0.18,
                          constraints.maxHeight * 0.6),
                      child: Container(
                        child: MachineRunInfo(
                          width: constraints.maxHeight * 0.22,
                          height: constraints.maxHeight * 0.2,
                          status: MachineStatus.idle,
                          machineName: '机床6',
                        ),
                      ),
                    );
                  }),
                  // 机床7
                  LayoutBuilder(builder: (context, constraints) {
                    return Transform.translate(
                      offset: Offset(constraints.maxWidth * 0.36,
                          constraints.maxHeight * 0.6),
                      child: Container(
                        child: MachineRunInfo(
                          width: constraints.maxHeight * 0.22,
                          height: constraints.maxHeight * 0.2,
                          status: MachineStatus.idle,
                          machineName: '机床7',
                        ),
                      ),
                    );
                  }),
                  // 机床8
                  LayoutBuilder(builder: (context, constraints) {
                    return Transform.translate(
                      offset: Offset(constraints.maxWidth * 0.54,
                          constraints.maxHeight * 0.6),
                      child: Container(
                        child: MachineRunInfo(
                          width: constraints.maxHeight * 0.22,
                          height: constraints.maxHeight * 0.2,
                          status: MachineStatus.idle,
                          machineName: '机床8',
                        ),
                      ),
                    );
                  }),
                ],
              ),
            )),
        Container(
            height: 150,
            child: ModularBox(
                title: '产线稼动率',
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.all(10),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: _renderCropRateList()),
                            )))
                  ],
                ))),
        SizedBox(
          height: 20,
        ),
        Expanded(
          flex: 3,
          child: ModularBox(
              title: '产线料仓',
              child: Container(
                padding: EdgeInsets.all(10),
                child: Silo(),
              )),
        ),
      ],
    );
  }

  SfDataGrid _buildToolDataGrid(DataGridSource toolDataSource) {
    return SfDataGrid(
      source: toolDataSource,
      columnWidthMode: ColumnWidthMode.fill,
      columns: [
        GridColumn(
            columnName: 'toolMagazineNumber',
            label: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.center,
                child: Text(
                  '刀库号',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ))),
        GridColumn(
            columnName: 'radius',
            label: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.center,
                child: Text(
                  '半径',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ))),
        GridColumn(
            columnName: 'length',
            label: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.center,
                child: Text(
                  '长度',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ))),
        GridColumn(
            columnName: 'life',
            label: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.center,
                child: Text(
                  '寿命',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ))),
        GridColumn(
            columnName: 'usedTime',
            label: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.center,
                child: Text(
                  '已用时间',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ))),
      ],
    );
  }

  SfDataGrid _buildWarningDataGrid(DataGridSource warningDataSource) {
    return SfDataGrid(
      source: warningDataSource,
      columnWidthMode: ColumnWidthMode.fill,
      columns: [
        GridColumn(
            columnName: 'toolMagazineNumber',
            label: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.center,
                child: Text(
                  '设备名称',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ))),
        GridColumn(
            columnName: 'radius',
            label: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.center,
                child: Text(
                  '刀具号',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ))),
        GridColumn(
            columnName: 'life',
            label: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.center,
                child: Text(
                  '寿命',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ))),
        GridColumn(
            columnName: 'usedTime',
            label: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.center,
                child: Text(
                  '已用时间',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ))),
      ],
    );
  }

  List<Widget> _renderCropRateList() {
    List<Widget> list = [];

    for (var i = 0; i < _machineToolList.length; i++) {
      list.add(_renderCropRateItem(_machineToolList[i]));
      if (i != _machineToolList.length - 1) {
        list.add(SizedBox(
          width: 5,
        ));
      }
    }

    return list;
  }

  Widget _renderCropRateItem(machineToolInfo) {
    return TitleCard(
        cardBackgroundColor: Color.fromRGBO(25, 87, 192, 0.7),
        containChild: Container(
            // decoration: BoxDecoration(
            //   border: Border.all(color: Color(0xff307DFC), width: 2),
            // ),
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Container(
              width: 130,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      machineToolInfo,
                      style: TextStyle(
                          fontSize: 12,
                          height: 2,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                      child: Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      child: fluent_ui.ProgressRing(value: 50),
                    ),
                  ))
                ],
              ),
            ))
          ],
        )));
  }

  ///Generate random value
  int _getRandomInt(int min, int max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }

  ///Generate random data points
  List<_ChartData> _getChartData(dataList) {
    var chartData = <_ChartData>[];
    for (int i = 0; i < dataList.length; i++) {
      chartData!
          .add(_ChartData(dataList[i]['machineName'], _getRandomInt(0, 100)));
    }
    return chartData;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _timer = Timer(const Duration(seconds: 2), () {
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage('assets/img/bg.png'),
          //   fit: BoxFit.fill, // 完全填充
          // ),
          color: Color(0xff0C123C),
        ),
        child: Column(children: [
          _renderTitleLine(),
          Expanded(child: _renderContent()),
          SizedBox(height: 20)
        ]),
      ),
    );
  }
}

class Tool {
  int? toolMagazineNumber;
  double? radius;
  double? length;
  int? life;
  int? usedTime;

  Tool(
      {this.toolMagazineNumber,
      this.radius,
      this.length,
      this.life,
      this.usedTime});

  Tool.fromJson(Map<String, dynamic> json) {
    toolMagazineNumber = json['toolMagazineNumber'];
    radius = json['radius'];
    length = json['length'];
    life = json['life'];
    usedTime = json['usedTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['toolMagazineNumber'] = this.toolMagazineNumber;
    data['radius'] = this.radius;
    data['length'] = this.length;
    data['life'] = this.life;
    data['usedTime'] = this.usedTime;
    return data;
  }
}

class ToolDataSource extends DataGridSource {
  List<DataGridRow> _toolRows = [];

  ToolDataSource({required List<Tool> toolData}) {
    _toolRows = toolData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(
                  columnName: 'toolMagazineNumber',
                  value: e.toolMagazineNumber),
              DataGridCell<double>(columnName: 'radius', value: e.radius),
              DataGridCell<double>(columnName: 'length', value: e.length),
              DataGridCell<int>(columnName: 'life', value: e.life),
              DataGridCell<int>(columnName: 'usedTime', value: e.usedTime),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _toolRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        // padding: EdgeInsets.all(8.0),
        child: Text(
          e.value != null ? e.value.toString() : '',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }).toList());
  }
}

class Warning {
  String? equipmentName;
  int? toolNum;
  int? life;
  int? usedTime;

  Warning({this.equipmentName, this.toolNum, this.life, this.usedTime});

  Warning.fromJson(Map<String, dynamic> json) {
    equipmentName = json['equipmentName'];
    toolNum = json['toolNum'];
    life = json['life'];
    usedTime = json['usedTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['equipmentName'] = this.equipmentName;
    data['toolNum'] = this.toolNum;
    data['life'] = this.life;
    data['usedTime'] = this.usedTime;
    return data;
  }
}

class WarningDataSource extends DataGridSource {
  List<DataGridRow> _warningRows = [];

  WarningDataSource({required List<Warning> warningData}) {
    _warningRows = warningData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: 'equipmentName', value: e.equipmentName),
              DataGridCell<int>(columnName: 'toolNum', value: e.toolNum),
              DataGridCell<int>(columnName: 'life', value: e.life),
              DataGridCell<int>(columnName: 'usedTime', value: e.usedTime),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _warningRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        // padding: EdgeInsets.all(8.0),
        child: Text(
          e.value != null ? e.value.toString() : '',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }).toList());
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final int y;
}
