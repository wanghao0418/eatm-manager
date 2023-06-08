import 'dart:math';
import 'package:flutter/material.dart';
// import 'package:flutter_admin/data/data_color_custom_setting.dart';
// import 'package:flutter_admin/utils/log.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:styled_widget/styled_widget.dart';

class TreeTable extends StatefulWidget {
  TreeTable(
      {Key? key,
      required this.dataList,
      required this.cellFieldsMap,
      required this.maxWidth,
      this.defaultColumnWidthMap})
      : super(key: key);

  final List dataList;
  final Map<String, String> cellFieldsMap;
  final double maxWidth;
  Map<String, double>? defaultColumnWidthMap = {};
  @override
  TreeTableState createState() => TreeTableState();
}

class TreeTableState extends State<TreeTable> {
  // 树控制器
  TreeController treeController = TreeController(allNodesExpanded: false);
  // 当前悬停表头索引
  int _hoverColumnIndex = -1;
  // 当前悬停的行Key
  String _hoverRowKey = '';
  // 当前选中的行Key
  String _selectedRowKey = '';
  // 默认列宽
  double _defaultColumnWidth = 160;

  // 行高
  double _rowHeight = 50;

  double _dragStartX = 0;
  double _dragStartWidth = 0;

  // 展开icon宽度
  double _expandIconWidth = 40;

  // 表头高度
  double _headerHeight = 45;

  // 纵向滚动控制器
  ScrollController _columnScrollController = ScrollController();

  // 横向滚动控制器
  ScrollController _rowScrollController = ScrollController();

  // DataColorCustomSetting _colorCustomSetting = DataColorCustomSetting.init();

  Map<String, TreeTableShowItem> _showItemsMap = {};
  late double _maxWidth;

  // 获取行背景色
  Color _getRowBackgroundColor(int index, {bool expanded = false}) {
    if (!expanded) {
      if (index % 2 == 0) {
        return Colors.grey[200]!;
      } else {
        return Colors.transparent;
      }
    } else {
      if (index % 2 == 1) {
        return Colors.grey[200]!;
      } else {
        return Colors.transparent;
      }
    }
  }

  // 获取字段对应的值
  String _getFieldValue(String key, String keyStr) {
    var data = _getRowData(keyStr);
    if (data == null) {
      return '';
    }
    if (data.containsKey(key)) {
      return data[key].toString();
    } else {
      return '';
    }
  }

  Map _getRowData(String keyStr) {
    // 找到当前行数据
    List rowIndexList = keyStr.split('-');
    var dataList = widget.dataList;
    var data = {};
    while (rowIndexList.length > 1) {
      int rowIndex = int.parse(rowIndexList.removeAt(0));
      dataList = dataList[rowIndex]['children'];
    }
    int rowIndex = int.parse(rowIndexList.removeAt(0));
    data = dataList[rowIndex];
    return data;
  }

  void _update() {
    // 判断当前显示列是否占满整行
    List<double> showColumnWidths = _showItemsMap.values
        .toList()
        .where((element) => element.show!)
        .map((e) => e.width!)
        .toList();
    if (showColumnWidths.length == 0) {
      setState(() {});
      return;
    }
    double showWidth =
        showColumnWidths.reduce((value, element) => value + element);
    // print(showWidth);
    // 如果没有占满整行，将剩余宽度分给展示的最后一列
    if (showWidth <= _maxWidth) {
      // print('没有占满整行');
      // 获取显示的最后一列
      TreeTableShowItem lastShowColumn =
          _showItemsMap.values.toList().lastWhere((element) => element.show!);
      // 将剩余宽度分给最后一列
      lastShowColumn.width =
          lastShowColumn.width! + _maxWidth - _expandIconWidth - showWidth;
    } else {
      // 获取显示的最后一列
      TreeTableShowItem lastShowColumn =
          _showItemsMap.values.toList().lastWhere((element) => element.show!);
      // 获取显示的倒数第二列
      TreeTableShowItem lastSecondShowColumn = _showItemsMap.values
          .toList()
          .where((element) => element.index != lastShowColumn.index!)
          .toList()
          .lastWhere((element) => element.show!);
      // print(lastSecondShowColumn.labelText);
      // 记下倒数第二列的宽度
      double lastSecondShowColumnWidth = lastSecondShowColumn.width!;
      // print('倒数第二列之前$lastSecondShowColumnWidth');
      // 倒数第二列重置宽度
      lastSecondShowColumn.width = lastSecondShowColumn.defaultWidth;
      // print('倒数第二列现在${lastSecondShowColumn.width}');

      var newLastWidth = (_maxWidth -
          _expandIconWidth -
          (showWidth +
              lastSecondShowColumn.width! -
              lastSecondShowColumnWidth));
      // 将剩余宽度分给最后一列
      lastShowColumn.width = (newLastWidth >= 0
                  ? lastShowColumn.width! + newLastWidth
                  : lastShowColumn.width! - (newLastWidth).abs()) >
              0
          ? max(
              (newLastWidth >= 0
                  ? lastShowColumn.width! + newLastWidth
                  : lastShowColumn.width! - (newLastWidth).abs()),
              lastShowColumn.defaultWidth)
          : lastShowColumn.defaultWidth;
    }
    setState(() {});
  }

