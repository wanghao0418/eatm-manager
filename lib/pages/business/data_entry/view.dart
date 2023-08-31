/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-23 14:00:43
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-31 16:15:12
 * @FilePath: /eatm_manager/lib/pages/business/data_entry/view.dart
 * @Description: 数据录入视图层
 */
import 'package:eatm_manager/common/components/filled_icon_button.dart';
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/components/themed_text.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/utils/log.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:eatm_manager/common/widgets/pop_date_picker.dart';
import 'package:eatm_manager/pages/business/data_entry/widgets/order_detail.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:styled_widget/styled_widget.dart';

import 'index.dart';

class DataEntryPage extends StatefulWidget {
  const DataEntryPage({Key? key}) : super(key: key);

  @override
  State<DataEntryPage> createState() => _DataEntryPageState();
}

class _DataEntryPageState extends State<DataEntryPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _DataEntryViewGetX();
  }
}

class _DataEntryViewGetX extends GetView<DataEntryController> {
  const _DataEntryViewGetX({Key? key}) : super(key: key);
  GlobalTheme get globalTheme => GlobalTheme.instance;

  // 打开作业单详情弹窗
  void openDetailDialog(String mouldSN) {
    SmartDialog.show(
      tag: 'dataEntry_detail',
      keepSingle: true,
      builder: (context) {
        return SizedBox(
          height: 810,
          child: ContentDialog(
            constraints: BoxConstraints(maxWidth: 1420.r),
            title: const Text('作业单详情').fontSize(18),
            content: OrderDetail(
              mouldSN: mouldSN,
            ),
            actions: [
              Button(
                  child: const Text('取消'),
                  onPressed: () =>
                      SmartDialog.dismiss(tag: 'dataEntry_detail')),
              FilledButton(
                  child: const Text('确定'),
                  onPressed: () => SmartDialog.dismiss(tag: 'dataEntry_detail'))
            ],
          ),
        );
      },
    );
  }

