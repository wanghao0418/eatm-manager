/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-09 15:34:58
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-15 14:38:28
 * @FilePath: /eatm_manager/lib/pages/business/machine_binding/view.dart
 * @Description: 机床绑定视图层
 */
import 'package:eatm_manager/common/components/filled_icon_button.dart';
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/components/themed_text.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/widgets/pop_date_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'index.dart';

class MachineBindingPage extends StatefulWidget {
  const MachineBindingPage({Key? key}) : super(key: key);

  @override
  State<MachineBindingPage> createState() => _MachineBindingPageState();
}

class _MachineBindingPageState extends State<MachineBindingPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _MachineBindingViewGetX();
  }
}

class _MachineBindingViewGetX extends GetView<MachineBindingController> {
  const _MachineBindingViewGetX({Key? key}) : super(key: key);
  GlobalTheme get globalTheme => Get.find<GlobalTheme>();

  // 搜索框
  Widget _buildSearchBar(BuildContext context) {
    var form = Row(
      children: [
        Expanded(
            child: Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.start,
          children: [
            LineFormLabel(
                label: '工件类型',
                width: 200,
                isExpanded: true,
                child: ComboBox<int?>(
                  placeholder: const Text('请选择'),
                  value: controller.search.workpiecetype,
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
                    controller.search.workpiecetype = value;
                    controller.update(["machine_binding"]);
                  },
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
                    Text(
                      '至',
                      style: FluentTheme.of(Get.context!).typography.body,
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
        )),
        10.horizontalSpace,
        Expanded(
            child: Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.end,
                children: [
              LineFormLabel(
                  label: '机床类型',
                  width: 200,
                  isRequired: true,
                  isExpanded: true,
                  child: ComboBox<String?>(
                    placeholder: const Text('请选择'),
                    value: controller.currentMachineType,
                    items: controller.machineTypeList
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
                      controller.currentMachineType = value;
                      // 更新机台编号
                      controller.currentMachineName = controller
                                  .machineMap[controller.currentMachineType] ==
                              null
                          ? null
                          : controller
                              .machineMap[controller.currentMachineType]!
                              .first['MacName'];
                      controller.update(["machine_binding"]);
                    },
                  )),
              LineFormLabel(
                  label: '机台编号',
                  width: 200,
                  isRequired: true,
                  isExpanded: true,
                  child: ComboBox<String?>(
                    placeholder: const Text('请选择'),
                    value: controller.currentMachineName,
                    items: controller.machineNameList
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
                      controller.currentMachineName = value;
                      controller.update(["machine_binding"]);
                    },
                  )),
            ]))
      ],
    );
    var buttonBar = Row(
      children: [
        Expanded(
            child: Wrap(
          spacing: 10,
          children: [
            FilledIconButton(
                label: '搜索',
                onPressed: controller.query,
                icon: FluentIcons.search),
          ],
        )),
        10.horizontalSpace,
        Expanded(
            child: Wrap(
          alignment: WrapAlignment.end,
          spacing: 10,
          children: [
            FilledIconButton(
                label: '绑定',
                onPressed: controller.binding,
                icon: FluentIcons.link),
          ],
        )),
      ],
    );

    return Container(
      padding: globalTheme.contentPadding,
      decoration: globalTheme.contentDecoration,
      width: double.infinity,
      child: Column(children: [
        form,
        10.verticalSpace,
        buttonBar,
      ]),
    );
  }

  // 模号列表
  Widget _buildMouldSNList(BuildContext context) {
    return Container(
      width: 200.w,
      padding: globalTheme.contentPadding,
      decoration: globalTheme.contentDecoration,
      child: Column(
        children: [
          const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: ThemedText(
                '模号',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )),
          const Divider(),
          Expanded(
              child: ListView.builder(
                  itemCount: controller.mouldSNList.length,
                  itemBuilder: (context, index) {
                    return ListTile.selectable(
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
                        controller.update(["machine_binding"]);
                      },
                    );
                  }))
        ],
      ),
    );
  }

  // 表格
  Widget _buildTable(BuildContext context) {
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
          PlutoColumn(
            title: '芯片Id',
            field: 'barCode',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '机床编号',
            field: 'machineSN',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '工件名称',
            field: 'mwpieceName',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '部门',
            field: 'resoucenamedept',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '类型',
            field: 'workpieceType',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '规格',
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
            columnSize: PlutoGridColumnSizeConfig(
                autoSizeMode: PlutoAutoSizeMode.scale)),
      ),
    );
  }

  // 主视图
  Widget _buildView(BuildContext context) {
    return Container(
      padding: globalTheme.pagePadding,
      child: Column(
        children: [
          _buildSearchBar(context),
          globalTheme.contentDistance.verticalSpace,
          Expanded(
              child: Row(
            children: [
              _buildMouldSNList(context),
              globalTheme.contentDistance.horizontalSpace,
              Expanded(child: _buildTable(context))
            ],
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MachineBindingController>(
      init: MachineBindingController(),
      id: "machine_binding",
      builder: (_) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(context),
        );
      },
    );
  }
}
