import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;

import 'index.dart';
import 'widgets/paperNew.dart';
import 'widgets/treeTable.dart';

class AutoRunningPage extends StatefulWidget {
  const AutoRunningPage({Key? key}) : super(key: key);

  @override
  State<AutoRunningPage> createState() => _AutoRunningPageState();
}

class _AutoRunningPageState extends State<AutoRunningPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _AutoRunningViewGetX();
  }
}

class _AutoRunningViewGetX extends GetView<AutoRunningController> {
  const _AutoRunningViewGetX({Key? key}) : super(key: key);

  //图标和信息
  List<Widget> IconMeaningShow() {
    List<Widget> ary = [];
    List<String> listIcon = ["空库位", "待扫描", "待处理", "处理中", "异常", "合格", "不合格"];
    List<String> listImg = [
      "assets/images/autoRun/1.png",
      "assets/images/autoRun/daisaomiao.png",
      "assets/images/autoRun/chuli.png",
      "assets/images/autoRun/chuli.png",
      "assets/images/autoRun/yichang.png",
      "assets/images/autoRun/hege.png",
      "assets/images/autoRun/buhege.png",
    ];

    Color colorT = Colors.white;
    // Color colorT = _colorCustomSetting.isDarkMode
    //     ? _colorCustomSetting.ColorWidget
    //     : _colorCustomSetting.ColorWidgetLight;
    for (int i = 0; i < listIcon.length; i++) {
      // colorT = _colorCustomSetting.isDarkMode
      //     ? _colorCustomSetting.ColorWidget
      //     : _colorCustomSetting.ColorWidgetLight;
      if (i == 3) {
        colorT = const Color.fromARGB(200, 255, 255, 0);
      } else if (i == 6) {
        // colorT = const Color.fromARGB(200, 255, 0, 0);
      }

      ary.add(Container(
          alignment: Alignment.center,
          width: 40,
          height: 24,
          padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
          decoration: BoxDecoration(
            //设置边框
            border: Border.all(
                // color: _colorCustomSetting.isDarkMode
                //     ? Colors.white
                //     : Colors.black,
                width: 0.5),
            //背景颜色
            color: colorT,
            //设置圆角
            // borderRadius: BorderRadius.circular((3.0)),
          ),
          child:
              i == 0 ? Text('') : Image.asset(listImg[i], fit: BoxFit.fill)));
      ary.add(Container(
          alignment: Alignment.center,
          width: 40,
          height: 20,
          child: Text(listIcon[i],
              overflow: TextOverflow.ellipsis, // 显示不完，就在后面显示点点
              style: const TextStyle(
                fontSize: 10.0,
              ))));
      ary.add(const SizedBox(width: 15));
    }

    return ary;
  }

  //圆角按钮
  List<Widget> BottomButtonShow() {
    List<Widget> ary = [];
    List<String> listButton = ["开始", "停止", "列表详情"];
    IconData? iconDataT = material.Icons.start;

    // var buttonBar = CryButtonBar(
    //   children: [
    //     CryButtons.initiator(context, () => _start()),
    //     CryButtons.shutDown(context, () => _stop()),
    //     CryButtons.detailedInformation(
    //         context, () => _detailedInformation(0, 0)),
    //   ],
    // );

    var buttonBar = material.ButtonBar(
      children: [
        FilledButton(
            onPressed: () => controller.start(), child: Text(listButton[0])),
        FilledButton(
            onPressed: () => controller.stop(), child: Text(listButton[1])),
        FilledButton(
            onPressed: () => controller.detailedInformation(0, 0),
            child: Text(listButton[2])),
      ],
    );

    ary.add(buttonBar);

    return ary;
  }

  //圆角按钮和文字
  List<Widget> ButtonMeaningShow() {
    List<Widget> ary = [];
    List<Widget> aryTemp = [];
    List<String> listButton = ["货架1", "货架2", "货架3", "货架4"];

    controller.nShelvesNum =
        controller.nShelvesNum <= 1 ? 1 : controller.nShelvesNum;
    listButton.clear();
    for (int m = 0; m < controller.nShelvesNum; m++) {
      listButton.add("货架${m + 1}");
    }

    for (int i = 0; i < listButton.length; i++) {
      // aryTemp.add(CryButtons.detailedInformation(
      //     context, () => _detailedInformation(1, i),
      //     showLabel: listButton[i]));
      aryTemp.add(FilledButton(
          onPressed: () => controller.detailedInformation(1, i),
          child: Text(listButton[i])));
    }
    var buttonBar = material.ButtonBar(
      children: aryTemp,
    );
    ary.add(buttonBar);
    return ary;
  }

