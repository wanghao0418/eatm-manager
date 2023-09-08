/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-10 13:33:12
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-08 16:15:28
 * @FilePath: /flutter-mesui/lib/pages/tool_management/tool_magazine_outside_mac/view.dart
 */
import 'package:eatm_manager/common/api/tool_management/externalToolMagazine_api.dart';
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/utils/http.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:fluent_ui/fluent_ui.dart' as FluentUI;
import 'package:pluto_grid/pluto_grid.dart';
import 'package:styled_widget/styled_widget.dart';
import 'index.dart';
import 'widgets/add_tool_form.dart';

class ToolMagazineOutsideMacPage extends StatefulWidget {
  const ToolMagazineOutsideMacPage({Key? key}) : super(key: key);

  @override
  State<ToolMagazineOutsideMacPage> createState() =>
      _ToolMagazineOutsideMacPageState();
}

class _ToolMagazineOutsideMacPageState extends State<ToolMagazineOutsideMacPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _ToolMagazineOutsideMacViewGetX();
  }
}

class _ToolMagazineOutsideMacViewGetX
    extends GetView<ToolMagazineOutsideMacController> {
  const _ToolMagazineOutsideMacViewGetX({Key? key}) : super(key: key);
  GlobalTheme get globalTheme => GlobalTheme.instance;
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
                  label: '刀具号',
                  isExpanded: true,
                  child: FluentUI.TextFormBox(
                    controller: controller.toolNumController,
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
                onPressed: () {
                  GlobalKey _key = GlobalKey();
                  var widgetContext = context;
                  SmartDialog.show(
                      tag: 'addTool',
                      builder: (context) {
                        return FluentUI.ContentDialog(
                          constraints: const BoxConstraints(maxWidth: 600),
                          title: const Text('入库刀具').fontSize(20),
                          content: Container(
                            height: 300,
                            child: Container(
                              child: AddToolForm(
                                key: _key,
                                maxStorageNum: controller.currentShelf!.max!,
                                minStorageNum: controller.currentShelf!.min!,
                                shelfNo: controller.currentShelf!.shelfNo!,
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
                                        SmartDialog.dismiss(tag: 'addTool');
                                      },
                                      child: const Text('取消')),
                                  20.horizontalSpace,
                                  FluentUI.FilledButton(
                                      onPressed: () async {
                                        var state = (_key.currentState!
                                            as AddToolFormState);

                                        if (state.confirm() == true) {
                                          SmartDialog.dismiss(tag: 'addTool');

                                          ResponseApiBody res =
                                              await ExternalToolMagazineApi
                                                  .machineOutToolInput(
                                                      state.toolAdd.toMap());

                                          if (res.success == true) {
                                            // showAlertDialog(widgetContext, '成功', res.message as String);
                                            PopupMessage.showSuccessInfoBar(
                                                res.message as String);
                                            var addedItem =
                                                Tool.fromJson(res.data);
                                            var toolIndex = controller
                                                .currentShelf!.list
                                                .indexWhere((item) =>
                                                    item.storageNum ==
                                                    addedItem.storageNum);
                                            print(toolIndex);
                                            if (toolIndex == -1) {
                                              print('新增');
                                              List list =
                                                  controller.currentShelf!.list;
                                              list.add(addedItem);
                                              controller.updateTableRows();
                                            } else {
                                              print('覆盖');
                                              List list =
                                                  controller.currentShelf!.list;
                                              list[toolIndex] = addedItem;
                                              controller.updateTableRows();
                                            }
                                          } else {
                                            PopupMessage.showFailInfoBar(
                                                res.message as String);
                                          }
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
                child: const Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 5,
                    children: [Icon(FluentUI.FluentIcons.toolbox), Text('入库')]),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(children: [
        SizedBox(
          width: 200.0,
          child: _buildShelfList(context),
        ),
        SizedBox(
          width: globalTheme.contentDistance,
        ),
        Expanded(child: _buildTable(context))
      ]),
    );
  }

  // 货架列表
  Widget _buildShelfList(BuildContext context) {
    return Container(
      decoration: globalTheme.contentDecoration,
      padding: const EdgeInsets.all(10),
      child: FluentUI.ListView.builder(
        itemBuilder: (context, index) {
          return FluentUI.ListTile.selectable(
            title: Text('${controller.shelfList[index].shelfNo!}号货架'),
            selected: controller.currentShelf == controller.shelfList[index],
            onSelectionChange: (value) {
              controller.currentShelf = controller.shelfList[index];
              controller.update(["tool_magazine_outside_mac"]);
            },
          );
        },
        itemCount: controller.shelfList.length,
      ),
    );
  }

  // 表格
  Widget _buildTable(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(10),
      decoration: globalTheme.contentDecoration,
      child: PlutoGrid(
        mode: PlutoGridMode.readOnly,
        columns: [
          PlutoColumn(
            title: '货架号',
            field: 'deviceName',
            frozen: PlutoColumnFrozen.start,
            type: PlutoColumnType.text(),
            readOnly: true,
            enableContextMenu: false,
            enableSorting: false,
            width: 100,
          ),
          PlutoColumn(
            title: '货位号',
            field: 'storageNum',
            frozen: PlutoColumnFrozen.start,
            type: PlutoColumnType.text(),
            readOnly: true,
            enableContextMenu: false,
            enableSorting: false,
            width: 100,
          ),
          PlutoColumn(
            title: '刀具号',
            field: 'toolNum',
            frozen: PlutoColumnFrozen.start,
            type: PlutoColumnType.text(),
            readOnly: true,
            enableContextMenu: false,
            enableSorting: false,
            width: 100,
          ),
          PlutoColumn(
            title: '刀具名称',
            field: 'toolFullName',
            type: PlutoColumnType.text(),
            readOnly: true,
            enableContextMenu: false,
            enableSorting: false,
          ),
          PlutoColumn(
            title: '刀具长度',
            field: 'toolLength',
            type: PlutoColumnType.text(),
            readOnly: true,
            enableContextMenu: false,
            enableSorting: false,
          ),
          PlutoColumn(
            title: '刀具类型',
            field: 'toolType',
            type: PlutoColumnType.text(),
            readOnly: true,
            enableContextMenu: false,
            enableSorting: false,
          ),
          PlutoColumn(
            title: '刀柄类型',
            field: 'toolHiltType',
            type: PlutoColumnType.text(),
            readOnly: true,
            enableContextMenu: false,
            enableSorting: false,
          ),
          PlutoColumn(
            title: '理论寿命',
            field: 'theoreticalLife',
            type: PlutoColumnType.text(),
            readOnly: true,
            enableContextMenu: false,
            enableSorting: false,
          ),
          PlutoColumn(
            title: '已用寿命',
            field: 'usedLife',
            type: PlutoColumnType.text(),
            readOnly: true,
            enableContextMenu: false,
            enableSorting: false,
          ),
          PlutoColumn(
            title: '记录时间',
            field: 'recordTime',
            type: PlutoColumnType.text(),
            readOnly: true,
            enableContextMenu: false,
            enableSorting: false,
          ),
        ],
        rows: controller.rows,
        onLoaded: (PlutoGridOnLoadedEvent event) {
          controller.stateManager = event.stateManager;
          controller.getToolMagazineList();
        },
        onRowChecked: (event) {
          print(event);
        },
        configuration: globalTheme.plutoGridConfig,
      ),
    );
  }

  // 主视图
  Widget _buildView(BuildContext context) {
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
          Expanded(child: _buildContent(context))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ToolMagazineOutsideMacController>(
      init: ToolMagazineOutsideMacController(),
      id: "tool_magazine_outside_mac",
      builder: (_) {
        return FluentUI.ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(context),
        );
      },
    );
  }
}