  // 顶部搜索框
  Widget _buildSearchBar() {
    var formItems = Row(
      children: [
        Expanded(
            child: Wrap(
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            LineFormLabel(
              label: '显示状态',
              width: 250,
              isExpanded: true,
              child: ComboBox<int?>(
                placeholder: const Text('请选择'),
                value: controller.search.workmanship,
                items: controller.processRouteList
                    .map((e) => ComboBoxItem<int?>(
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
                  controller.search.workmanship = value;
                  controller.update(["data_entry"]);
                },
              ),
            ),
            LineFormLabel(
                label: '作业单号',
                width: 250,
                isRequired: true,
                isExpanded: true,
                child: TextBox(
                  placeholder: '作业单号',
                  controller: controller.mouldSNController,
                  onChanged: (value) {
                    controller.search.mouldSN = value;
                  },
                )),
            LineFormLabel(
                label: '芯片Id',
                width: 250,
                isExpanded: true,
                child: TextBox(
                  placeholder: '芯片Id',
                  controller: controller.barCodeController,
                  onChanged: (value) {
                    controller.search.barCode = value;
                  },
                )),
            LineFormLabel(
                label: '铸件号',
                width: 250,
                isExpanded: true,
                child: TextBox(
                  placeholder: '铸件号',
                  controller: controller.partSNController,
                  onChanged: (value) {
                    controller.search.partSN = value;
                  },
                )),
            LineFormLabel(
                label: '操作员',
                width: 250,
                isExpanded: true,
                child: AutoSuggestBox<String>(
                  controller: controller.employeeController,
                  placeholder: '操作员',
                  items: controller.employeeList
                      .map((e) => AutoSuggestBoxItem<String>(
                            label: e,
                            value: e,
                          ))
                      .toList(),
                  onChanged: (text, reason) {},
                )),
            LineFormLabel(
                label: '时间范围',
                width: 350.0,
                isExpanded: true,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 5,
                  children: [
                    PopDatePicker(
                      value: controller.search.startTime,
                      placeholder: '开始时间',
                      onChange: (value) {
                        print(value);
                        controller.search.startTime = value;
                      },
                    ),
                    const ThemedText(
                      '至',
                    ),
                    PopDatePicker(
                      value: controller.search.endTime,
                      placeholder: '结束时间',
                      onChange: (value) {
                        print(value);
                        controller.search.endTime = value;
                      },
                    ),
                  ],
                )),
          ],
        ))
      ],
    );
    var buttons = Row(
      children: [
        Expanded(
            child: Wrap(
                spacing: 10,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
              FilledIconButton(
                  icon: FluentIcons.search,
                  label: '查询',
                  onPressed: controller.query),
            ])),
        Expanded(
            child: Wrap(
                spacing: 10,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.end,
                children: [
              FilledButton(
                  onPressed: controller.importHomeworkSheet,
                  child: const Text('作业单导入')),
              FilledButton(
                onPressed: controller.delete,
                child: const Text('作业单删除'),
              ),
              FilledButton(
                onPressed: controller.bind,
                child: const Text('芯片绑定'),
              ),
            ])),
      ],
    );
    return Container(
      decoration: globalTheme.contentDecoration,
      width: double.infinity,
      padding: globalTheme.contentPadding,
      child: Column(children: [formItems, 10.verticalSpace, buttons]),
    );
  }

  // 数据表格
  Widget _buildTable() {
    return Container(
      decoration: globalTheme.contentDecoration,
      child: PlutoGrid(
        columns: [
          PlutoColumn(
              title: '序号',
              field: 'number',
              type: PlutoColumnType.text(),
              readOnly: true,
              width: 100,
              frozen: PlutoColumnFrozen.start,
              enableRowChecked: true),
          PlutoColumn(
            title: '作业单号',
            field: 'mouldSn',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '产品编码',
            field: 'productCode',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '产品批号',
            field: 'productBatch',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '产品名称',
            field: 'mwPieceName',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '规格型号',
            field: 'spec',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '设备号',
            field: 'machineSn',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '工单总数量',
            field: 'mwCount',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '已绑定数量',
            field: 'boundCount',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '铸件号',
            field: 'partSn',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '抽检频率',
            field: 'samplingFrequency',
            type: PlutoColumnType.number(),
            renderer: (rendererContext) {
              return Center(
                child: Container(
                    width: 150,
                    child: Focus(
                      onFocusChange: (value) {
                        // 失去焦点触发
                        if (!value) {
                          controller.updateField(rendererContext.rowIdx,
                              rendererContext.cell.value.toString());
                        }
                      },
                      child: NumberBox<int>(
                        value: rendererContext.cell.value,
                        // mode: SpinButtonPlacementMode.none,
                        onChanged: (value) {
                          rendererContext.cell.value = value;
                        },
                      ),
                    )),
              );
            },
          ),
          PlutoColumn(
            title: '操作员',
            field: 'username',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
              title: '编号',
              field: 'sn',
              type: PlutoColumnType.text(),
              readOnly: true,
              hide: true),
          PlutoColumn(
              title: '芯片Id',
              field: 'barCode',
              type: PlutoColumnType.text(),
              readOnly: true,
              hide: true),
          PlutoColumn(
              title: '类型',
              field: 'workpieceType',
              type: PlutoColumnType.text(),
              readOnly: true,
              hide: true),
          PlutoColumn(
              title: '工艺路线',
              field: 'processRoute',
              type: PlutoColumnType.text(),
              readOnly: true,
              hide: true),
          PlutoColumn(
              title: '当前工艺顺序',
              field: 'curProcOrder',
              type: PlutoColumnType.text(),
              readOnly: true,
              hide: true),
          PlutoColumn(
              title: '操作时间',
              field: 'recordTime',
              type: PlutoColumnType.time(),
              readOnly: true,
              hide: true),
        ],
        rows: controller.rows,
        onLoaded: (event) {
          controller.stateManager = event.stateManager;
          controller.query();
        },
        onChanged: (event) {
          if (event.column.field == 'samplingFrequency') {
            controller.updateField(event.rowIdx, event.value.toString());
          }
        },
        onRowSecondaryTap: (event) {
          openDetailDialog(event.row.cells['mouldSn']!.value);
        },
        configuration: globalTheme.plutoGridConfig,
      ),
    );
  }

  // 主视图
  Widget _buildView() {
    return Container(
      padding: globalTheme.pagePadding,
      child: Column(
        children: [
          _buildSearchBar(),
          globalTheme.contentDistance.verticalSpace,
          Expanded(child: _buildTable())
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataEntryController>(
      init: DataEntryController(),
      id: "data_entry",
      builder: (_) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(),
        );
      },
    );
  }
}
