/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-31 16:08:06
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-31 18:04:49
 * @FilePath: /eatm_manager/lib/pages/business/data_entry/widgets/order_detail.dart
 * @Description: 作业单详情
 */
import 'package:eatm_manager/common/api/data_entry_api.dart';
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/models/selectOption.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:eatm_manager/pages/business/data_entry/controller.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class OrderDetail extends StatefulWidget {
  const OrderDetail({Key? key, required this.mouldSN}) : super(key: key);
  final String mouldSN;
  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  GlobalTheme get globalTheme => GlobalTheme.instance;
  List<PlutoRow> rows = [];
  List<EnteredData> enteredDataList = [];
  late PlutoGridStateManager stateManager;
  late EnteredDataSearch search;

  final List<ComboBoxItem<String>> processOptionList = [
    const ComboBoxItem(
      value: '3',
      child: Text('加工'),
    ),
    const ComboBoxItem(
      value: '4',
      child: Text('检测'),
    ),
    const ComboBoxItem(
      value: '3-4',
      child: Text('加工-检测'),
    ),
  ];

  // 查询
  void query() async {
    var res = await DataEntryApi.getEntryDataList({"params": search.toMap()});
    if (res.success!) {
      enteredDataList =
          (res.data as List).map((e) => EnteredData.fromJson(e)).toList();
      updateRows();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 更新表格
  updateRows() {
    rows.clear();
    for (var data in enteredDataList) {
      var index = enteredDataList.indexOf(data);
      var row = PlutoRow(cells: {
        'index': PlutoCell(value: index + 1),
        'mouldSN': PlutoCell(value: data.mouldSn ?? ''),
        'productCode': PlutoCell(value: data.productCode ?? ''),
        'productBatch': PlutoCell(value: data.productBatch ?? ''),
        'mwPieceName': PlutoCell(value: data.mwPieceName ?? ''),
        'spec': PlutoCell(value: data.spec ?? ''),
        'partSN': PlutoCell(value: data.partSn ?? ''),
        'barcode': PlutoCell(value: data.barCode ?? ''),
        'processRoute': PlutoCell(value: data.processRoute ?? ''),
        'recordTime': PlutoCell(value: data.recordTime ?? ''),
        'SN': PlutoCell(value: data.sn ?? ''),
      });
      stateManager.appendRows([row]);
    }
    setState(() {});
  }

  // 修改工艺
  void updateField(int rowIdx, String value) async {
    var data = enteredDataList[rowIdx];
    var res = await DataEntryApi.updateBySNAndBarcode({
      "params": {"SN": data.sn, "Barcode": data.barCode, "PROCESSROUTE": value}
    });
    if (res.success!) {
      PopupMessage.showSuccessInfoBar('操作成功');
      data.processRoute = value;
      setState(() {
        stateManager.rows[rowIdx].cells['processRoute']!.value = value;
      });
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 解绑
  void delete() async {
    if (stateManager.checkedRows.isEmpty) {
      PopupMessage.showWarningInfoBar('请选择要解绑的数据');
      return;
    }
    PopupMessage.showConfirmDialog(
        title: '确认',
        message: '是否删除选中记录',
        onConfirm: () async {
          var res = await DataEntryApi.delete({
            "params": stateManager.checkedRows
                .map((row) => {
                      "SN": row.cells['SN']!.value,
                      "Barcode": row.cells['barcode']!.value,
                    })
                .toList(),
            "flag": "1"
          });
          if (res.success!) {
            PopupMessage.showSuccessInfoBar('操作成功');
            query();
            // 通知页面刷新
            DataEntryController pageController =
                Get.find<DataEntryController>();
            pageController.query();
          } else {
            PopupMessage.showFailInfoBar(res.message as String);
          }
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    search = EnteredDataSearch(workmanship: 1, mouldSN: widget.mouldSN);
    super.initState();
  }

  // 操作栏
  Widget buildActionBar() {
    var formItemRow = Row(
      children: [
        Expanded(
            child: Wrap(
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            LineFormLabel(
                label: '芯片Id',
                width: 250,
                isExpanded: true,
                child: TextBox(
                  placeholder: "芯片Id",
                  onChanged: (value) {
                    search.barCode = value;
                  },
                )),
            LineFormLabel(
                label: '铸件号',
                width: 250,
                isExpanded: true,
                child: TextBox(
                  placeholder: "铸件号",
                  onChanged: (value) {
                    search.partSN = value;
                  },
                ))
          ],
        ))
      ],
    );

    var buttonRow = Row(
      children: [
        Expanded(
            child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            FilledButton(
              onPressed: query,
              child: const Text('查询'),
            ),
            FilledButton(onPressed: delete, child: const Text('解绑'))
          ],
        ))
      ],
    );

    return Container(
      padding: globalTheme.contentPadding,
      decoration: globalTheme.contentDecoration,
      child: Column(children: [formItemRow, 10.verticalSpace, buttonRow]),
    );
  }

  // 表格
  Widget buildTable() {
    return Container(
      decoration: globalTheme.contentDecoration,
      child: PlutoGrid(
        columns: [
          PlutoColumn(
              title: '序号',
              field: 'index',
              type: PlutoColumnType.text(),
              readOnly: true,
              width: 100,
              frozen: PlutoColumnFrozen.start,
              enableRowChecked: true),
          PlutoColumn(
            title: '作业单号',
            field: 'mouldSN',
            minWidth: 100,
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '产品编码',
            field: 'productCode',
            minWidth: 100,
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '产品批号',
            field: 'productBatch',
            minWidth: 100,
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '产品名称',
            field: 'mwPieceName',
            minWidth: 100,
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '规格型号',
            field: 'spec',
            minWidth: 100,
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '铸件号',
            field: 'partSN',
            minWidth: 100,
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '芯片Id',
            field: 'barcode',
            minWidth: 100,
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '工艺路线',
            field: 'processRoute',
            minWidth: 100,
            readOnly: true,
            type: PlutoColumnType.text(),
            renderer: (rendererContext) {
              var val = rendererContext.cell.value;
              return Center(
                child: Container(
                  width: 120,
                  child: ComboBox<String>(
                    placeholder: const Text('选择工艺'),
                    isExpanded: true,
                    items: processOptionList,
                    value: val,
                    onChanged: (v) {
                      var rowIndex = rendererContext.rowIdx;
                      updateField(rowIndex, v!);
                    },
                  ),
                ),
              );
            },
          ),
          PlutoColumn(
            title: '绑定时间',
            field: 'recordTime',
            minWidth: 100,
            type: PlutoColumnType.time(),
            readOnly: true,
          ),
        ],
        rows: rows,
        onLoaded: (event) {
          stateManager = event.stateManager;
          query();
        },
        configuration: globalTheme.plutoGridConfig,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: globalTheme.contentPadding,
      width: double.infinity,
      height: double.infinity,
      child: Column(children: [
        buildActionBar(),
        globalTheme.contentDistance.verticalSpace,
        Expanded(child: buildTable())
      ]),
    );
  }
}