  //状态界面
  List<Widget> PaperNewStateShow() {
    List<Widget> ary = [];
    List<String> listButton = ["货架1", "货架2", "货架3", "货架4"];
    controller.nShelvesNum =
        controller.nShelvesNum <= 1 ? 1 : controller.nShelvesNum;
    listButton.clear();
    for (int m = 0; m < controller.nShelvesNum; m++) {
      listButton.add("货架${m + 1}");
    }

    // 刷新当前表数据
    getRefreshedTable(index, setState) {
      if (index == -1) {
        controller.autoRunLogData = [];
        controller.autoRunLogDataSource =
            AutoRunLogDataSource(employees: controller.autoRunLogData);
      } else {
        controller.autoRunLogData =
            (controller.treeDataList[index]['children'] as List)
                .map((e) => AutoRunLogData(
                      e['Id'].toString() ?? '',
                      e['StorageIndex'].toString() ?? '',
                      e['BarCode'].toString() ?? '',
                      e['MouldSN'].toString() ?? '',
                      e['PartSN'].toString() ?? '',
                      e['Specifications'].toString() ?? '',
                      e['ProcessRoute'].toString() ?? '',
                      e['CurProcessType'].toString() ?? '',
                      e['PriorityStatus'].toString() ?? '',
                      e['ElectrodeSatusInfo'].toString() ?? '',
                    ))
                .toList();
        controller.autoRunLogDataSource =
            AutoRunLogDataSource(employees: controller.autoRunLogData);
      }

      return SfDataGridTheme(
          data: SfDataGridThemeData(
              // rowHoverColor: _colorCustomSetting.isDarkMode
              //     ? _colorCustomSetting.ColorGridTheme
              //     : _colorCustomSetting.ColorGridThemeLight,
              // selectionColor: _colorCustomSetting.ColorGridThemeSelect,
              ),
          child: SfDataGrid(
            source: controller.autoRunLogDataSource,
            showCheckboxColumn: false,
            selectionMode: SelectionMode.singleDeselect,
            // columnWidthMode: ColumnWidthMode.fill,
            allowColumnsResizing: true,
            controller: controller.autoRunLogJsonDataController,
            headerRowHeight: 40,
            onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
              setState(() {
                controller.columnWidths[details.column.columnName] =
                    details.width;
              });
              return true;
            },
            columns: [
              GridColumn(
                  columnName: 'ID',
                  visible: false,
                  minimumWidth: 100,
                  // maximumWidth: i == columnStringName.length - 1 ? 1000 : 300,
                  width: controller.columnWidths['ID']!,
                  label: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '序号',
                      ))),
              GridColumn(
                  columnName: 'WarehouseNo',
                  visible: true,
                  minimumWidth: 100,
                  // maximumWidth: i == columnStringName.length - 1 ? 1000 : 300,
                  width: controller.columnWidths['WarehouseNo']!,
                  label: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '库位号',
                      ))),
              GridColumn(
                  columnName: 'ScanId',
                  visible: true,
                  minimumWidth: 100,
                  // maximumWidth: i == columnStringName.length - 1 ? 1000 : 300,
                  width: controller.columnWidths['ScanId']!,
                  label: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '扫描ID',
                      ))),
              GridColumn(
                  columnName: 'ModuleNo',
                  visible: true,
                  minimumWidth: 100,
                  // maximumWidth: i == columnStringName.length - 1 ? 1000 : 300,
                  width: controller.columnWidths['ModuleNo']!,
                  label: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '模号',
                      ))),
              GridColumn(
                  columnName: 'PartNo',
                  visible: true,
                  minimumWidth: 100,
                  // maximumWidth: i == columnStringName.length - 1 ? 1000 : 300,
                  width: controller.columnWidths['PartNo']!,
                  label: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '件号',
                      ))),
              GridColumn(
                  columnName: 'Specifications',
                  visible: false,
                  minimumWidth: 100,
                  // maximumWidth: i == columnStringName.length - 1 ? 1000 : 300,
                  width: controller.columnWidths['Specifications']!,
                  label: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '规格',
                      ))),
              GridColumn(
                  columnName: 'Routing',
                  visible: false,
                  minimumWidth: 100,
                  // maximumWidth: i == columnStringName.length - 1 ? 1000 : 300,
                  width: controller.columnWidths['Routing']!,
                  label: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '工艺路线',
                      ))),
              GridColumn(
                  columnName: 'CurrentProcess',
                  visible: false,
                  minimumWidth: 100,
                  // maximumWidth: i == columnStringName.length - 1 ? 1000 : 300,
                  width: controller.columnWidths['CurrentProcess']!,
                  label: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '当前路线',
                      ))),
              GridColumn(
                  columnName: 'PriorityStatus',
                  visible: true,
                  minimumWidth: 100,
                  // maximumWidth: i == columnStringName.length - 1 ? 1000 : 300,
                  width: controller.columnWidths['PriorityStatus']!,
                  label: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '优先状态',
                      ))),
              GridColumn(
                  columnName: 'CurrentState',
                  visible: true,
                  minimumWidth: 100,
                  // maximumWidth: i == columnStringName.length - 1 ? 1000 : 300,
                  width: controller.columnWidths['CurrentState']!,
                  label: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '当前状态',
                      )))
            ],
          ));
    }

    var context = Get.context;
    for (int i = 0; i < listButton.length; i++) {
      ary.add(PaperNew(
          dWidth: MediaQuery.of(context!).size.width,
          dHeight: MediaQuery.of(context!).size.height / 2,
          onTapCallBack: (StorageIndex) {
            // 找到对应库位号的数据
            int index = controller.treeDataList.indexWhere(
                (element) => element['StorageIndex'] == StorageIndex);
            // 选中
            if (index != -1) {
              (controller.treeTableKey.currentState! as TreeTableState)
                  .treeController
                  .collapseAll();
              (controller.treeTableKey.currentState! as TreeTableState)
                  .setSelectedRowKey(index);
              controller.update(['auto_running']);
            } else {
              // 未找到
              (controller.treeTableKey.currentState! as TreeTableState)
                  .setSelectedRowKey(-1);
            }
            // refreshListData(index - 1);
            // 弹窗
            showDialog(
                context: context,
                builder: (context) {
                  return material.AlertDialog(
                    contentPadding: EdgeInsets.all(0),
                    content: Container(
                      width: 1300,
                      height: 600,
                      child: Container(
                        child: StatefulBuilder(builder: (context, setState) {
                          return getRefreshedTable(index, setState);
                        }),
                      ),
                    ),
                    actions: [
                      FilledButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("确定"),
                      )
                    ],
                  );
                });
          },
          curShelRow: controller.curShelRow,
          curShelCol: controller.curShelCol,
          storageStateMessagePaper: controller.storageStateMessage,
          curStroageNum: controller.ncurStroageNum));
    }

    return ary;
  }

  List<GridColumn> _gridColumnNum() {
    List<GridColumn> gridColumn = [];
    //报警提示
    // if (columnStringNameCh.length != columnStringName.length) {
    //   DialogUtils.alert(context, content: "中英文对应的字段个数不一致,请检查数据库!");
    //   return gridColumn;
    // }

    for (int i = 0; i < controller.columnStringName.length; i++) {
      gridColumn.add(GridColumn(
          columnName: controller.columnStringName[i],
          visible: [0, 5, 6, 7].contains(i) ? false : true,
          minimumWidth: 100,
          maximumWidth:
              i == controller.columnStringName.length - 1 ? 1000 : 300,
          width: controller.columnWidths[controller.columnStringName[i]]!,
          label: Container(
              alignment: Alignment.center,
              child: Text(
                controller.columnStringNameCh[i],
              ))));
    }

    return gridColumn;
  }

  // 主视图
  Widget _buildView() {
    var context = Get.context;
    return Container(
        child: Column(children: [
      !controller.expandTop
          ? Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(15.r, 15.r, 15.r, 0),
              // padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
              //背景颜色
              decoration: BoxDecoration(
                  // color: _colorCustomSetting.isDarkMode
                  //     ? _colorCustomSetting.ColorWidget
                  //     : _colorCustomSetting.ColorWidgetLight,
                  // boxShadow: [_colorCustomSetting.boxShadow],
                  ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                        child: Wrap(
                            alignment: WrapAlignment.start,
                            children: IconMeaningShow())),
                    Column(children: [
                      Container(
                        child: Row(children: ButtonMeaningShow()),
                      ),
                      material.Divider(height: 0.5),
                      Container(
                        // margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                        width: MediaQuery.of(context!).size.width,
                        height: (MediaQuery.of(context!).size.height) / 2,
                        child: PaperNewStateShow()[controller.nShelfNo],
                      ),
                    ])
                  ]))
          : Container(),
      Expanded(
          child: Container(
              margin: EdgeInsets.fromLTRB(
                  15.r,
                  15.r,
                  15.r,
                  // _colorCustomSetting.BorderDistance,
                  // _colorCustomSetting.BorderDistance,
                  // _colorCustomSetting.BorderDistance,
                  0),
              width: MediaQuery.of(context!).size.width,
              // height: MediaQuery.of(context).size.height) / 2-145),
              decoration: BoxDecoration(
                  // color: _colorCustomSetting.isDarkMode
                  //     ? _colorCustomSetting.ColorWidget
                  //     : _colorCustomSetting.ColorWidgetLight,
                  // boxShadow: [_colorCustomSetting.boxShadow],
                  ),
              child: Container(
                  child: LayoutBuilder(builder: (context, constraints) {
                return TreeTable(
                  key: controller.treeTableKey,
                  dataList: controller.treeDataList,
                  maxWidth: constraints.maxWidth,
                  cellFieldsMap: {
                    'Id': '序号',
                    'StorageIndex': '库位号',
                    'BarCode': '扫描ID',
                    'MouldSN': '模号',
                    'PartSN': '件号',
                    'Specifications': '规格',
                    'ProcessRoute': '工艺路线',
                    'CurProcessType': '当前路线',
                    'PriorityStatus': '优先状态',
                    'ElectrodeSatusInfo': '当前状态',
                  },
                  defaultColumnWidthMap: {
                    'MouldSN': 300,
                    'PartSN': 300,
                    'Specifications': 150
                  },
                );
              })))),
      Container(
          height: 77,
          // margin: EdgeInsets.all(15.r),
          decoration: BoxDecoration(
              // color: _colorCustomSetting.isDarkMode
              //     ? _colorCustomSetting.ColorWidget
              //     : _colorCustomSetting.ColorWidgetLight,
              // boxShadow: [_colorCustomSetting.boxShadow],
              ),
          child: Column(
            children: [
              Row(children: [
                Container(
                    padding: const EdgeInsets.fromLTRB(0, 5, 2, 0),
                    child: Row(
                      children: BottomButtonShow(),
                    )),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        padding: const EdgeInsets.fromLTRB(0, 5, 2, 0),
                        alignment: Alignment.center,
                        child: Text("气压: ${controller.dAirPressure} bar",
                            overflow: TextOverflow.ellipsis, // 显示不完，就在后面显示点点
                            style: const TextStyle(
                              fontSize: 12.0,
                            )))
                  ],
                ))
              ]),
              Row(children: [
                Container(
                    padding: const EdgeInsets.fromLTRB(2, 5, 0, 0),
                    child: Text(controller.strMessage,
                        overflow: TextOverflow.ellipsis, // 显示不完，就在后面显示点点
                        style: const TextStyle(
                          fontSize: 12.0,
                        ))),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        height: 20,
                        padding: const EdgeInsets.fromLTRB(0, 5, 2, 0),
                        alignment: Alignment.centerRight,
                        child: Text(controller.strDataTime,
                            overflow: TextOverflow.ellipsis, // 显示不完，就在后面显示点点
                            style: const TextStyle(
                              fontSize: 12.0,
                            )))
                  ],
                ))
              ]),
            ],
          )),
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AutoRunningController>(
      init: AutoRunningController(),
      id: "auto_running",
      builder: (_) {
        return ScaffoldPage(
          content: _buildView(),
        );
      },
    );
  }
}
