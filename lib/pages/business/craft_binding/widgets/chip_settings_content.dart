/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-14 16:42:31
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-25 17:45:34
 * @FilePath: /eatm_manager/lib/pages/business/craft_binding/widgets/chip_settings_content.dart
 * @Description: 芯片设置弹窗内容
 */
import 'package:eatm_manager/common/api/main_barcode_api.dart';
import 'package:eatm_manager/common/components/filled_icon_button.dart';
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/models/selectOption.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/utils/http.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:pluto_grid/pluto_grid.dart';

class ChipSettingsContent extends StatefulWidget {
  const ChipSettingsContent({Key? key, required this.trayTypeList})
      : super(key: key);
  final List<SelectOption> trayTypeList;
  @override
  _ChipSettingsContentState createState() => _ChipSettingsContentState();
}

class _ChipSettingsContentState extends State<ChipSettingsContent> {
  GlobalTheme get globalTheme => GlobalTheme.instance;
  List<PlutoRow> rows = [];
  ChipSettingsSearch search = ChipSettingsSearch();
  List<BarcodeInfo> barcodeInfoList = [];
  late PlutoGridStateManager stateManager;

  @override
  void initState() {
    // 选中第一个托盘类型
    search.trayType =
        widget.trayTypeList.isNotEmpty ? widget.trayTypeList.first.value : null;
    // TODO: implement initState
    super.initState();
  }

  // 匹配
  void match() async {
    if (search.validate() == false) {
      PopupMessage.showWarningInfoBar('未填写主副芯片或选择托盘类型');
      return;
    }
    ResponseApiBody res = await MainBarcodeApi.match(search.toJson());
    if (res.success!) {
      PopupMessage.showSuccessInfoBar(res.message as String);
      // SmartDialog.showToast(res.message as String);
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
      // SmartDialog.showToast(res.message as String);
    }
  }

