/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-12 09:20:16
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-13 17:14:17
 * @FilePath: /eatm_manager/lib/pages/business/automated_handling/view.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:eatm_manager/common/components/filled_icon_button.dart';
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/widgets/pop_date_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'index.dart';

class AutomatedHandlingPage extends StatefulWidget {
  const AutomatedHandlingPage({Key? key}) : super(key: key);

  @override
  State<AutomatedHandlingPage> createState() => _AutomatedHandlingPageState();
}

class _AutomatedHandlingPageState extends State<AutomatedHandlingPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _AutomatedHandlingViewGetX();
  }
}

class _AutomatedHandlingViewGetX extends GetView<AutomatedHandlingController> {
  const _AutomatedHandlingViewGetX({Key? key}) : super(key: key);
  GlobalTheme get globalTheme => GlobalTheme.instance;

  // 顶部操作栏
  Widget _buildActionBar() {
    var formRow = Row(
      children: [
        Expanded(
            child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            LineFormLabel(
                label: '任务类型',
                width: 200,
                isExpanded: true,
                isRequired: true,
                child: ComboBox<int?>(
                  placeholder: const Text('任务类型'),
                  value: controller.search.taskType,
                  items: controller.taskTypeList
                      .map((e) => ComboBoxItem<int?>(
                            value: e.value,
                            child: Text(e.label.toString()),
                          ))
                      .toList(),
                  onChanged: (value) {
                    controller.search.clear();
                    controller.search.taskType = value;
                    // NOTE: 单元入库,  工件状态  只有 无
                    // 注塑, 工件类型 只有 注塑,  工件状态 只有 无
                    if ([2, 3].contains(value)) {
                      controller.search.workPieceType = 99;
                      controller.search.workPieceState = 99;
                    }
                    if (controller.search.taskType == 0) {
                      controller.search.workPieceState = 99;
                    }
                    controller.update(['automated_handling']);
                  },
                )),
            LineFormLabel(
                label: '工件类型',
                width: 200,
                isExpanded: true,
                isRequired: ![2, 3].contains(controller.search.taskType),
                child: ComboBox(
                  placeholder: const Text('工件类型'),
                  value: controller.search.workPieceType,
                  items: controller.pieceTypeList
                      .map((e) => ComboBoxItem<int?>(
                            value: e.value,
                            child: Text(e.toString()),
                          ))
                      .toList(),
                  onChanged: (value) {
                    controller.search.workPieceType = value;
                    controller.update(['automated_handling']);
                  },
                )),
            LineFormLabel(
                label: '工件状态',
                width: 200,
                isExpanded: true,
                isRequired: ![2, 3].contains(controller.search.taskType),
                child: ComboBox(
                  placeholder: const Text('工件状态'),
                  value: controller.search.workPieceState,
                  items: controller.pieceStatusList
                      .map((e) => ComboBoxItem<int?>(
                            value: e.value,
                            child: Text(e.toString()),
                          ))
                      .toList(),
                  onChanged: (value) {
                    controller.search.workPieceState = value;
                    controller.update(['automated_handling']);
                  },
                )),
            LineFormLabel(
                label: '时间范围',
                width: 350.0,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 5,
                  children: [
                    PopDatePicker(
                      value: controller.search.startTime,
                      placeholder: '开始时间',
                      onChange: (value) {
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
                        controller.search.endTime = value;
                      },
                    ),
                  ],
                )),
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
            FilledIconButton(
                icon: FluentIcons.search,
                label: '查询',
                onPressed: controller.query),
            FilledIconButton(
                icon: FluentIcons.device_run,
                label: '执行',
                onPressed: controller.run),
            FilledIconButton(
                icon: FluentIcons.reset,
                label: '重置',
                onPressed: controller.resetForm),
          ],
        ))
      ],
    );

    return Container(
      decoration: globalTheme.contentDecoration,
      padding: globalTheme.contentPadding,
      child: Column(children: [formRow, 10.verticalSpace, buttonRow]),
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
              field: 'index',
              type: PlutoColumnType.text(),
              enableRowChecked: true,
              readOnly: true),
          PlutoColumn(
              title: '任务类型',
              field: 'taskType',
              type: PlutoColumnType.text(),
              readOnly: true),
          PlutoColumn(
              title: '工件类型',
              field: 'workpieceType',
              type: PlutoColumnType.text(),
              readOnly: true),
          PlutoColumn(
              title: '完成时间',
              field: 'recordTime',
              type: PlutoColumnType.text(),
              readOnly: true),
        ],
        rows: controller.rows,
        onLoaded: (event) {
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
      child: Column(children: [
        _buildActionBar(),
        globalTheme.contentDistance.verticalSpace,
        Expanded(child: _buildTable())
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AutomatedHandlingController>(
      init: AutomatedHandlingController(),
      id: "automated_handling",
      builder: (_) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(),
        );
      },
    );
  }
}
