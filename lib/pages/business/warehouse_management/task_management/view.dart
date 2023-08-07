/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-27 16:09:22
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-07 18:02:20
 * @FilePath: /eatm_manager/lib/pages/business/warehouse_management/task_management/view.dart
 * @Description: 任务管理视图层
 */
import 'package:eatm_manager/common/components/filled_icon_button.dart';
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:eatm_manager/common/widgets/pop_date_picker.dart';
import 'package:eatm_manager/pages/business/warehouse_management/task_management/enum.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'index.dart';

class TaskManagementPage extends StatefulWidget {
  const TaskManagementPage({Key? key}) : super(key: key);

  @override
  State<TaskManagementPage> createState() => _TaskManagementPageState();
}

class _TaskManagementPageState extends State<TaskManagementPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _TaskManagementViewGetX();
  }
}

class _TaskManagementViewGetX extends GetView<TaskManagementController> {
  const _TaskManagementViewGetX({Key? key}) : super(key: key);
  GlobalTheme get globalTheme => GlobalTheme.instance;

  // 顶部搜索栏
  Widget _buildSearchBar(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: globalTheme.contentDecoration,
      padding: globalTheme.pagePadding,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  LineFormLabel(
                      label: '时间范围',
                      width: 400.0,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 5,
                        children: [
                          SizedBox(
                              width: 150.0,
                              child: PopDatePicker(
                                value: controller.search.startTime,
                                placeholder: '开始时间',
                                onChange: (value) {
                                  print(value);
                                  controller.search.startTime = value;
                                },
                              )),
                          Text(
                            '至',
                            style: FluentTheme.of(Get.context!).typography.body,
                          ),
                          SizedBox(
                            width: 150.0,
                            child: PopDatePicker(
                              value: controller.search.endTime,
                              placeholder: '结束时间',
                              onChange: (value) {
                                print(value);
                                controller.search.endTime = value;
                              },
                            ),
                          ),
                        ],
                      )),
                  LineFormLabel(
                      label: '执行状态',
                      width: 220.0,
                      isExpanded: true,
                      child: ComboBox<int?>(
                        placeholder: Text('请选择'),
                        value: controller.search.executionStatus,
                        items: ExecutionStatus.toSelectOptionList()
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
                        onChanged: (val) {
                          controller.search.executionStatus = val;
                          controller.update(['task_management']);
                        },
                      )),
                ],
              ),
            ),
            10.horizontalSpace,
            Expanded(
                child: Wrap(
              alignment: WrapAlignment.end,
              spacing: 10,
              runSpacing: 10,
              children: [
                LineFormLabel(
                  label: '工件类型',
                  width: 230.0,
                  isRequired: true,
                  isExpanded: true,
                  child: ComboBox<int?>(
                    placeholder: const Text('请选择'),
                    value: controller.artifactType,
                    items: controller.artifactTypeList
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
                    onChanged: (val) {
                      controller.artifactType = val;
                      controller.update(['task_management']);
                    },
                  ),
                ),
                LineFormLabel(
                  label: '工件状态',
                  width: 230.0,
                  isRequired: true,
                  isExpanded: true,
                  child: ComboBox<int?>(
                    placeholder: const Text('请选择'),
                    value: controller.workpieceStatus,
                    items: controller.workpieceStatusList
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
                    onChanged: (val) {
                      controller.workpieceStatus = val;
                      controller.update(['task_management']);
                    },
                  ),
                ),
              ],
            ))
          ],
        ),
        10.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledIconButton(
                    icon: FluentIcons.search,
                    label: '搜索',
                    onPressed: controller.query),
                FilledIconButton(
                    label: '取消任务',
                    icon: FluentIcons.cancel,
                    onPressed: controller.cancelTask),
              ],
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton(
                    onPressed: controller.trayIn, child: const Text('托盘入库')),
                FilledButton(
                    onPressed: controller.workpieceIn,
                    child: const Text('工件入库')),
                FilledIconButton(
                  onPressed: controller.out,
                  label: '出库',
                  icon: FluentIcons.open_pane_mirrored,
                ),
                // FilledButton(
                //     onPressed: controller.workpieceOut,
                //     child: const Text('货位出库')),
              ],
            ),
          ],
        ),
      ]),
    );
  }

  Widget _buildTable(BuildContext context) {
    return Container(
      decoration: globalTheme.contentDecoration,
      child: PlutoGrid(
          columns: [
            PlutoColumn(
                title: '序号',
                field: 'number',
                readOnly: true,
                width: 80,
                type: PlutoColumnType.text()),
            PlutoColumn(
                title: '任务编号',
                field: 'taskCode',
                readOnly: true,
                type: PlutoColumnType.text()),
            PlutoColumn(
                title: '货位号',
                field: 'storageNum',
                readOnly: true,
                type: PlutoColumnType.text()),
            PlutoColumn(
              title: '勾选',
              field: 'checked',
              width: 85,
              readOnly: true,
              type: PlutoColumnType.text(),
              enableEditingMode: false,
              frozen: PlutoColumnFrozen.start,
              renderer: (rendererContext) {
                return Center(
                  child: SizedBox(
                    width: 20.0,
                    height: 20,
                    child: Checkbox(
                        checked: rendererContext.cell.value,
                        onChanged: (val) {
                          if (rendererContext
                                  .row.cells['executionStatus']!.value ==
                              ExecutionStatus.executing.value) {
                            PopupMessage.showWarningInfoBar('当前任务正在进行');
                            return;
                          }
                          // for (var element in controller.stateManager.rows) {
                          //   element.cells['checked']!.value = false;
                          // }
                          // controller.stateManager.toggleAllRowChecked(false);
                          rendererContext.cell.value = val;
                          controller.stateManager.setRowChecked(
                              rendererContext.row, val!,
                              notify: true);
                          controller.update(['task_management']);
                        }),
                  ),
                );
              },
              footerRenderer: (renderContext) {
                return controller.tableLoaded
                    ? Center(
                        child: Wrap(
                          children: [
                            Text(
                              '全选',
                              style: FluentTheme.of(context).typography.body,
                            ),
                            10.horizontalSpaceRadius,
                            Checkbox(
                                checked: controller.isAllChecked(),
                                onChanged: (val) {
                                  if (val!) {
                                    var needCheckRows = controller
                                        .stateManager.rows
                                        .where((element) =>
                                            !controller.isDisabled(element
                                                .cells['executionStatus']!));
                                    for (var element in needCheckRows) {
                                      element.cells['checked']!.value = val;
                                      controller.stateManager
                                          .setRowChecked(element, val);
                                    }
                                    controller.update(['task_management']);
                                  } else {
                                    controller.stateManager
                                        .toggleAllRowChecked(val);
                                    for (var element in controller.rows) {
                                      element.cells['checked']!.value = val;
                                    }
                                    controller.update(['task_management']);
                                  }
                                })
                          ],
                        ),
                      )
                    : Container();
              },
            ),
            PlutoColumn(
              title: '执行状态',
              field: 'executionStatus',
              readOnly: true,
              type: PlutoColumnType.text(),
              enableEditingMode: false,
              renderer: (rendererContext) {
                final val = rendererContext.cell.value;
                return Text(
                  ExecutionStatus.fromValue(val)!.label,
                  style: FluentTheme.of(Get.context!).typography.body,
                );
              },
            ),
            // PlutoColumn(
            //     title: '任务类型',
            //     field: 'shelfColumn',
            //     type: PlutoColumnType.text()),
            // PlutoColumn(
            //     title: '托盘SN', field: 'shelfRow', type: PlutoColumnType.text()),
            PlutoColumn(
                title: '工件SN',
                field: 'workpieceSN',
                readOnly: true,
                type: PlutoColumnType.text()),
            PlutoColumn(
              title: '操作类型',
              field: 'operationType',
              readOnly: true,
              enableEditingMode: false,
              type: PlutoColumnType.text(),
              renderer: (rendererContext) {
                final val = rendererContext.cell.value;
                return Text(
                  OperationType.fromValue(val)!.label,
                  style: FluentTheme.of(context).typography.body,
                );
              },
            ),
            PlutoColumn(
                title: '开始时间',
                field: 'startTime',
                readOnly: true,
                type: PlutoColumnType.text()),
            PlutoColumn(
              title: '完成时间',
              field: 'endTime',
              type: PlutoColumnType.text(),
              readOnly: true,
            ),
            PlutoColumn(
                title: '托盘类型',
                field: 'trayType',
                readOnly: true,
                type: PlutoColumnType.text()),
          ],
          rows: controller.rows,
          onLoaded: (event) {
            controller.stateManager = event.stateManager;
            controller.tableLoaded = true;
            controller.query();
            controller.initTimer();
          },
          configuration: globalTheme.plutoGridConfig.copyWith(
            columnSize: const PlutoGridColumnSizeConfig(
                autoSizeMode: PlutoAutoSizeMode.scale),
          )),
    );
  }

  // 主视图
  Widget _buildView(context) {
    return Container(
      padding: globalTheme.pagePadding,
      child: Column(
        children: [
          _buildSearchBar(context),
          globalTheme.contentDistance.verticalSpace,
          Expanded(child: _buildTable(context)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskManagementController>(
      init: TaskManagementController(),
      id: "task_management",
      builder: (_) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(context),
        );
      },
    );
  }
}