  // 搜索
  void queryBarcode() async {
    if (search.mainBarcode == null && search.assistantBarcode == null) {
      PopupMessage.showWarningInfoBar('请输入芯片号或者子芯片号');
      return;
    }
    ResponseApiBody res = await MainBarcodeApi.query(search.toJson());
    if (res.success!) {
      barcodeInfoList = (res.data as List)
          .map((e) => BarcodeInfo.fromJson(e as Map<String, dynamic>))
          .toList();
      PopupMessage.showSuccessInfoBar(res.message as String);

      //更新表格
      updateRows();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 更新表格
  void updateRows() {
    rows.clear();
    for (var e in barcodeInfoList) {
      var index = barcodeInfoList.indexOf(e);
      stateManager.appendRows([
        PlutoRow(cells: {
          'number': PlutoCell(value: index + 1),
          'mainChip': PlutoCell(value: e.barCode),
          'subChip': PlutoCell(value: e.subBarCode),
          'trayType': PlutoCell(value: e.trayType),
        })
      ]);
    }
    setState(() {});
  }

  // 解绑
  void unbind() async {
    if (search.mainBarcode == null || search.assistantBarcode == null) {
      PopupMessage.showWarningInfoBar('请输入主副芯片号');
      return;
    }
    ResponseApiBody res = await MainBarcodeApi.unbind(search.toJson());
    if (res.success!) {
      PopupMessage.showSuccessInfoBar(res.message as String);
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 交换
  void exchange() async {
    if (search.mainBarcode == null || search.assistantBarcode == null) {
      PopupMessage.showWarningInfoBar('请输入主副芯片号');
      return;
    }
    ResponseApiBody res = await MainBarcodeApi.exchange(search.toJson());
    if (res.success!) {
      PopupMessage.showSuccessInfoBar(res.message as String);
      var temp = search.mainBarcode;
      search.mainBarcode = search.assistantBarcode;
      search.assistantBarcode = temp;
      setState(() {});
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 表单项
  Widget _buildFormItems() {
    return Container(
      decoration: globalTheme.contentDecoration,
      padding: globalTheme.contentPadding,
      child: Column(children: [
        Row(
          children: [
            Expanded(
                child: LineFormLabel(
                    label: '主芯片',
                    isExpanded: true,
                    child: TextBox(
                      placeholder: '请输入',
                      onChanged: (value) {
                        search.mainBarcode = value;
                      },
                    ))),
            10.horizontalSpace,
            Expanded(
                child: LineFormLabel(
                    label: '副芯片',
                    isExpanded: true,
                    child: TextBox(
                      placeholder: '请输入',
                      onChanged: (value) {
                        search.assistantBarcode = value;
                      },
                    ))),
            10.horizontalSpace,
            Expanded(
                child: LineFormLabel(
              label: '托盘类型',
              isExpanded: true,
              child: ComboBox<String?>(
                value: search.trayType,
                placeholder: const Text('请选择'),
                items: widget.trayTypeList
                    .map((e) => ComboBoxItem<String?>(
                        value: e.value,
                        child: Tooltip(
                          message: e.label,
                          child: Text(
                            e.label!,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )))
                    .toList(),
                onChanged: (value) {
                  search.trayType = value;
                  setState(() {});
                },
              ),
            )),
          ],
        ),
        10.verticalSpace,
        SizedBox(
          width: double.infinity,
          child: Wrap(
            spacing: 10.w,
            children: [
              FilledIconButton(
                  icon: FluentIcons.search_and_apps,
                  label: '查询',
                  onPressed: queryBarcode),
              FilledIconButton(
                  icon: FluentIcons.add_link, label: '匹配', onPressed: match),
              FilledIconButton(
                  icon: FluentIcons.remove_occurrence,
                  label: '解绑',
                  onPressed: unbind),
              FilledIconButton(
                  icon: FluentIcons.repeat_all,
                  label: '交换',
                  onPressed: exchange)
            ],
          ),
        )
      ]),
    );
  }

  // 表格
  Widget _buildTable() {
    return Container(
      decoration: globalTheme.contentDecoration,
      child: PlutoGrid(
        columns: [
          PlutoColumn(
              title: '序号',
              field: 'number',
              readOnly: true,
              type: PlutoColumnType.text()),
          PlutoColumn(
              title: '主芯片',
              field: 'mainChip',
              readOnly: true,
              type: PlutoColumnType.text()),
          PlutoColumn(
              title: '副芯片',
              field: 'subChip',
              readOnly: true,
              type: PlutoColumnType.text()),
          PlutoColumn(
              title: '托盘类型',
              field: 'trayType',
              readOnly: true,
              type: PlutoColumnType.text()),
        ],
        rows: rows,
        onLoaded: (event) {
          stateManager = event.stateManager;
        },
        configuration: globalTheme.plutoGridConfig.copyWith(
            columnSize: const PlutoGridColumnSizeConfig(
                autoSizeMode: PlutoAutoSizeMode.scale)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return material.Scaffold(
      body: Container(
          padding: globalTheme.contentPadding,
          child: Column(
            children: [
              _buildFormItems(),
              globalTheme.contentDistance.verticalSpace,
              Expanded(child: _buildTable())
            ],
          )),
    );
  }
}

class ChipSettingsSearch {
  String? mainBarcode;
  String? assistantBarcode;
  String? trayType;

  ChipSettingsSearch({this.mainBarcode, this.assistantBarcode, this.trayType});

  ChipSettingsSearch.fromJson(Map<String, dynamic> json) {
    mainBarcode = json['BarCode'];
    assistantBarcode = json['SubBarCode'];
    trayType = json['TrayType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BarCode'] = this.mainBarcode;
    data['SubBarCode'] = this.assistantBarcode;
    data['TrayType'] = this.trayType;
    return data;
  }

  // 校验
  bool validate() {
    return mainBarcode != null || assistantBarcode != null || trayType != null;
  }
}

class BarcodeInfo {
  String? barCode;
  String? subBarCode;
  String? trayType;

  BarcodeInfo({this.barCode, this.subBarCode, this.trayType});

  BarcodeInfo.fromJson(Map<String, dynamic> json) {
    barCode = json['BarCode'];
    subBarCode = json['SubBarCode'];
    trayType = json['TrayType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BarCode'] = this.barCode;
    data['SubBarCode'] = this.subBarCode;
    data['TrayType'] = this.trayType;
    return data;
  }
}
