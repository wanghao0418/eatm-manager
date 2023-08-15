/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-06 10:21:53
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-15 14:12:13
 * @FilePath: /flutter-mesui/lib/pages/tool_management/mac_tool_magazine_management/view.dart
 */
import 'package:eatm_manager/common/api/tool_management/mac_tool_magazine_management_api.dart';
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/store/index.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/utils/http.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:fluent_ui/fluent_ui.dart' as FluentUI;
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:styled_widget/styled_widget.dart';

import 'index.dart';
import 'widgets/edit_tool_info_form.dart';

class MacToolMagazineManagementPage extends StatefulWidget {
  const MacToolMagazineManagementPage({Key? key}) : super(key: key);

  @override
  State<MacToolMagazineManagementPage> createState() =>
      _MacToolMagazineManagementPageState();
}

class _MacToolMagazineManagementPageState
    extends State<MacToolMagazineManagementPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _MacToolMagazineManagementViewGetX();
  }
}

class _MacToolMagazineManagementViewGetX
    extends GetView<MacToolMagazineManagementController> {
  const _MacToolMagazineManagementViewGetX({Key? key}) : super(key: key);
  GlobalTheme get globalTheme => GlobalTheme.instance;
  // 表格
  Widget _buildTable(context) {
    return Container(
      // padding: const EdgeInsets.all(10),
      decoration: globalTheme.contentDecoration,
      child: PlutoGrid(
        mode: PlutoGridMode.readOnly,
        columns: [
          PlutoColumn(
              title: 'ID',
              field: 'id',
              type: PlutoColumnType.text(),
              // frozen: PlutoColumnFrozen.start,
              readOnly: true,
              width: 80,
              enableContextMenu: false,
              enableSorting: false,
              hide: true),
          PlutoColumn(
            title: '序号',
            field: 'number',
            type: PlutoColumnType.text(),
            frozen: PlutoColumnFrozen.start,
            readOnly: true,
            enableRowChecked: true,
            width: 100,
            enableContextMenu: false,
            enableSorting: false,
          ),
          PlutoColumn(
              title: '机床',
              field: 'machineName',
              type: PlutoColumnType.text(),
              frozen: PlutoColumnFrozen.start,
              readOnly: true,
              width: 100,
              enableContextMenu: false,
              enableSorting: false),
          PlutoColumn(
              title: '刀库号',
              field: 'magazineNo',
              readOnly: true,
              width: 100,
              type: PlutoColumnType.text(),
              frozen: PlutoColumnFrozen.start,
              enableContextMenu: false,
              enableSorting: false),
          PlutoColumn(
              title: '刀具名称',
              field: 'toolName',
              type: PlutoColumnType.text(),
              enableContextMenu: false,
              enableSorting: false),
          PlutoColumn(
              title: '实物刀额定寿命',
              field: 'realToolRatedLife',
              type: PlutoColumnType.text(),
              enableContextMenu: false,
              enableSorting: false),
          PlutoColumn(
              title: '实物刀已使用寿命',
              field: 'realToolUsedLife',
              type: PlutoColumnType.text(),
              enableContextMenu: false,
              enableSorting: false),
          PlutoColumn(
              title: '实物刀剩余寿命',
              field: 'realToolLastLife',
              type: PlutoColumnType.text(),
              enableContextMenu: false,
              enableSorting: false),
          PlutoColumn(
              title: '长度磨损',
              field: 'lengthWear',
              type: PlutoColumnType.text(),
              enableContextMenu: false,
              enableSorting: false),
          PlutoColumn(
              title: '半径磨损',
              field: 'radiusWear',
              type: PlutoColumnType.text(),
              enableContextMenu: false,
              enableSorting: false),
          PlutoColumn(
              title: '探出长度',
              field: 'protrudingLength',
              type: PlutoColumnType.text(),
              enableContextMenu: false,
              enableSorting: false),
          PlutoColumn(
              title: '刀具代码',
              field: 'toolCode',
              type: PlutoColumnType.text(),
              enableContextMenu: false,
              enableSorting: false),
          PlutoColumn(
              title: '刀柄代码',
              field: 'handleCode',
              type: PlutoColumnType.text(),
              enableContextMenu: false,
              enableSorting: false),
          PlutoColumn(
              title: '长度公差',
              field: 'lengthTolerance',
              type: PlutoColumnType.text(),
              enableContextMenu: false,
              enableSorting: false),
          PlutoColumn(
              title: '刀具类型',
              field: 'toolType',
              type: PlutoColumnType.text(),
              enableContextMenu: false,
              enableSorting: false),
          PlutoColumn(
              title: '对刀模式',
              field: 'toolSettingMode',
              type: PlutoColumnType.text(),
              enableContextMenu: false,
              enableSorting: false),
          PlutoColumn(
              title: '半径公差',
              field: 'radiusTolerance',
              type: PlutoColumnType.text(),
              enableContextMenu: false,
              enableSorting: false),
          PlutoColumn(
              title: '刀具半径',
              field: 'toolRadius',
              type: PlutoColumnType.text(),
              enableContextMenu: false,
              enableSorting: false),
          PlutoColumn(
              title: '测量深度',
              field: 'measuringDepth',
              type: PlutoColumnType.text(),
              enableContextMenu: false,
              enableSorting: false),
          PlutoColumn(
              title: '备注',
              field: 'remark',
              type: PlutoColumnType.text(),
              enableContextMenu: false,
              enableSorting: false),
          // PlutoColumn(
          //     title: '用途参数1',
          //     field: 'useParam1',
          //     type: PlutoColumnType.text(),
          //     frozen: PlutoColumnFrozen.start,
          //     enableContextMenu: false,
          //     enableSorting: false),
          // PlutoColumn(
          //     title: '用途参数2',
          //     field: 'useParam2',
          //     type: PlutoColumnType.text(),
          //     frozen: PlutoColumnFrozen.start,
          //     enableContextMenu: false,
          //     enableSorting: false),
          // PlutoColumn(
          //     title: '用途参数3',
          //     field: 'useParam3',
          //     type: PlutoColumnType.text(),
          //     frozen: PlutoColumnFrozen.start,
          //     enableContextMenu: false,
          //     enableSorting: false),
          // PlutoColumn(
          //     title: '用途参数4',
          //     field: 'useParam4',
          //     type: PlutoColumnType.text(),
          //     frozen: PlutoColumnFrozen.start,
          //     enableContextMenu: false,
          //     enableSorting: false),
          PlutoColumn(
              title: '创建日期',
              field: 'createDate',
              readOnly: true,
              type: PlutoColumnType.date(),
              enableContextMenu: false,
              enableSorting: false),
          PlutoColumn(
              title: '创建者',
              field: 'creator',
              readOnly: true,
              type: PlutoColumnType.text(),
              enableContextMenu: false,
              enableSorting: false),
          PlutoColumn(
              title: '修改人',
              field: 'editor',
              readOnly: true,
              type: PlutoColumnType.text(),
              enableContextMenu: false,
              enableSorting: false),
          PlutoColumn(
              title: '修改时间',
              field: 'editTime',
              readOnly: true,
              type: PlutoColumnType.time(),
              enableContextMenu: false,
              enableSorting: false),
        ],
        rows: controller.rows,
        onLoaded: (PlutoGridOnLoadedEvent event) {
          controller.stateManager = event.stateManager;
        },
        onChanged: (PlutoGridOnChangedEvent event) {
          var currentRow = controller.stateManager.rows[event.rowIdx];
          var id = currentRow.cells['id']!.value;
          var changedKey = currentRow.cells.entries
              .where((element) => element.key != 'id')
              .elementAt(event.columnIdx)
              .key;
          print(changedKey);
        },
        onRowChecked: (event) {
          print(event);
        },
        configuration: globalTheme.plutoGridConfig,
      ),
    );
  }

  // 搜索栏
  Widget _buildSearch(context) {
    return Container(
      padding: globalTheme.pagePadding,
      decoration: globalTheme.contentDecoration,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: FluentUI.MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 300.0,
                child: LineFormLabel(
                  label: '机床',
                  isExpanded: true,
                  child: FluentUI.ComboBox<MacToolInfo>(
                    value: controller.currentMachine,
                    isExpanded: true,
                    // value: widget.showValue,
                    placeholder: Text('请选择'),
                    items: controller.machineList
                        .map((e) => FluentUI.ComboBoxItem(
                            value: e,
                            child: Tooltip(
                              message: e.machineName,
                              child: Text(
                                e.machineName ?? '',
                                overflow: TextOverflow.ellipsis,
                              ),
                            )))
                        .toList(),

                    onChanged: (val) {
                      controller.currentMachine = val!;
                      controller.update(['mac_tool_magazine_management']);
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 300.0,
                child: LineFormLabel(
                  label: '导入机床',
                  isExpanded: true,
                  child: FluentUI.ComboBox<String>(
                    value: controller.importMachine,
                    isExpanded: true,
                    // value: widget.showValue,
                    placeholder: Text('请选择'),
                    items: controller.machineList
                        .map((e) => FluentUI.ComboBoxItem(
                            value: e.machineName,
                            child: Tooltip(
                              message: e.machineName,
                              child: Text(
                                e.machineName ?? '',
                                overflow: TextOverflow.ellipsis,
                              ),
                            )))
                        .toList(),

                    onChanged: (val) {
                      controller.importMachine = val!;
                      controller.update(['mac_tool_magazine_management']);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: FluentUI.MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                spacing: 10,
                children: [
                  FluentUI.FilledButton(
                    onPressed: controller.query,
                    child: const Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 5,
                        children: [
                          Icon(FluentUI.FluentIcons.search),
                          Text('查询')
                        ]),
                  ),
                  FluentUI.FilledButton(
                    child: const Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 5,
                        children: [Icon(FluentUI.FluentIcons.add), Text('新增')]),
                    onPressed: () {
                      GlobalKey _key = GlobalKey();
                      SmartDialog.show(
                          tag: 'edit_tool_info',
                          builder: (context) {
                            return FluentUI.ContentDialog(
                              constraints: const BoxConstraints(maxWidth: 1000),
                              title: const Text('新增').fontSize(20),
                              content: Container(
                                height: 500,
                                child: Container(
                                  child: EditToolInfoForm(
                                    key: _key,
                                    machineList: controller.machineList,
                                  ),
                                ),
                              ),
                              actions: [
                                Container(
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FluentUI.Button(
                                          onPressed: () {
                                            SmartDialog.dismiss(
                                                tag: 'edit_tool_info');
                                          },
                                          child: const Text('取消')),
                                      SizedBox(
                                        width: 20.0,
                                      ),
                                      FluentUI.FilledButton(
                                          onPressed: () async {
                                            var state = (_key.currentState!
                                                as EditToolInfoFormState);
                                            if (state.editToolInfo
                                                    .validator() ==
                                                false) {
                                              PopupMessage.showWarningInfoBar(
                                                  '请确认必填项');

                                              return;
                                            }
                                            SmartDialog.dismiss(
                                                tag: 'edit_tool_info');

                                            var params =
                                                state.editToolInfo.toJson();
                                            params['creator'] = UserStore()
                                                .getCurrentUserInfo()
                                                .nickName;
                                            ResponseApiBody res =
                                                await MacToolMagazineManagementApi
                                                    .add({"params": params});
                                            if (res.success == true) {
                                              PopupMessage.showSuccessInfoBar(
                                                  '操作成功');
                                              controller.query();
                                            } else {
                                              PopupMessage.showFailInfoBar(
                                                  res.message as String);
                                            }
                                          },
                                          child: const Text('确定'))
                                    ],
                                  ),
                                )
                              ],
                            );
                          });
                    },
                  ),
                  FluentUI.FilledButton(
                    child: const Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 5,
                        children: [
                          Icon(FluentUI.FluentIcons.edit),
                          Text('修改')
                        ]),
                    onPressed: () {
                      if (controller.stateManager.checkedRows.length != 1) {
                        PopupMessage.showWarningInfoBar('请选择一条数据');
                        return;
                      }
                      GlobalKey _key = GlobalKey();
                      SmartDialog.show(
                          tag: 'edit_tool_info',
                          builder: (context) {
                            var curRow = controller.stateManager.checkedRows[0];
                            return FluentUI.ContentDialog(
                              constraints: const BoxConstraints(maxWidth: 1000),
                              title: const Text('修改').fontSize(20),
                              content: Container(
                                height: 500,
                                child: Container(
                                  child: EditToolInfoForm(
                                    key: _key,
                                    machineList: controller.machineList,
                                    editToolInfo: EditToolInfo.fromJson(
                                        curRow.cells.map((key, value) =>
                                            MapEntry(key, value.value))),
                                  ),
                                ),
                              ),
                              actions: [
                                Container(
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FluentUI.Button(
                                          onPressed: () {
                                            SmartDialog.dismiss(
                                                tag: 'edit_tool_info');
                                          },
                                          child: const Text('取消')),
                                      SizedBox(
                                        width: 20.0,
                                      ),
                                      FluentUI.FilledButton(
                                          onPressed: () async {
                                            var state = (_key.currentState!
                                                as EditToolInfoFormState);
                                            if (state.editToolInfo
                                                    .validator() ==
                                                false) {
                                              PopupMessage.showWarningInfoBar(
                                                  '请确认必填项');

                                              return;
                                            }
                                            SmartDialog.dismiss(
                                                tag: 'edit_tool_info');

                                            var params =
                                                state.editToolInfo.toJson();
                                            // 有id 为修改
                                            var id =
                                                curRow.cells['id']!.value !=
                                                        null
                                                    ? curRow.cells['id']!.value
                                                        .toString()
                                                    : '';
                                            var res;
                                            if (id.isNotEmpty) {
                                              params['id'] = id;
                                              params['editor'] = UserStore()
                                                  .getCurrentUserInfo()
                                                  .nickName;
                                              res =
                                                  await MacToolMagazineManagementApi
                                                      .update(
                                                          {"params": params});
                                            } else {
                                              // 无id 为新增
                                              params['creator'] = UserStore()
                                                  .getCurrentUserInfo()
                                                  .nickName;
                                              res =
                                                  await MacToolMagazineManagementApi
                                                      .add({"params": params});
                                            }

                                            if (res.success == true) {
                                              PopupMessage.showSuccessInfoBar(
                                                  '操作成功');

                                              controller.query();
                                            } else {
                                              PopupMessage.showFailInfoBar(
                                                  res.message as String);
                                            }
                                          },
                                          child: const Text('确定'))
                                    ],
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                  ),
                  FluentUI.FilledButton(
                    child: const Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 5,
                        children: [
                          Icon(FluentUI.FluentIcons.delete),
                          Text('删除')
                        ]),
                    onPressed: () {
                      if (controller.stateManager.checkedRows.isEmpty) {
                        PopupMessage.showWarningInfoBar('请选择数据');
                        return;
                      }
                      SmartDialog.show(
                          tag: 'delete_tool_info',
                          builder: (context) {
                            return FluentUI.ContentDialog(
                              title: const Text('删除').fontSize(20),
                              content: Text('确认删除选中的数据吗？'),
                              actions: [
                                FluentUI.Button(
                                    onPressed: () {
                                      SmartDialog.dismiss(
                                          tag: 'delete_tool_info');
                                    },
                                    child: const Text('取消')),
                                FluentUI.FilledButton(
                                    onPressed: () async {
                                      SmartDialog.dismiss(
                                          tag: 'delete_tool_info');
                                      ResponseApiBody res =
                                          await MacToolMagazineManagementApi
                                              .delete({
                                        "params": {
                                          "ids": controller
                                              .stateManager.checkedRows
                                              .map((e) => e.cells['id']!.value)
                                              .toList(),
                                        }
                                      });
                                      if (res.success == true) {
                                        PopupMessage.showSuccessInfoBar('操作成功');
                                        controller.query();
                                      } else {
                                        PopupMessage.showFailInfoBar(
                                            res.message as String);
                                      }
                                    },
                                    child: const Text('确定'))
                              ],
                            );
                          });
                    },
                  ),
                ],
              ),
              SizedBox(
                width: 10.0,
              ),
              FluentUI.FilledButton(
                onPressed: controller.importFile,
                child: const Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 5,
                    children: [Icon(FluentUI.FluentIcons.import), Text('导入')]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 主视图
  Widget _buildView(context) {
    return Container(
      // decoration: BoxDecoration(
      //   color: globalTheme.getPageContentBackgroundColor(context),
      // ),
      padding: globalTheme.pagePadding,
      child: Column(
        children: [
          _buildSearch(context),
          SizedBox(
            height: globalTheme.contentDistance,
          ),
          Expanded(child: _buildTable(context))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MacToolMagazineManagementController>(
      init: MacToolMagazineManagementController(),
      id: "mac_tool_magazine_management",
      builder: (_) {
        return FluentUI.ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(context),
        );
      },
    );
  }
}
