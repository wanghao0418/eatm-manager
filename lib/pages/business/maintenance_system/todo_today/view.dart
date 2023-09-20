import 'package:eatm_manager/common/components/filled_icon_button.dart';
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/components/themed_text.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:eatm_manager/pages/business/maintenance_system/enum.dart';
import 'package:eatm_manager/pages/business/maintenance_system/todo_today/models.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:styled_widget/styled_widget.dart';

import 'index.dart';

class TodoTodayPage extends StatefulWidget {
  const TodoTodayPage({Key? key}) : super(key: key);

  @override
  State<TodoTodayPage> createState() => _TodoTodayPageState();
}

class _TodoTodayPageState extends State<TodoTodayPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _TodoTodayViewGetX();
  }
}

class _TodoTodayViewGetX extends GetView<TodoTodayController> {
  const _TodoTodayViewGetX({Key? key}) : super(key: key);
  GlobalTheme get globalTheme => GlobalTheme.instance;

  // 打开异常信息弹窗
  void openExceptionInformationDialog(int id) {
    TextEditingController textController = TextEditingController();
    SmartDialog.show(
      tag: 'exceptionInformationDialog',
      keepSingle: true,
      bindPage: true,
      builder: (context) {
        return ContentDialog(
          title: const Text('异常信息').fontSize(20.sp),
          content: TextBox(
            controller: textController,
            maxLines: 5,
          ),
          actions: [
            Button(
              onPressed: () =>
                  SmartDialog.dismiss(tag: 'exceptionInformationDialog'),
              child: const Text('取消'),
            ),
            FilledButton(
                child: const Text('保存'),
                onPressed: () {
                  SmartDialog.dismiss(tag: 'exceptionInformationDialog');
                  controller.updateIsAbnormal(id, true,
                      abnormalText: textController.text);
                })
          ],
        );
      },
    );
  }

  // 打开修改维保人员弹窗
  void openModifyMaintainerDialog(int id) {
    String? maintainer = controller
        .stateManager.checkedRows[0].cells['maintenancePersonnel']!.value;
    TextEditingController textController =
        TextEditingController(text: maintainer);
    SmartDialog.show(
      tag: 'modifyMaintainerDialog',
      keepSingle: true,
      bindPage: true,
      builder: (context) {
        return ContentDialog(
          title: const Text('修改维保人员').fontSize(20.sp),
          content: TextBox(
            controller: textController,
            maxLines: 5,
          ),
          actions: [
            Button(
              onPressed: () =>
                  SmartDialog.dismiss(tag: 'modifyMaintainerDialog'),
              child: const Text('取消'),
            ),
            FilledButton(
                child: const Text('保存'),
                onPressed: () {
                  SmartDialog.dismiss(tag: 'modifyMaintainerDialog');
                  controller.updateMaintenanceUser(id, textController.text);
                })
          ],
        );
      },
    );
  }

