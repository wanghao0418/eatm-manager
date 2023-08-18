/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-08 10:21:35
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-18 11:15:26
 * @FilePath: /eatm_manager/lib/pages/business/task_query/view.dart
 * @Description: 任务查询视图层
 */
import 'package:eatm_manager/common/components/filled_icon_button.dart';
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/components/themed_text.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'index.dart';

class TaskQueryPage extends StatefulWidget {
  const TaskQueryPage({Key? key}) : super(key: key);

  @override
  State<TaskQueryPage> createState() => _TaskQueryPageState();
}

class _TaskQueryPageState extends State<TaskQueryPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _TaskQueryViewGetX();
  }
}

class _TaskQueryViewGetX extends GetView<TaskQueryController> {
  const _TaskQueryViewGetX({Key? key}) : super(key: key);
  GlobalTheme get globalTheme => Get.find<GlobalTheme>();

  // 搜索栏
  Widget _buildSearchBar(BuildContext context) {
    // 表单项
    var form = Row(
      children: [
        Expanded(
            child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            LineFormLabel(
                label: '芯片Id',
                width: 200,
                isExpanded: true,
                child: TextBox(
                  placeholder: '请输入芯片Id',
                  onChanged: (value) {
                    controller.search.barcodeId = value;
                  },
                )),
            LineFormLabel(
                label: '出入库状态',
                width: 200,
                isExpanded: true,
                child: ComboBox<int?>(
                  placeholder: const Text('请选择'),
                  value: controller.search.agvDispatchState,
                  items: controller.agvDispatchStateOptionList
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
                    controller.search.agvDispatchState = value;
                    controller.update(['task_query']);
                  },
                ))
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
                  label: '入库状态',
                  width: 250,
                  isExpanded: true,
                  isRequired: true,
                  child: ComboBox<int?>(
                    placeholder: Text('请选择'),
                    value: controller.currentStorageStatus,
                    items: controller.storageStatusOptionList
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
                      controller.currentStorageStatus = value;
                      controller.update(['task_query']);
                    },
                  )),
              LineFormLabel(
                  label: '出库状态',
                  width: 250,
                  isExpanded: true,
                  isRequired: true,
                  child: ComboBox<int?>(
                    placeholder: Text('请选择'),
                    value: controller.currentOutboundStatus,
                    items: controller.outboundStatusOptionList
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
                      controller.currentOutboundStatus = value;
                      controller.update(['task_query']);
                    },
                  ))
            ]))
      ],
    );

    // 按钮组
    var buttonGroup = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            FilledIconButton(
              onPressed: controller.query,
              label: '查询',
              icon: FluentIcons.search,
            ),
            FilledButton(
                child: const Text('入库开门'),
                onPressed: () {
                  controller.operatingDoor('In', 1);
                }),
            FilledButton(
                child: const Text('入库关门'),
                onPressed: () {
                  controller.operatingDoor('In', 0);
                }),
            FilledButton(
                child: const Text('出库开门'),
                onPressed: () {
                  controller.operatingDoor('Out', 1);
                }),
            FilledButton(
                child: const Text('出库关门'),
                onPressed: () {
                  controller.operatingDoor('Out', 0);
                })
          ],
        ),
        10.horizontalSpace,
        Wrap(spacing: 10, runSpacing: 10, children: [
          FilledIconButton(
            onPressed: () {
              if (!controller.stateManager.hasCheckedRow) {
                PopupMessage.showWarningInfoBar('请选择需要修改状态的任务');
                return;
              }
              if (controller.currentStorageStatus == null) {
                PopupMessage.showWarningInfoBar('请选择入库状态');
                return;
              }
              controller.updateProductTaskState(1);
            },
            label: '修改入库状态',
            icon: FluentIcons.change_entitlements,
          ),
          FilledIconButton(
            onPressed: () {
              if (!controller.stateManager.hasCheckedRow) {
                PopupMessage.showWarningInfoBar('请选择需要修改状态的任务');
                return;
              }
              if (controller.currentOutboundStatus == null) {
                PopupMessage.showWarningInfoBar('请选择出库状态');
                return;
              }
              controller.updateProductTaskState(2);
            },
            label: '修改出库状态',
            icon: FluentIcons.change_entitlements,
          ),
        ])
      ],
    );

    return Container(
      padding: globalTheme.contentPadding,
      decoration: globalTheme.contentDecoration,
      width: double.infinity,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [form, 10.verticalSpace, buttonGroup]),
    );
  }

  // 表格
  Widget _buildTable(BuildContext context) {
    return Container(
      // padding: globalTheme.contentPadding,
      decoration: globalTheme.contentDecoration,
      child: PlutoGrid(
        columns: [
          PlutoColumn(
            title: '勾选',
            field: 'checked',
            type: PlutoColumnType.text(),
            readOnly: true,
            enableEditingMode: false,
            frozen: PlutoColumnFrozen.start,
            width: 85,
            renderer: (rendererContext) {
              return Center(
                child: SizedBox(
                  width: 20.0,
                  height: 20,
                  child: Checkbox(
                      checked: rendererContext.cell.value,
                      onChanged: (val) {
                        // 如果当前已有选择任务，则只能选择同一芯片Id的任务
                        if (controller.stateManager.hasCheckedRow &&
                            rendererContext.row.cells['BarcodeId']!.value !=
                                controller.stateManager.checkedRows.first
                                    .cells['BarcodeId']!.value) {
                          PopupMessage.showWarningInfoBar('多钢件不支持不同芯片的任务');
                          return;
                        }
                        rendererContext.cell.value = val;
                        controller.stateManager.setRowChecked(
                            rendererContext.row, val!,
                            notify: true);
                        controller.update(['task_management']);
                      }),
                ),
              );
            },
            // footerRenderer: (renderContext) {
            //   return controller.tableLoaded
            //       ? Center(
            //           child: Wrap(
            //             children: [
            //               Text(
            //                 '全选',
            //                 style: FluentTheme.of(context).typography.body,
            //               ),
            //               10.horizontalSpaceRadius,
            //               Checkbox(
            //                   checked: controller.isAllChecked(),
            //                   onChanged: (val) {
            //                     if (val!) {
            //                       var needCheckRows = controller
            //                           .stateManager.rows
            //                           .where((element) =>
            //                               !controller.isDisabled(element
            //                                   .cells['executionStatus']!));
            //                       for (var element in needCheckRows) {
            //                         element.cells['checked']!.value = val;
            //                         controller.stateManager
            //                             .setRowChecked(element, val);
            //                       }
            //                       controller.update(['task_management']);
            //                     } else {
            //                       controller.stateManager
            //                           .toggleAllRowChecked(val);
            //                       for (var element in controller.rows) {
            //                         element.cells['checked']!.value = val;
            //                       }
            //                       controller.update(['task_management']);
            //                     }
            //                   })
            //             ],
            //           ),
            //         )
            //       : Container();
            // },
          ),
          PlutoColumn(
              title: '序号',
              field: 'number',
              type: PlutoColumnType.text(),
              readOnly: true,
              enableEditingMode: false,
              width: 100),
          PlutoColumn(
            title: '设备名称',
            field: 'DeviceName',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '托盘芯片Id',
            field: 'BarcodeId',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '模件号',
            field: 'MouldSN',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '工件监控Id',
            field: 'Mwpiececode',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '工步Id',
            field: 'Pstepid',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '物理尺寸',
            field: 'WorkPieceNorms',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '程序',
            field: 'programstate',
            type: PlutoColumnType.text(),
            readOnly: true,
            width: 100,
            renderer: (rendererContext) {
              return Text(rendererContext.cell.value,
                  style: FluentTheme.of(context).typography.body!.copyWith(
                        color: rendererContext.cell.value == '程序已上传'
                            ? Color(0xff47C93A)
                            : Color(0xffFF4857),
                      ));
            },
          ),
          PlutoColumn(
            title: '计划开始时间',
            field: 'Planstartdate',
            type: PlutoColumnType.time(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '计划结束时间',
            field: 'Planenddate',
            type: PlutoColumnType.time(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '理论加工时间',
            field: 'TheoreticalProductTime',
            type: PlutoColumnType.number(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '最晚完成时间',
            field: 'maxfinisheddate',
            type: PlutoColumnType.time(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '是否派工机床',
            hide: true,
            field: 'Productivelaborflag',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '出入库状态',
            field: 'AgvDispatchState',
            type: PlutoColumnType.text(),
            readOnly: true,
            width: 120,
            renderer: (rendererContext) {
              return Text(rendererContext.cell.value ?? '',
                  style: FluentTheme.of(context).typography.body!.copyWith(
                        color: rendererContext.cell.value == '已入库'
                            ? Color(0xff47C93A)
                            : rendererContext.cell.value == '未入库'
                                ? Color(0xffFF4857)
                                : Color(0xff333333),
                      ));
            },
          ),
          PlutoColumn(
            title: 'AGV调度状态',
            field: 'AgvSchedulingstatus',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '数据',
            field: 'data',
            type: PlutoColumnType.text(),
            readOnly: true,
            hide: true,
          ),
        ],
        rows: controller.rows,
        onLoaded: (event) {
          controller.stateManager = event.stateManager;
          controller.tableLoaded = true;
          controller.query();
          controller.update(['task_query']);
        },
        configuration: globalTheme.plutoGridConfig,
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
          Expanded(child: _buildTable(context)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskQueryController>(
      init: TaskQueryController(),
      id: "task_query",
      builder: (_) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(context),
        );
      },
    );
  }
}