  // 设置选中行
  void setSelectedRowKey(int rowIndex) {
    if (rowIndex == -1) {
      return;
    }
    // 滚动到选中行
    _columnScrollController.animateTo(
      rowIndex * _rowHeight,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );

    setState(() {
      _selectedRowKey = '$rowIndex';
    });
  }

  // 监听传入maxWidth变化
  @override
  void didUpdateWidget(covariant TreeTable oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.maxWidth != widget.maxWidth) {
      _maxWidth = widget.maxWidth;
      _update();
    }
  }

  @override
  void initState() {
    _maxWidth = widget.maxWidth;
    var entries = widget.cellFieldsMap.entries.toList();
    _showItemsMap = Map.fromEntries(entries.map((e) => MapEntry(
        e.key,
        TreeTableShowItem(
            width: widget.defaultColumnWidthMap?['${e.key}'] != null
                ? widget.defaultColumnWidthMap!['${e.key}']
                : (e.value.length * 16 + 40),
            index: entries.indexOf(e),
            labelText: e.value,
            field: e.key,
            show: true))));
    _update();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 表头
  _buildHeader() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        child: Row(
          children: [
            Container(
                width: _expandIconWidth,
                height: _headerHeight,
                alignment: Alignment.center,
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.settings,
                      size: 20,
                    ),
                    onPressed: () {
                      var resullt = showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              contentPadding: EdgeInsets.all(0),
                              content: Container(
                                  width: 200,
                                  height: 400,
                                  child: StatefulBuilder(builder:
                                      (BuildContext context,
                                          StateSetter setState) {
                                    return ListView.builder(
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ListTile(
                                            selected: _showItemsMap[widget
                                                    .cellFieldsMap.keys
                                                    .toList()[index]]!
                                                .show!,
                                            // _fields.contains(widget
                                            // .cellFieldsMap.values
                                            // .toList()[index])
                                            //,
                                            title: Text(widget
                                                .cellFieldsMap.values
                                                .toList()[index]),
                                            subtitle: _showItemsMap[widget
                                                        .cellFieldsMap.keys
                                                        .toList()[index]]!
                                                    .show!
                                                ? Text('显示')
                                                : Text('隐藏'),
                                            onTap: () {
                                              _showItemsMap[widget
                                                      .cellFieldsMap.keys
                                                      .toList()[index]]!
                                                  .show = !_showItemsMap[widget
                                                      .cellFieldsMap.keys
                                                      .toList()[index]]!
                                                  .show!;

                                              setState(() {});
                                              _update();
                                            },
                                          );
                                        },
                                        itemCount: widget.cellFieldsMap.length);
                                  })),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: Text("确定"),
                                )
                              ],
                            );
                          });
                    },
                  ),
                )),
            ...List.generate(
                // _fields.length,
                _showItemsMap.values.toList().length, (index) {
              TreeTableShowItem currentItem =
                  _showItemsMap.values.toList()[index];

              return currentItem.show!
                  ? MouseRegion(
                      onHover: (event) {
                        setState(() {
                          _hoverColumnIndex = index;
                        });
                      },
                      onExit: (event) {
                        setState(() {
                          _hoverColumnIndex = -1;
                        });
                      },
                      child: Container(
                          width: currentItem.width!,
                          decoration: BoxDecoration(
                              color: _hoverColumnIndex == index
                                  ? Color.fromRGBO(90, 90, 90, 0.1)
                                  : Colors.transparent,
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Colors.grey[300]!))),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Container(
                                padding: EdgeInsets.only(left: 10),
                                height: _headerHeight,
                                alignment: Alignment.center,
                                child: Text(currentItem.labelText!),
                              )),
                              GestureDetector(
                                onHorizontalDragDown: (details) {
                                  _dragStartX = details.globalPosition.dx;
                                  _dragStartWidth = currentItem.width!;
                                },
                                onHorizontalDragUpdate: (details) {
                                  double dx =
                                      details.globalPosition.dx - _dragStartX;
                                  double newWidth = _dragStartWidth + dx;
                                  if (newWidth < 80) {
                                    newWidth = 80;
                                  }
                                  setState(() {
                                    currentItem.width = newWidth;
                                  });
                                },
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.resizeLeftRight,
                                  child: Container(
                                    width: 5,
                                    height: _headerHeight,
                                  ),
                                ),
                              ),
                            ],
                          )),
                    )
                  : Container();
            })
          ],
        ),
      );
    });
  }

  // 表体
  _buildBody() {
    return Container(
        child: Scrollbar(
      isAlwaysShown: true,
      controller: _columnScrollController,
      child: SingleChildScrollView(
        controller: _columnScrollController,
        child: TreeView(
            treeController: treeController,
            iconSize: 20,
            indent: 0,
            nodes: List.generate(
              widget.dataList.length,
              (rowIndex) => TreeNode(
                  key: Key('$rowIndex'),
                  content: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedRowKey = '$rowIndex';
                      });
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onHover: (event) {
                        setState(() {
                          _hoverRowKey = '$rowIndex';
                        });
                      },
                      onExit: (event) {
                        setState(() {
                          _hoverRowKey = '';
                        });
                      },
                      child: Container(
                        // width: constraints.maxWidth - 40,
                        decoration: BoxDecoration(
                            color: _hoverRowKey == '$rowIndex'
                                ? Colors.blue[50]
                                : _selectedRowKey == '$rowIndex'
                                    ? Colors.blue[100]
                                    : _getRowBackgroundColor(rowIndex)),
                        child: Row(children: [
                          ...List.generate(
                              //_fields.length
                              _showItemsMap.values.length, (fieldIndex) {
                            TreeTableShowItem currentItem =
                                _showItemsMap.values.toList()[fieldIndex];
                            return currentItem.show!
                                ? Container(
                                    width: currentItem.width!,
                                    height: _rowHeight,
                                    alignment: Alignment.center,
                                    child: Text(_getFieldValue(
                                        currentItem.field!, '$rowIndex')),
                                  )
                                : Container();
                          })
                        ]),
                      ),
                    ),
                  ),
                  children: _buildChildrenRow(
                      widget.dataList[rowIndex]['children'], '$rowIndex')),
            )),
      ),
    ));
  }

  // 展开行
  _buildChildrenRow(List dataList, String fatherKey) {
    return List.generate(
        dataList.length,
        (sunRowIndex) => TreeNode(
            content: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedRowKey = '$fatherKey-$sunRowIndex';
                });
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                onHover: (event) {
                  setState(() {
                    _hoverRowKey = '$fatherKey-$sunRowIndex';
                  });
                },
                onExit: (event) {
                  setState(() {
                    _hoverRowKey = '';
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: _hoverRowKey == '$fatherKey-$sunRowIndex'
                          ? Colors.blue[50]
                          : _selectedRowKey == '$fatherKey-$sunRowIndex'
                              ? Colors.blue[100]
                              : _getRowBackgroundColor(sunRowIndex,
                                  expanded: true)),
                  child: Row(children: [
                    ...List.generate(
                        // _fields.length,
                        _showItemsMap.values.length, (fieldIndex) {
                      TreeTableShowItem currentItem =
                          _showItemsMap.values.toList()[fieldIndex];
                      return currentItem.show!
                          ? Container(
                              padding: EdgeInsets.only(left: 20),
                              width: currentItem.width,
                              height: _rowHeight,
                              alignment: Alignment.center,
                              child: Text(
                                _getFieldValue(currentItem.field!,
                                    '$fatherKey-$sunRowIndex'),
                              ))
                          : Container();
                    })
                  ]),
                ),
              ),
            ),
            children: dataList[sunRowIndex]['children'] != null
                ? _buildChildrenRow(dataList[sunRowIndex]['children'],
                    '$fatherKey-$sunRowIndex')
                : []));
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        isAlwaysShown: true,
        controller: _rowScrollController,
        child: SingleChildScrollView(
          controller: _rowScrollController,
          scrollDirection: Axis.horizontal,
          child: Container(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                    child:
                        widget.dataList.length > 0 ? _buildBody() : Container())
              ],
            ),
          ),
        ));
  }
}

class TreeTableShowItem {
  double? width;
  int? index;
  String? labelText;
  String? field;
  bool? show;

  TreeTableShowItem(
      {this.width, this.index, this.labelText, this.field, this.show});

  TreeTableShowItem.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    index = json['index'];
    labelText = json['labelText'];
    field = json['field'];
    show = json['show'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['width'] = this.width;
    data['index'] = this.index;
    data['labelText'] = this.labelText;
    data['field'] = this.field;
    data['show'] = this.show;
    return data;
  }

  double get defaultWidth => labelText!.length * 16 + 40;
}
