/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-06 10:11:37
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-27 16:45:36
 * @FilePath: /mesui/lib/pages/tool_management/standard_tool_management/view.dart
 * @Description: 标准刀库管理页面
 */
import 'package:eatm_manager/common/api/tool_management/standard_tool_management_api.dart';
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/utils/http.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:fluent_ui/fluent_ui.dart' as FluentUI;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:styled_widget/styled_widget.dart';

import 'index.dart';
import 'widgets/update_tool_form.dart';

class StandardToolManagementPage extends StatefulWidget {
  const StandardToolManagementPage({Key? key}) : super(key: key);

  @override
  State<StandardToolManagementPage> createState() =>
      _StandardToolManagementPageState();
}

class _StandardToolManagementPageState extends State<StandardToolManagementPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _StandardToolManagementViewGetX();
  }
}

class _StandardToolManagementViewGetX
    extends GetView<StandardToolManagementController> {
  const _StandardToolManagementViewGetX({Key? key}) : super(key: key);
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
              frozen: PlutoColumnFrozen.start,
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
              enableSorting: false),
          PlutoColumn(
              title: '刀具名称',
              field: 'toolName',
              type: PlutoColumnType.text(),
              frozen: PlutoColumnFrozen.start,
              enableContextMenu: false,
              enableSorting: false),
          PlutoColumn(
              title: '额定寿命(分钟)',
              field: 'ratedLife',
              type: PlutoColumnType.number(),
              frozen: PlutoColumnFrozen.start,
              enableContextMenu: false,
              enableSorting: false),
          PlutoColumn(
              title: '创建日期',
              field: 'createTime',
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
          controller.query();
        },
        onChanged: (PlutoGridOnChangedEvent event) {
          var currentRow = controller.stateManager.rows[event.rowIdx];
          var id = currentRow.cells['id']!.value;
          var changedKey = currentRow.cells.entries
              .where((element) => element.key != 'id')
              .elementAt(event.columnIdx)
              .key;
          print(changedKey);

          if (changedKey == 'toolName') {
            controller.updateTool(
                id,
                ToolInfo(
                  toolName: currentRow.cells['toolName']!.value,
                ),
                context);
          } else if (changedKey == 'ratedLife') {
            controller.updateTool(
                id,
                ToolInfo(
                  ratedLife: currentRow.cells['ratedLife']!.value.toString(),
                ),
                context);
          }
        },
        onRowChecked: (event) {
          print(event);
        },
        configuration: globalTheme.plutoGridConfig.copyWith(
          columnSize: const PlutoGridColumnSizeConfig(
              // resizeMode: PlutoResizeMode.pushAndPull,
              autoSizeMode: PlutoAutoSizeMode.scale),
        ),
      ),
    );
  }

  // 搜索栏
  Widget _buildSearch(context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: globalTheme.contentDecoration,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 25,
            runSpacing: 10,
            children: [
              SizedBox(
                width: 300.0,
                child: LineFormLabel(
                  label: '刀具名称',
                  isExpanded: true,
                  child: FluentUI.TextFormBox(
                    controller: controller.toolNameController,
                    placeholder: '请输入',
                    onSaved: (newValue) {},
                    onChanged: (value) {},
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return '必填';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Wrap(
            spacing: 10,
            children: [
              FluentUI.FilledButton(
                onPressed: controller.query,
                child: const Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 5,
                    children: [Icon(FluentUI.FluentIcons.search), Text('查询')]),
              ),
              FluentUI.FilledButton(
                child: const Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 5,
                    children: [Icon(FluentUI.FluentIcons.add), Text('新增')]),
                onPressed: () {
                  GlobalKey _key = GlobalKey();
                  FluentUI.showDialog(
                      context: context,
                      builder: (context) {
                        return FluentUI.ContentDialog(
                          constraints: const BoxConstraints(maxWidth: 500),
                          title: const Text('新增').fontSize(20),
                          content: Container(
                            height: 150,
                            child: UpdateToolForm(
                              key: _key,
                            ),
                          ),
                          actions: [
                            FluentUI.Button(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('取消')),
                            FluentUI.FilledButton(
                                onPressed: () async {
                                  var state = (_key.currentState!
                                      as UpdateToolFormState);
                                  var flag = state.toolInfo.validator();
                                  if (flag) {
                                    Navigator.of(context).pop();
                                    ResponseApiBody res =
                                        await StandardToolManagementApi.add({
                                      "params": {
                                        "toolName": state.toolInfo.toolName,
                                        "ratedLife": state.toolInfo.ratedLife,
                                        "creator": controller.currentUser,
                                      }
                                    });
                                    if (res.success == true) {
                                      PopupMessage.showSuccessInfoBar('操作成功');
                                      controller.query();
                                    } else {
                                      PopupMessage.showFailInfoBar(
                                          res.message as String);
                                    }
                                  } else {
                                    PopupMessage.showWarningInfoBar('请检查输入项');
                                  }
                                },
                                child: const Text('确定'))
                          ],
                        );
                      });
                },
              ),
              FluentUI.FilledButton(
                child: const Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 5,
                    children: [Icon(FluentUI.FluentIcons.edit), Text('修改')]),
                onPressed: () {
                  if (controller.stateManager.checkedRows.length != 1) {
                    PopupMessage.showWarningInfoBar('请选择一条数据');
                    return;
                  }
                  GlobalKey _key = GlobalKey();
                  FluentUI.showDialog(
                      context: context,
                      builder: (context) {
                        var curRow = controller.stateManager.checkedRows[0];
                        return FluentUI.ContentDialog(
                          constraints: const BoxConstraints(maxWidth: 500),
                          title: const Text('修改').fontSize(20),
                          content: Container(
                            height: 150,
                            child: UpdateToolForm(
                              key: _key,
                              toolName: curRow.cells['toolName']!.value,
                              ratedLife:
                                  curRow.cells['ratedLife']!.value.toString(),
                            ),
                          ),
                          actions: [
                            FluentUI.Button(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('取消')),
                            FluentUI.FilledButton(
                                onPressed: () async {
                                  var state = (_key.currentState!
                                      as UpdateToolFormState);
                                  var flag = state.toolInfo.validator();
                                  if (flag) {
                                    Navigator.of(context).pop();
                                    controller.updateTool(
                                        curRow.cells['id']!.value,
                                        ToolInfo(
                                          toolName: state.toolInfo.toolName,
                                          ratedLife: state.toolInfo.ratedLife,
                                        ),
                                        context);
                                  }
                                },
                                child: const Text('确定'))
                          ],
                        );
                      });
                },
              ),
              FluentUI.FilledButton(
                child: const Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 5,
                    children: [Icon(FluentUI.FluentIcons.delete), Text('删除')]),
                onPressed: () {
                  if (controller.stateManager.checkedRows.isEmpty) {
                    PopupMessage.showWarningInfoBar('请选择数据');
                    return;
                  }
                  FluentUI.showDialog(
                      context: context,
                      builder: (context) {
                        return FluentUI.ContentDialog(
                          title: const Text('删除').fontSize(20),
                          content: Text('确认删除选中的数据吗？'),
                          actions: [
                            FluentUI.Button(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('取消')),
                            FluentUI.FilledButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  ResponseApiBody res =
                                      await StandardToolManagementApi.delete({
                                    "params": {
                                      "ids": controller.stateManager.checkedRows
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
          )
        ],
      ),
    );
  }

  // 主视图
  Widget _buildView(context) {
    return Container(
      // decoration: BoxDecoration(
      //   color: GlobalStyle.instance.getPageContentBackgroundColor(context),
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
    return GetBuilder<StandardToolManagementController>(
      init: StandardToolManagementController(),
      id: "standard_tool_management",
      builder: (_) {
        return FluentUI.ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(context),
        );
      },
    );
  }
}
