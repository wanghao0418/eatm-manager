/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-10 13:33:12
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-14 11:45:35
 * @FilePath: /flutter-mesui/lib/pages/tool_management/tool_magazine_outside_mac/view.dart
 */
import 'package:eatm_manager/common/api/tool_management/externalToolMagazine_api.dart';
import 'package:eatm_manager/common/components/filled_icon_button.dart';
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/components/themed_text.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/style/icons.dart';
import 'package:eatm_manager/common/utils/http.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:fluent_ui/fluent_ui.dart';
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

  // 打开新增弹窗
  void openAddDialog() {
    GlobalKey _key = GlobalKey();
    bool checkEmpty = false;
    if (controller.stateManager.checkedRows.length == 1 &&
        controller.stateManager.checkedRows.first.cells['data']!.value ==
            null) {
      checkEmpty = true;
    }
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
                  toolData: checkEmpty
                      ? Tool(
                          storageNum: controller.stateManager.checkedRows.first
                              .cells['storageNum']!.value,
                        )
                      : null,
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
                          var state = (_key.currentState! as AddToolFormState);

                          if (state.confirm() == true) {
                            SmartDialog.dismiss(tag: 'addTool');

                            ResponseApiBody res = await ExternalToolMagazineApi
                                .machineOutToolInput(
                                    {"params": state.toolAdd.toMap()});

                            if (res.success == true) {
                              // showAlertDialog(widgetContext, '成功', res.message as String);
                              PopupMessage.showSuccessInfoBar(
                                  res.message as String);
                              controller.query();
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
  }

  // 打开修改弹窗
  void openEditDialog(Tool tool) {
    GlobalKey _key = GlobalKey();
    SmartDialog.show(
        tag: 'editTool',
        builder: (context) {
          return FluentUI.ContentDialog(
            constraints: const BoxConstraints(maxWidth: 600),
            title: const Text('修改刀具').fontSize(20),
            content: Container(
              height: 300,
              child: Container(
                child: AddToolForm(
                    key: _key,
                    maxStorageNum: controller.currentShelf!.max!,
                    minStorageNum: controller.currentShelf!.min!,
                    shelfNo: controller.currentShelf!.shelfNo!,
                    toolData: tool),
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
                          SmartDialog.dismiss(tag: 'editTool');
                        },
                        child: const Text('取消')),
                    20.horizontalSpace,
                    FluentUI.FilledButton(
                        onPressed: () async {
                          var state = (_key.currentState! as AddToolFormState);

                          if (state.confirm() == true) {
                            SmartDialog.dismiss(tag: 'editTool');

                            controller.toolUpdate(state.toolAdd);
                          }
                        },
                        child: const Text('确定'))
                  ],
                ),
              )
            ],
          );
        });
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
                width: 200.0,
                child: LineFormLabel(
                  label: '刀具号',
                  isExpanded: true,
                  child: FluentUI.TextFormBox(
                    controller: controller.toolNumController,
                    placeholder: '请输入',
                    onSaved: (newValue) {},
                    onChanged: (value) {
                      controller.search.toolNum = value;
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
                onPressed: openAddDialog,
                child: const Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 5,
                    children: [Icon(FluentUI.FluentIcons.toolbox), Text('入库')]),
              ),
              FilledIconButton(
                  icon: FluentUI.FluentIcons.edit,
                  label: '修改',
                  onPressed: () {
                    if (controller.stateManager.checkedRows.length != 1) {
                      PopupMessage.showWarningInfoBar('请选择一个刀具');
                      return;
                    }
                    if (controller.stateManager.checkedRows.first.cells['data']!
                            .value ==
                        null) {
                      PopupMessage.showWarningInfoBar('当前货位无刀具');
                      return;
                    }

                    openEditDialog(controller
                        .stateManager.checkedRows.first.cells['data']!.value);
                  }),
              FilledIconButton(
                  icon: FluentUI.FluentIcons.delete,
                  label: '删除',
                  onPressed: controller.toolDelete)
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
              controller.search.shelfNo = controller.shelfList[index].shelfNo;
              controller.update(["tool_magazine_outside_mac"]);
              controller.query();
            },
          );
        },
        itemCount: controller.shelfList.length,
      ),
    );
  }

  // 获取图标颜色
  Color? getToolColor(Tool? toolData) {
    if (toolData == null) {
      return const Color(0xff999999);
    } else {
      var theoreticalLife = toolData.theoreticalLife;
      var usedLife = toolData.usedLife;
      if (theoreticalLife != null && usedLife != null) {
        if (double.tryParse(usedLife) == 0) {
          return FluentUI.Colors.green.lightest;
        } else if (double.tryParse(theoreticalLife)! <=
            double.tryParse(usedLife)!) {
          return FluentUI.Colors.red.lightest;
        }
      }
    }
    return null;
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
            enableRowChecked: true,
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
            renderer: (rendererContext) {
              var color =
                  getToolColor(rendererContext.row.cells['data']!.value);
              return Container(
                width: double.infinity,
                height: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.symmetric(horizontal: 5),
                color: color,
                child: Row(
                  mainAxisAlignment: FluentUI.MainAxisAlignment.spaceBetween,
                  children: [
                    Transform.rotate(
                      angle: -3.1415926535 / 2,
                      child: Image.asset(
                        width: 40,
                        height: 10,
                        'assets/images/tool/hilt.png',
                        fit: BoxFit.fitHeight,
                      ),
                    ),

                    // Icon(
                    //   MyIcons.tool,
                    //   size: 20,
                    //   color: color != null
                    //       ? FluentUI.Colors.white
                    //       : globalTheme.buttonIconColor,
                    // ),
                    ThemedText(
                      rendererContext.cell.value.toString(),
                      style: TextStyle(
                          color: color != null
                              ? FluentUI.Colors.white
                              : globalTheme.buttonIconColor),
                    )
                  ],
                ),
              );
            },
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
          controller.getShelfList();
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
