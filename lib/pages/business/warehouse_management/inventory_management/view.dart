/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-25 13:37:07
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-05 13:36:49
 * @FilePath: /eatm_manager/lib/pages/business/warehouse_management/shelf_management/view.dart
 * @Description: 货架管理页面
 */
import 'package:eatm_manager/common/components/filled_icon_button.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:styled_widget/styled_widget.dart';

import 'index.dart';

class InventoryManagementPage extends StatefulWidget {
  const InventoryManagementPage({Key? key}) : super(key: key);

  @override
  State<InventoryManagementPage> createState() =>
      _InventoryManagementPageState();
}

class _InventoryManagementPageState extends State<InventoryManagementPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _InventoryManagementViewGetX();
  }
}

class _InventoryManagementViewGetX
    extends GetView<InventoryManagementController> {
  const _InventoryManagementViewGetX({Key? key}) : super(key: key);
  GlobalTheme get globalTheme => GlobalTheme.instance;

  // 头部
  Widget _buildHeader(BuildContext context) {
    // 左侧表单
    var leftForm = Wrap(
      spacing: 10.r,
      runSpacing: 10.r,
      children: [
        SizedBox(
          width: 250.0,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.only(right: 5),
                child: RichText(
                    text: TextSpan(
                  // text: '*',
                  // style: TextStyle(color: Colors.redAccent),
                  children: [
                    TextSpan(
                        text: '工件类型:',
                        style: FluentTheme.of(context).typography.body),
                  ],
                )),
              ),
              10.horizontalSpaceRadius,
              Expanded(
                  child: ComboBox<int?>(
                // value: controller.currentMachine,
                isExpanded: true,
                value: controller.search.artifactType,
                placeholder: const Text('请选择'),
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
                  controller.search.artifactType = val;
                  controller.update(['shelf_management']);
                },
              ))
            ],
          ),
        ),
        // SizedBox(
        //   width: 250.0,
        //   child: Row(
        //     children: [
        //       Container(
        //         padding: const EdgeInsets.only(right: 5),
        //         child: RichText(
        //             text: TextSpan(
        //           // text: '*',
        //           // style: TextStyle(color: Colors.redAccent),
        //           children: [
        //             TextSpan(
        //                 text: '入库类型:',
        //                 style: FluentTheme.of(context).typography.body),
        //           ],
        //         )),
        //       ),
        //       10.horizontalSpaceRadius,
        //       Expanded(
        //           child: ComboBox<dynamic>(
        //         // value: controller.currentMachine,
        //         isExpanded: true,
        //         value: controller.inventoryManagementForm.storageType,
        //         placeholder: Text(
        //           '请选择',
        //           style: FluentTheme.of(context).typography.body,
        //         ),
        //         items: controller.storageTypeList
        //             .map((e) => ComboBoxItem(
        //                 value: e.value,
        //                 child: Tooltip(
        //                   message: e.label,
        //                   child: Text(
        //                     e.label!,
        //                     overflow: TextOverflow.ellipsis,
        //                   ),
        //                 )))
        //             .toList(),

        //         onChanged: (val) {
        //           controller.inventoryManagementForm.storageType = val;
        //           controller.update(['shelf_management']);
        //         },
        //       ))
        //     ],
        //   ),
        // ),
        if (controller.showAGV.value)
          SizedBox(
            width: 250.0,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 5),
                  child: RichText(
                      text: TextSpan(
                    // text: '*',
                    // style: TextStyle(color: Colors.redAccent),
                    children: [
                      TextSpan(
                          text: 'AGV入库数量:',
                          style: FluentTheme.of(context).typography.body),
                    ],
                  )),
                ),
                10.horizontalSpaceRadius,
                Expanded(
                    child: NumberBox<int>(
                  mode: SpinButtonPlacementMode.none,
                  placeholder: '请输入',
                  value: controller.search.aGVStorageNum,
                  onChanged: (value) {
                    controller.search.aGVStorageNum = value ?? 0;
                    // setState(() {});
                  },
                ))
              ],
            ),
          ),
      ],
    );
    // 左侧按钮
    var leftButtons = Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10.r,
      runSpacing: 10.r,
      children: [
        FilledIconButton(
            onPressed: controller.query, label: '搜索', icon: FluentIcons.search),
        FilledIconButton(
          onPressed: controller.out,
          label: '出库',
          icon: FluentIcons.open_pane_mirrored,
        ),
        if (controller.showAGV.value)
          Button(onPressed: controller.onTap, child: const Text('AGV出库')),
        if (controller.showAGV.value)
          Button(onPressed: controller.onTap, child: const Text('AGV入库')),
      ],
    );

    // 右侧表单
    var rightForm = SizedBox(
      child: Row(children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 5,
          children: [
            Text('自动出入库开关:', style: FluentTheme.of(context).typography.body),
            ToggleSwitch(
              checked: controller.toggle.value,
              onChanged: (value) {
                controller.toggle.value = value;
                controller.update(['shelf_management']);
              },
            )
          ],
        ),
        10.horizontalSpaceRadius,
        SizedBox(
          width: 150.0,
          child: ComboBox<String>(
            // value: controller.currentMachine,
            isExpanded: true,
            value: controller.currentTask.value,
            placeholder: Text(
              '请选择任务',
              style: FluentTheme.of(context).typography.body,
            ),
            items: controller.taskList
                .map((e) => ComboBoxItem(
                    value: e,
                    child: Tooltip(
                      message: e,
                      child: Text(
                        e,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )))
                .toList(),

            onChanged: (val) {
              controller.currentTask.value = val!;
              controller.update(['shelf_management']);
            },
          ),
        )
      ]),
    );

    // 右侧按钮
    var rightButtons = Wrap(
      spacing: 10.r,
      runSpacing: 10.r,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        FilledButton(
          onPressed: controller.onTap,
          style: ButtonStyle().copyWith(
            backgroundColor: ButtonState.all(Colors.red),
          ),
          child: const Text('暂停'),
        ),
        FilledButton(
          onPressed: controller.onTap,
          style: ButtonStyle().copyWith(
            backgroundColor: ButtonState.all(Colors.successPrimaryColor),
          ),
          child: const Text('继续'),
        ),
        FilledButton(
          onPressed: controller.onTap,
          style: ButtonStyle().copyWith(
            backgroundColor: ButtonState.all(Colors.blue),
          ),
          child: const Text('执行任务'),
        ),
      ],
    );

    return Container(
        decoration: BoxDecoration(
            color: globalTheme.pageContentBackgroundColor,
            borderRadius: globalTheme.contentRadius,
            boxShadow: [globalTheme.boxShadow]),
        padding: globalTheme.pagePadding,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: leftForm),
                20.horizontalSpaceRadius,
                if (controller.showAGV.value) rightForm
              ],
            ),
            10.verticalSpacingRadius,
            Row(
              children: [
                Expanded(child: leftButtons),
                20.horizontalSpaceRadius,
                if (controller.showAGV.value) rightButtons
              ],
            ),
          ],
        ));
  }

  // 底部导航栏
  Widget _buildBottomBar(BuildContext context) {
    return Card(
        padding: const EdgeInsets.all(10),
        child: Container(
          height: 40,
          child: Row(
            children: [
              Expanded(
                  child: Text(
                '提示信息:',
                style: FluentTheme.of(context).typography.body,
              )),
              Expanded(
                  child: Text(
                'AGV状态:',
                style: FluentTheme.of(context).typography.body,
              )),
            ],
          ),
        ));
  }

  // 内容
  Widget _buildContent(BuildContext context) {
    // 货架列表侧边栏
    var shelfList = Container(
      decoration: globalTheme.contentDecoration,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: 150.0,
        child: Column(children: [
          Text(
            '全部货架',
            style: FluentTheme.of(context).typography.bodyLarge,
          ).fontSize(16).fontWeight(FontWeight.bold),
          10.verticalSpace,
          const Divider(),
          10.verticalSpace,
          Expanded(
              child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: controller.shelfList.length,
            itemBuilder: (context, index) {
              var item = controller.shelfList[index];
              return ListTile.selectable(
                selected: controller.search.shelfNum == item,
                title: Text('货架$item'),
                onPressed: () {
                  if (controller.search.shelfNum == item) {
                    return;
                  }
                  controller.search.shelfNum = item;
                  controller.query();
                  controller.update(['shelf_management']);
                },
              );
            },
          ))
        ]),
      ),
    );

    // 货架表格
    var shelfTable = Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: globalTheme.pageContentBackgroundColor,
          borderRadius: globalTheme.contentRadius,
          boxShadow: [globalTheme.boxShadow]),
      child: PlutoGrid(
          columns: [
            PlutoColumn(
                title: '序号',
                field: 'number',
                width: 100,
                readOnly: true,
                type: PlutoColumnType.text()),
            PlutoColumn(
                title: '货位号',
                field: 'storageNum',
                width: 100,
                readOnly: true,
                type: PlutoColumnType.text()),
            PlutoColumn(
                title: '工件SN',
                field: 'workpieceSN',
                readOnly: true,
                type: PlutoColumnType.text()),
            PlutoColumn(
                title: '工件类型',
                field: 'workpieceType',
                readOnly: true,
                type: PlutoColumnType.text()),
            PlutoColumn(
                title: '托盘类型',
                field: 'trayType',
                readOnly: true,
                type: PlutoColumnType.text()),
            PlutoColumn(
                title: '托盘重量',
                field: 'trayWeight',
                readOnly: true,
                type: PlutoColumnType.text()),
            PlutoColumn(
                title: '更新时间',
                field: 'recordTime',
                width: 300,
                readOnly: true,
                type: PlutoColumnType.text()),
            PlutoColumn(
              title: '勾选',
              field: 'checked',
              width: 85,
              readOnly: true,
              type: PlutoColumnType.text(),
              enableEditingMode: false,
              renderer: (rendererContext) {
                return Center(
                  child: SizedBox(
                    width: 20.0,
                    height: 20,
                    child: Checkbox(
                        checked: rendererContext.cell.value,
                        onChanged: (val) {
                          if (rendererContext.row.cells['useable']!.value !=
                              0) {
                            PopupMessage.showWarningInfoBar('该货位已禁用');
                            return;
                          }
                          for (var element in controller.stateManager.rows) {
                            element.cells['checked']!.value = false;
                          }
                          controller.stateManager.toggleAllRowChecked(false);
                          rendererContext.cell.value = val;
                          controller.stateManager.setRowChecked(
                              rendererContext.row, val!,
                              notify: true);
                          controller.update(['shelf_management']);
                        }),
                  ),
                );
              },
              // footerRenderer: (context) {
              //   return Center(
              //     child: Wrap(
              //       children: [
              //         Text(
              //           '全选',
              //           style: FluentTheme.of(Get.context!).typography.body,
              //         ),
              //         10.horizontalSpaceRadius,
              //         Checkbox(
              //             checked: controller.isAllChecked(),
              //             onChanged: (val) {
              //               if (val!) {
              //                 var needCheckRows = controller.stateManager.rows
              //                     .where((element) => !controller
              //                         .isDisabled(element.cells['uSABLE']!));
              //                 for (var element in needCheckRows) {
              //                   element.cells['checked']!.value = val;
              //                   controller.stateManager
              //                       .setRowChecked(element, val);
              //                 }
              //                 controller.update(['shelf_management']);
              //               } else {
              //                 controller.stateManager.toggleAllRowChecked(val);
              //                 for (var element in controller.rows) {
              //                   element.cells['checked']!.value = val;
              //                 }
              //                 controller.update(['shelf_management']);
              //               }
              //             })
              //       ],
              //     ),
              //   );
              // },
            ),
            PlutoColumn(
              title: '禁用',
              field: 'useable',
              width: 85,
              type: PlutoColumnType.text(),
              enableEditingMode: false,
              readOnly: true,
              renderer: (rendererContext) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ToggleSwitch(
                    checked: rendererContext.cell.value != 0,
                    onChanged: (value) {
                      controller.changeStorageState(rendererContext, value);
                      // rendererContext.stateManager!.setCell(
                      //     rendererContext.rowIdx, rendererContext.field, value,
                      //     notify: true);
                    },
                  ),
                );
              },
            ),
            PlutoColumn(
                title: '当前状态',
                field: 'currentState',
                readOnly: true,
                type: PlutoColumnType.text()),
          ],
          rows: controller.rows,
          onLoaded: (PlutoGridOnLoadedEvent event) {
            controller.stateManager = event.stateManager;
            controller.query();
          },
          onRowChecked: (event) {
            print(event);
            // controller.update(['shelf_management']);
          },
          configuration: globalTheme.plutoGridConfig),
    );

    return Container(
      child: Row(
        children: [
          shelfList,
          globalTheme.contentDistance.horizontalSpace,
          Expanded(child: shelfTable)
        ],
      ),
    );
  }

  // 主视图
  Widget _buildView(BuildContext context) {
    return Container(
        padding: globalTheme.pagePadding,
        child: Column(
          children: [
            _buildHeader(context),
            globalTheme.contentDistance.verticalSpace,
            Expanded(child: _buildContent(context)),
            if (controller.showAGV.value)
              globalTheme.contentDistance.verticalSpace,
            if (controller.showAGV.value) _buildBottomBar(context)
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InventoryManagementController>(
      init: InventoryManagementController(),
      id: "shelf_management",
      builder: (_) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(context),
        );
      },
    );
  }
}
