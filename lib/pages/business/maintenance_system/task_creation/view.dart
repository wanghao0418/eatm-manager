import 'package:eatm_manager/common/components/filled_icon_button.dart';
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/components/themed_text.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:eatm_manager/common/widgets/pop_date_picker.dart';
import 'package:eatm_manager/pages/business/maintenance_system/enum.dart';
import 'package:eatm_manager/pages/business/maintenance_system/task_creation/widgets/add_task_form.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:styled_widget/styled_widget.dart';

import 'index.dart';

class TaskCreationPage extends StatefulWidget {
  const TaskCreationPage({Key? key}) : super(key: key);

  @override
  State<TaskCreationPage> createState() => _TaskCreationPageState();
}

class _TaskCreationPageState extends State<TaskCreationPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _TaskCreationViewGetX();
  }
}

class _TaskCreationViewGetX extends GetView<TaskCreationController> {
  const _TaskCreationViewGetX({Key? key}) : super(key: key);
  GlobalTheme get globalTheme => GlobalTheme.instance;

  // 打开新增任务弹窗
  void openAddTaskDialog() {
    SmartDialog.show(
      tag: 'add_task',
      keepSingle: true,
      bindPage: true,
      builder: (context) {
        GlobalKey key = GlobalKey();
        return ContentDialog(
          title: const Text('创建维保任务').fontSize(20.sp),
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
          content: AddTaskForm(
            key: key,
          ),
          actions: [
            Button(
                child: const Text('取消'),
                onPressed: () {
                  SmartDialog.dismiss(tag: 'add_task');
                }),
            FilledButton(
                child: const Text('确定'),
                onPressed: () {
                  AddTaskFormState state =
                      key.currentState! as AddTaskFormState;
                  if (state.confirm() == true) {
                    SmartDialog.dismiss(tag: 'add_task');
                    // 新增任务
                    controller.createMaintenanceTask(state.addForm.toMap());
                  }
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
            child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            LineFormLabel(
                label: '维保人员',
                width: 200,
                isExpanded: true,
                child: TextBox(
                  placeholder: '维保人员',
                  controller: controller.maintenancePersonController,
                  onChanged: (value) {
                    controller.search.name = value;
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
                    controller.update(['task_creation']);
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
                    controller.update(['task_creation']);
                  },
                )),
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
                    controller.update(['task_creation']);
                  },
                )),
            LineFormLabel(
                label: '点检周期',
                width: 200,
                isExpanded: true,
                child: ComboBox<String>(
                  value: controller.search.inspectionCycle,
                  placeholder: const Text('点检周期'),
                  items: controller.cycleOptionList
                      .map((e) => ComboBoxItem<String>(
                          value: e.value,
                          child: Tooltip(
                            message: e.label,
                            child: Text(e.label!),
                          )))
                      .toList(),
                  onChanged: (value) {
                    controller.search.inspectionCycle = value;
                    controller.update(['task_creation']);
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
                icon: FluentIcons.add,
                label: '新增',
                onPressed: openAddTaskDialog),
            FilledIconButton(
                icon: FluentIcons.search,
                label: '查询',
                onPressed: controller.queryMaintenanceTask),
            FilledIconButton(
                icon: FluentIcons.delete,
                label: '删除',
                onPressed: () {
                  if (controller.stateManager.checkedRows.isEmpty) {
                    PopupMessage.showWarningInfoBar('请选择需要操作的任务');
                    return;
                  }
                  PopupMessage.showConfirmDialog(
                      title: '确认',
                      message: '是否确定删除选中任务？',
                      onConfirm: controller.deleteTask);
                }),
            FilledIconButton(
                icon: FluentIcons.sync_occurence,
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
              title: 'id',
              field: 'id',
              type: PlutoColumnType.text(),
              width: 80,
              enableRowChecked: true,
              enableEditingMode: false),
          PlutoColumn(
            title: '维保类别',
            field: 'maintenanceType',
            type: PlutoColumnType.text(),
            width: 120,
            enableEditingMode: false,
            renderer: (rendererContext) => ThemedText(
                MaintenanceCategory.fromValue(rendererContext.cell.value!)
                    .label),
          ),
          PlutoColumn(
              title: '维保项目',
              field: 'maintenanceProject',
              type: PlutoColumnType.text(),
              width: 120,
              enableEditingMode: false),
          PlutoColumn(
              title: '设备编号',
              field: 'equipmentNo',
              type: PlutoColumnType.text(),
              enableEditingMode: false),
          PlutoColumn(
              title: '维保部位',
              field: 'maintenancePosition',
              type: PlutoColumnType.text(),
              enableEditingMode: false),
          PlutoColumn(
              title: '维保内容',
              field: 'maintenanceContent',
              type: PlutoColumnType.text(),
              enableEditingMode: false),
          PlutoColumn(
              title: '维保标准',
              field: 'maintenanceStandard',
              type: PlutoColumnType.text(),
              enableEditingMode: false),
          PlutoColumn(
              title: '周期',
              field: 'maintenanceCycle',
              type: PlutoColumnType.text(),
              enableEditingMode: false),
          PlutoColumn(
              title: '点检人',
              field: 'maintenancePersonnel',
              type: PlutoColumnType.text(),
              enableEditingMode: false),
          PlutoColumn(
              title: '时间间隔',
              field: 'timeInterval',
              type: PlutoColumnType.text(),
              enableEditingMode: false),
        ],
        rows: controller.rows,
        onLoaded: (event) {
          controller.stateManager = event.stateManager;
          controller.queryMaintenanceTask();
        },
        configuration: globalTheme.plutoGridConfig,
      ),
    );
  }

  // 主视图
  Widget _buildView() {
    return Container(
      padding: globalTheme.pagePadding,
      child: Column(children: [
        _buildTopBar(),
        globalTheme.contentDistance.verticalSpace,
        Expanded(child: _buildTable())
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskCreationController>(
      init: TaskCreationController(),
      id: "task_creation",
      builder: (_) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(),
        );
      },
    );
  }
}