  // 顶部操作栏
  Widget _buildTopBar() {
    var formRow = Row(
      children: [
        Expanded(
            child: Wrap(spacing: 10, children: [
          LineFormLabel(
              label: '维保类别',
              width: 200,
              isExpanded: true,
              child: ComboBox(
                value: controller.search.maintenanceType,
                placeholder: const Text('维保类别'),
                items: MaintenanceCategory.values
                    .map((e) => ComboBoxItem(
                        value: e.value,
                        child: Tooltip(
                          message: e.label,
                          child: Text(e.label),
                        )))
                    .toList(),
                onChanged: (value) {
                  controller.search.maintenanceType = value;
                  controller.update(['todo_today']);
                },
              )),
          LineFormLabel(
              label: '维保项目',
              width: 200,
              isExpanded: true,
              child: ComboBox(
                value: controller.search.item,
                placeholder: const Text('维保项目'),
                items: MaintenanceItem.values
                    .map((e) => ComboBoxItem(
                        value: e.value,
                        child: Tooltip(
                          message: e.label,
                          child: Text(e.label),
                        )))
                    .toList(),
                onChanged: (value) {
                  controller.search.item = value!;
                  controller.update(['todo_today']);
                },
              )),
          LineFormLabel(
              label: '设备编号',
              width: 200,
              isExpanded: true,
              child: ComboBox<String>(
                placeholder: const Text('设备编号'),
                value: controller.search.deviceNum,
                items: controller.equipmentOptionList
                    .map((e) => ComboBoxItem<String>(
                        value: e.value,
                        child: Tooltip(
                          message: e.label,
                          child: Text(e.label!),
                        )))
                    .toList(),
                onChanged: (value) {
                  controller.search.deviceNum = value;
                  controller.update(['todo_today']);
                },
              )),
          LineFormLabel(
              label: '维保人员',
              width: 200,
              isExpanded: true,
              child: TextBox(
                placeholder: '维保人员',
                onChanged: (value) {
                  controller.search.name = value;
                },
              )),
        ]))
      ],
    );
    var buttonRow = Row(
      children: [
        Expanded(
            child: Wrap(
          spacing: 10,
          children: [
            FilledIconButton(
                icon: FluentIcons.search,
                label: '查询',
                onPressed: controller.query),
            FilledIconButton(
                icon: FluentIcons.sync_occurence,
                label: '重置',
                onPressed: () {
                  controller.search.reset();
                  controller.query();
                }),
            FilledButton(
                child: const Text('维保处理'),
                onPressed: () {
                  if (controller.stateManager.checkedRows.length != 1) {
                    PopupMessage.showWarningInfoBar('请选择一条要操作的记录');
                    return;
                  }
                  if (MaintenanceStatus.fromValue(controller.stateManager
                          .checkedRows[0].cells['maintenanceStatus']!.value) ==
                      MaintenanceStatus.completed) {
                    PopupMessage.showWarningInfoBar('该记录已完成');
                    return;
                  }
                  PopupMessage.showConfirmDialog(
                      title: '确认',
                      message: '是否保养完成',
                      onConfirm: () => controller.maintenanceHandle(
                            controller
                                .stateManager.checkedRows[0].cells['id']!.value,
                          ));
                }),
            FilledButton(
                child: const Text('修改维保人员'),
                onPressed: () {
                  if (controller.stateManager.checkedRows.length != 1) {
                    PopupMessage.showWarningInfoBar('请选择一条要操作的记录');
                    return;
                  }
                  openModifyMaintainerDialog(controller
                      .stateManager.checkedRows[0].cells['id']!.value);
                }),
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
              title: 'id',
              field: 'id',
              type: PlutoColumnType.text(),
              enableRowChecked: true,
              enableEditingMode: false,
              frozen: PlutoColumnFrozen.start,
              width: 80),
          PlutoColumn(
            title: '维保类别',
            field: 'maintenanceType',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 120,
            renderer: (rendererContext) => ThemedText(
                MaintenanceCategory.fromValue(rendererContext.cell.value!)
                    .label),
          ),
          PlutoColumn(
            title: '维保项目',
            field: 'maintenanceProject',
            type: PlutoColumnType.text(),
            width: 120,
            enableEditingMode: false,
          ),
          PlutoColumn(
            title: '设备编号',
            field: 'equipmentNo',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
          ),
          PlutoColumn(
            title: '维保部位',
            field: 'maintenancePosition',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
          ),
          PlutoColumn(
            title: '维保内容',
            field: 'maintenanceContent',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
          ),
          PlutoColumn(
            title: '维保标准',
            field: 'maintenanceStandard',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
          ),
          PlutoColumn(
            title: '周期',
            field: 'maintenanceCycle',
            type: PlutoColumnType.text(),
            width: 80,
            enableEditingMode: false,
          ),
          PlutoColumn(
            title: '维保人员',
            field: 'maintenancePersonnel',
            type: PlutoColumnType.text(),
            width: 120,
            enableEditingMode: false,
          ),
          PlutoColumn(
            title: '维保状态',
            field: 'maintenanceStatus',
            type: PlutoColumnType.text(),
            width: 120,
            enableEditingMode: false,
            renderer: (rendererContext) {
              MaintenanceStatus? status =
                  MaintenanceStatus.fromValue(rendererContext.cell.value);
              return Center(
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(5.r),
                  decoration: BoxDecoration(
                      color: status?.color,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(status?.label ?? '').textColor(Colors.white),
                ),
              );
            },
          ),
          PlutoColumn(
            title: '时间',
            field: 'maintenanceTime',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
          ),
          PlutoColumn(
            title: '是否存在异常',
            field: 'isAbnormal',
            type: PlutoColumnType.text(),
            width: 150,
            enableEditingMode: false,
            renderer: (rendererContext) => Center(
              child: ToggleSwitch(
                checked: rendererContext.cell.value,
                onChanged: (value) {
                  var id = rendererContext.row.cells['id']!.value;
                  if (value == true) {
                    // 打开异常信息弹窗
                    openExceptionInformationDialog(id);
                  } else {
                    // 打开确认弹窗
                    PopupMessage.showConfirmDialog(
                        title: '确认',
                        message: '是否取消设置异常？',
                        onConfirm: () =>
                            controller.updateIsAbnormal(id, false));
                  }
                },
              ),
            ),
          ),
          PlutoColumn(
            title: '异常说明',
            field: 'exceptionDescription',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
          ),
        ],
        rows: controller.rows,
        onLoaded: (event) {
          controller.stateManager = event.stateManager;
          controller.query();
        },
        onRowChecked: (event) {
          // 单选模式
          if (event.isAll) {
            controller.stateManager.toggleAllRowChecked(false);
          } else {
            if (event.isChecked == true) {
              controller.stateManager.toggleAllRowChecked(false);
              controller.stateManager.setRowChecked(event.row!, true);
            }
          }
        },
        configuration: globalTheme.plutoGridConfig,
      ),
    );
  }

  // 主视图
  Widget _buildView() {
    return Container(
      decoration: globalTheme.contentDecoration,
      padding: globalTheme.pagePadding,
      child: Column(
        children: [
          _buildTopBar(),
          globalTheme.contentDistance.verticalSpace,
          Expanded(child: _buildTable())
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TodoTodayController>(
      init: TodoTodayController(),
      id: "todo_today",
      builder: (_) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(),
        );
      },
    );
  }
}
