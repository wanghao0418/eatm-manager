/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-10 15:41:34
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-24 19:15:17
 * @FilePath: /eatm_manager/lib/pages/business/craft_binding/view.dart
 * @Description: 工艺绑定视图层
 */
import 'package:eatm_manager/common/components/filled_icon_button.dart';
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/components/themed_text.dart';
import 'package:eatm_manager/common/components/title_card.dart';
import 'package:eatm_manager/common/models/workProcess.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/utils/log.dart';
import 'package:eatm_manager/common/widgets/pop_date_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'index.dart';
import 'widgets/chip_settings_content.dart';

class CraftBindingPage extends StatefulWidget {
  const CraftBindingPage({Key? key}) : super(key: key);

  @override
  State<CraftBindingPage> createState() => _CraftBindingPageState();
}

class _CraftBindingPageState extends State<CraftBindingPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _CraftBindingViewGetX();
  }
}

class _CraftBindingViewGetX extends GetView<CraftBindingController> {
  const _CraftBindingViewGetX({Key? key}) : super(key: key);
  GlobalTheme get globalTheme => GlobalTheme.instance;

  // 搜索框
  Widget _buildSearchBar(BuildContext context) {
    var form = Row(
      children: [
        Expanded(
            child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            LineFormLabel(
              label: '工艺路线',
              width: 200,
              isExpanded: true,
              child: ComboBox<int?>(
                value: controller.search.workmanship,
                items: controller.processRouteList
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
                  controller.search.workmanship = value;
                  controller.update(["craft_binding"]);
                },
              ),
            ),
            LineFormLabel(
              label: '工件类型',
              width: 200,
              isExpanded: true,
              child: ComboBox<int?>(
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
                  controller.update(["craft_binding"]);
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
              label: '芯片Id',
              width: 200,
              isRequired: true,
              isExpanded: true,
              child: TextBox(
                placeholder: '请输入芯片Id',
                onChanged: (value) {
                  controller.search.barcode = value;
                },
              ),
            ),
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
        )),
        10.horizontalSpace,
        Expanded(
            child: Wrap(
          alignment: WrapAlignment.end,
          spacing: 10,
          runSpacing: 10,
          children: [
            LineFormLabel(
              label: '装料台',
              width: 200,
              isExpanded: true,
              child: ComboBox<String?>(
                value: controller.currentResourceName,
                placeholder: const Text('请选择'),
                items: controller.resourceList
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
                  controller.currentResourceName = value;
                  controller.update(["craft_binding"]);
                },
              ),
            ),
            LineFormLabel(
              label: '托盘类型',
              width: 200,
              isExpanded: true,
              child: ComboBox<String?>(
                value: controller.currentTrayType,
                placeholder: const Text('请选择'),
                items: controller.trayTypeList
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
                  controller.currentTrayType = value;
                  controller.update(["craft_binding"]);
                },
              ),
            ),
            LineFormLabel(
              label: '装夹方式',
              width: 200,
              isExpanded: true,
              child: ComboBox<String?>(
                value: controller.currentClampType,
                placeholder: const Text('请选择'),
                items: controller.clampTypeList
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
                  controller.currentClampType = value;
                  controller.update(["craft_binding"]);
                },
              ),
            ),
          ],
        ))
      ],
    );
    var buttonBar = Row(
      children: [
        Expanded(
            child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            FilledIconButton(
                label: '查询',
                onPressed: controller.query,
                icon: FluentIcons.search),
          ],
        )),
        10.horizontalSpace,
        Expanded(
            child: Wrap(
          alignment: WrapAlignment.end,
          spacing: 10,
          runSpacing: 10,
          children: [
            FilledIconButton(
                label: '绑定',
                onPressed: controller.binding,
                icon: FluentIcons.link),
            FilledIconButton(
                label: '设置主从芯片',
                onPressed: () => _openChipSettingDialog(context),
                icon: FluentIcons.settings),
          ],
        ))
      ],
    );

    return Container(
      decoration: globalTheme.contentDecoration,
      padding: globalTheme.contentPadding,
      child: Column(
        children: [form, 10.verticalSpace, buttonBar],
      ),
    );
  }

  // 模号列表
  Widget _buildMouldSNList(BuildContext context) {
    return Container(
      width: 200.w,
      // padding: globalTheme.contentPadding,
      decoration: globalTheme.contentDecoration,
      child: TitleCard(
          title: '模号',
          cardBackgroundColor: globalTheme.pageContentBackgroundColor,
          containChild: ListView.builder(
              padding: const EdgeInsets.all(10),
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

  // 已选数据列表
  Widget _buildSelectedList() {
    return Container(
      width: 200.w,
      decoration: globalTheme.contentDecoration,
      child: TitleCard(
          title: '已选',
          titleRight: IconButton(
              icon: const Icon(FluentIcons.clear),
              onPressed: () {
                controller.selectedDataMap.clear();
                // 更新表格选中
                controller.stateManager.toggleAllRowChecked(false);
                controller.update(["craft_binding"]);
              }),
          cardBackgroundColor: globalTheme.pageContentBackgroundColor,
          containChild: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: controller.selectedDataMap.length,
              itemBuilder: (context, index) {
                var data = controller.selectedDataMap.values.elementAt(index);
                var key = data.mouldsn! + data.partsn!;
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      data.mouldsn != null
                          ? ThemedText(
                              '监控编号${data.mwpiececode!}',
                              style: const TextStyle(
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis),
                            )
                          : ThemedText(
                              '模号${data.mouldsn!}件号${data.partsn!}',
                              style: const TextStyle(
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis),
                            ),
                      IconButton(
                          icon: const Icon(FluentIcons.delete),
                          onPressed: () {
                            controller.selectedDataMap.remove(key);
                            // 更新表格选中
                            var hasFilter = false;
                            if (controller.stateManager.hasFilter) {
                              hasFilter = true;
                              controller.stateManager.setFilter(null);
                            }
                            var row = controller.stateManager.rows
                                .firstWhereOrNull((element) =>
                                    controller.isSameWorkProcessData(
                                        element.cells['data']!.value
                                            as WorkProcessData,
                                        data));
                            if (row != null) {
                              controller.stateManager.setRowChecked(row, false);
                            }
                            if (hasFilter) {
                              controller.stateManager.setFilter((element) =>
                                  controller.selectedMouldSNList.contains(
                                      element.cells['mouldSN']!.value
                                          .toString()));
                            }
                            controller.update(["craft_binding"]);
                          })
                    ],
                  ),
                );
              })),
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
            title: '工件名称',
            field: 'mwpieceName',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '装夹方式',
            field: 'clampType',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
          PlutoColumn(
            title: '托盘类型',
            field: 'trayType',
            type: PlutoColumnType.text(),
            readOnly: true,
          ),
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
        onRowChecked: (event) {
          // LogUtil.f(event);
          if (event.isAll) {
            LogUtil.t('event.isChecked: ${event.isChecked}');
            // 全选
            if (event.isChecked!) {
              // 新增所有不存在的数据
              for (var row in controller.stateManager.checkedRows) {
                var data = row.cells['data']!.value as WorkProcessData;
                var key = data.mouldsn! + data.partsn!;
                if (!controller.selectedDataMap.containsKey(key)) {
                  controller.selectedDataMap[key] = data;
                }
              }
            } else {
              // 删除所有存在的数据
              for (var row in controller.stateManager.rows) {
                var data = row.cells['data']!.value as WorkProcessData;
                var key = data.mouldsn! + data.partsn!;
                if (controller.selectedDataMap.containsKey(key)) {
                  controller.selectedDataMap.remove(key);
                }
              }
            }
          } else {
            // 单选
            if (event.row!.checked!) {
              var data = event.row!.cells['data']!.value as WorkProcessData;
              var key = data.mouldsn! + data.partsn!;
              if (!controller.selectedDataMap.containsKey(key)) {
                controller.selectedDataMap[key] = data;
              }
            } else {
              var data = event.row!.cells['data']!.value as WorkProcessData;
              var key = data.mouldsn! + data.partsn!;
              if (controller.selectedDataMap.containsKey(key)) {
                controller.selectedDataMap.remove(key);
              }
            }
          }
          controller.update(["craft_binding"]);
        },
        configuration: globalTheme.plutoGridConfig.copyWith(
            columnSize: const PlutoGridColumnSizeConfig(
                autoSizeMode: PlutoAutoSizeMode.scale)),
      ),
    );
  }

  // 打开芯片设置弹窗
  void _openChipSettingDialog(BuildContext context) {
    SmartDialog.show(
        tag: 'chip_setting_dialog',
        builder: (context) {
          return ContentDialog(
            constraints: const BoxConstraints(maxWidth: 800),
            title: const ThemedText(
              '设置主从芯片',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              height: 500.0,
              child: ChipSettingsContent(
                trayTypeList: controller.steelTrayTypeList,
              ),
            ),
            actions: [
              FilledButton(
                  onPressed: () {
                    // Navigator.of(context).pop();
                    SmartDialog.dismiss(tag: 'chip_setting_dialog');
                  },
                  child: const Text('关闭')),
            ],
          );
        });
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return ContentDialog(
    //         constraints: const BoxConstraints(maxWidth: 800),
    //         title: const ThemedText(
    //           '设置主从芯片',
    //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    //         ),
    //         content: SizedBox(
    //           height: 500.0,
    //           child: ChipSettingsContent(
    //             trayTypeList: controller.steelTrayTypeList,
    //           ),
    //         ),
    //         actions: [
    //           FilledButton(
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //               },
    //               child: const Text('关闭')),
    //         ],
    //       );
    //     });
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
              Expanded(child: _buildTable(context)),
              globalTheme.contentDistance.horizontalSpace,
              _buildSelectedList()
            ],
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CraftBindingController>(
      init: CraftBindingController(),
      id: "craft_binding",
      builder: (_) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(context),
        );
      },
    );
  }
}
