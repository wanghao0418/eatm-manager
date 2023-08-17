/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-16 15:08:21
 * @LastEditors: wanghao wanghao@oureman.com
<<<<<<< HEAD
 * @LastEditTime: 2023-08-17 09:55:39
=======
 * @LastEditTime: 2023-08-17 17:59:11
>>>>>>> 67f6cfe (feat：新增线体公共接口，优化报工逻辑)
 * @FilePath: /eatm_manager/lib/pages/business/reporting/view.dart
 * @Description: 报工视图层
 */
import 'package:eatm_manager/common/components/filled_icon_button.dart';
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/components/themed_text.dart';
import 'package:eatm_manager/common/components/title_card.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'index.dart';

class ReportingPage extends StatefulWidget {
  const ReportingPage({Key? key}) : super(key: key);

  @override
  State<ReportingPage> createState() => _ReportingPageState();
}

class _ReportingPageState extends State<ReportingPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _ReportingViewGetX();
  }
}

class _ReportingViewGetX extends GetView<ReportingController> {
  const _ReportingViewGetX({Key? key}) : super(key: key);
  GlobalTheme get globalTheme => GlobalTheme.instance;

  // 顶部搜索栏
  Widget _buildSearchBar() {
    var formLine = Row(
      children: [
        Expanded(
            child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            LineFormLabel(
              label: '工件类型',
              width: 200,
              isExpanded: true,
              child: ComboBox<int?>(
                placeholder: const Text('请选择'),
                value: controller.search.workpieceType,
                items: controller.workpieceTypeList
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
                  controller.search.workpieceType = value;
                  controller.update(["reporting"]);
                },
              ),
            ),
            LineFormLabel(
              label: '机床编号',
              width: 200,
              isExpanded: true,
              child: ComboBox<int?>(
                placeholder: const Text('请选择'),
                value: controller.search.workpieceType,
                items: controller.workpieceTypeList
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
                  controller.search.workpieceType = value;
                  controller.update(["reporting"]);
                },
              ),
            ),
            LineFormLabel(
              label: '监控编号',
              width: 200,
              isExpanded: true,
              child: TextBox(
                placeholder: '请输入监控编号',
                onChanged: (value) {
                  controller.search.mwpiececode = value;
                },
              ),
            ),
            LineFormLabel(
              label: '模号',
              width: 200,
              isExpanded: true,
              child: TextBox(
                placeholder: '请输入模号',
                onChanged: (value) {
                  controller.search.mouldsn = value;
                },
              ),
            ),
            LineFormLabel(
              label: '件号',
              width: 200,
              isExpanded: true,
              child: TextBox(
                placeholder: '请输入模号',
                onChanged: (value) {
                  controller.search.partsn = value;
                },
              ),
            ),
            LineFormLabel(
              label: '芯片Id',
              width: 200,
              isExpanded: true,
              child: TextBox(
                placeholder: '请输入芯片Id',
                onChanged: (value) {
                  controller.search.barcode = value;
                },
              ),
            ),
          ],
        )),
        10.horizontalSpace,
        Expanded(
            child: Wrap(
          alignment: WrapAlignment.end,
          spacing: 10,
          runSpacing: 10,
          children: [
            LineFormLabel(
              label: '报工类型',
              width: 200,
              isExpanded: true,
              isRequired: true,
              child: ComboBox<int?>(
                value: controller.reporting.reportType,
                placeholder: const Text('请选择'),
                items: controller.reportingTypeList
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
                  controller.reporting.reportType = value;
                  controller.update(["reporting"]);
                },
              ),
            ),
            LineFormLabel(
              label: '人员名称',
              width: 200,
              isExpanded: true,
              isRequired: true,
              child: ComboBox<String?>(
                value: controller.reporting.person,
                placeholder: const Text('请选择'),
                items: controller.personList
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
                  controller.reporting.person = value;
                  controller.update(["reporting"]);
                },
              ),
            ),
            LineFormLabel(
              label: '机床编号',
              width: 250,
              isExpanded: true,
              isRequired: true,
              child: ComboBox<String?>(
                value: controller.reporting.machineSn,
                placeholder: const Text('请选择'),
                items: controller.machineList
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
                  controller.reporting.machineSn = value;
                  controller.update(["reporting"]);
                },
              ),
            ),
          ],
        ))
      ],
    );
    var buttonLine = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FilledIconButton(
            label: '查询', icon: FluentIcons.search, onPressed: controller.query),
        FilledIconButton(
            label: '报工',
            icon: FluentIcons.report_alert_mirrored,
            onPressed: controller.report),
      ],
    );

    return Container(
      decoration: globalTheme.contentDecoration,
      padding: globalTheme.contentPadding,
      child: Column(
        children: [
          formLine,
          10.verticalSpace,
          buttonLine,
        ],
      ),
    );
  }

  // 模号列表
  Widget _buildMouldSNList() {
    return Container(
      width: 200.w,
      // padding: globalTheme.contentPadding,
      decoration: globalTheme.contentDecoration,
      child: TitleCard(
          title: '模号',
          cardBackgroundColor: globalTheme.pageContentBackgroundColor,
          containChild: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: controller.mouldSNList.length,
              itemBuilder: (context, index) {
                return ListTile.selectable(
                  key: ValueKey(controller.mouldSNList[index]),
                  selectionMode: ListTileSelectionMode.multiple,
                  selected: controller.selectedMouldSNList
                      .contains(controller.mouldSNList[index]),
                  title: Text(controller.mouldSNList[index]),
                  onPressed: () {
                    if (controller.selectedMouldSNList
                        .contains(controller.mouldSNList[index])) {
                      controller.selectedMouldSNList
                          .remove(controller.mouldSNList[index]);
                    } else {
                      controller.selectedMouldSNList
                          .add(controller.mouldSNList[index]);
                    }
                    // 更新表格筛选条件
                    if (controller.selectedMouldSNList.isEmpty) {
                      controller.stateManager.setFilter(null);
                    } else {
                      controller.stateManager.setFilter((element) =>
                          controller.selectedMouldSNList.contains(
                              element.cells['mouldSN']!.value.toString()));
                    }
                    controller.update(["craft_binding"]);
                  },
                );
              })),
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
              type: PlutoColumnType.text(),
              readOnly: true,
              enableRowChecked: true,
              width: 150),
          PlutoColumn(
            title: '监控编号',
            field: 'mwpieceCode',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '模号',
            field: 'mouldSN',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '件号',
            field: 'partSN',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          // PlutoColumn(
          //   title: '芯片Id',
          //   field: 'barCode',
          //   type: PlutoColumnType.text(),
          //   readOnly: true,
          // ),

          PlutoColumn(
            title: '工件名称',
            field: 'mwpieceName',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          // PlutoColumn(
          //   title: '装夹方式',
          //   field: 'clampType',
          //   type: PlutoColumnType.text(),
          //   readOnly: true,
          // ),
          // PlutoColumn(
          //   title: '托盘类型',
          //   field: 'trayType',
          //   type: PlutoColumnType.text(),
          //   readOnly: true,
          // ),
          // PlutoColumn(
          //   title: '部门',
          //   field: 'resoucenamedept',
          //   type: PlutoColumnType.text(),
          //   readOnly: true,
          // ),
          PlutoColumn(
            title: '类型',
            field: 'workpieceType',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '尺寸',
            field: 'spec',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '',
            field: 'data',
            type: PlutoColumnType.text(),
            readOnly: true,
            hide: true,
          ),
        ],
        rows: controller.rows,
        onLoaded: (PlutoGridOnLoadedEvent event) {
          controller.stateManager = event.stateManager;
          controller.query();
        },
        configuration: globalTheme.plutoGridConfig.copyWith(
            columnSize: const PlutoGridColumnSizeConfig(
                autoSizeMode: PlutoAutoSizeMode.scale)),
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
          Expanded(
              child: Row(
            children: [
              _buildMouldSNList(),
              globalTheme.contentDistance.horizontalSpace,
              Expanded(child: _buildTable()),
            ],
          ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportingController>(
      init: ReportingController(),
      id: "reporting",
      builder: (_) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(),
        );
      },
    );
  }
}
