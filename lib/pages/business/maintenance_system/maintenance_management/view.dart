import 'package:eatm_manager/common/components/filled_icon_button.dart';
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/components/themed_text.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:eatm_manager/common/widgets/tab_box.dart';
import 'package:eatm_manager/pages/business/maintenance_system/maintenance_management/widgets/add_equipment_form.dart';
import 'package:eatm_manager/pages/business/maintenance_system/maintenance_management/widgets/edit_projects_content.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:styled_widget/styled_widget.dart';

import 'index.dart';

class MaintenanceManagementPage extends StatefulWidget {
  const MaintenanceManagementPage({Key? key}) : super(key: key);

  @override
  State<MaintenanceManagementPage> createState() =>
      _MaintenanceManagementPageState();
}

class _MaintenanceManagementPageState extends State<MaintenanceManagementPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _MaintenanceManagementViewGetX();
  }
}

class _MaintenanceManagementViewGetX
    extends GetView<MaintenanceManagementController> {
  const _MaintenanceManagementViewGetX({Key? key}) : super(key: key);
  GlobalTheme get globalTheme => GlobalTheme.instance;

  // 打开新增设备弹窗
  void openAddEquipmentDialog() {
    var key = GlobalKey();
    SmartDialog.show(
      tag: 'add_equipment',
      keepSingle: true,
      bindPage: true,
      builder: (context) {
        return ContentDialog(
          title: const Text('新增设备').fontSize(20.sp),
          constraints: const BoxConstraints(maxWidth: 800, maxHeight: 300),
          content: AddEquipmentForm(
            key: key,
          ),
          actions: [
            Button(
                child: const Text('取消'),
                onPressed: () {
                  SmartDialog.dismiss(tag: 'add_equipment');
                }),
            FilledButton(
                child: const Text('确定'),
                onPressed: () {
                  AddEquipmentFormState state =
                      key.currentState! as AddEquipmentFormState;
                  if (state.confirm() == true) {
                    SmartDialog.dismiss(tag: 'add_equipment');
                    // 新增设备
                    controller.addEquipment(state.addForm.toJson());
                  }
                })
          ],
        );
      },
    );
  }

  // 打开设备项目弹窗
  void openEquipmentItemDialog() {
    var key = GlobalKey();
    SmartDialog.show(
        tag: 'equipment_item',
        keepSingle: true,
        bindPage: true,
        builder: (context) {
          return ContentDialog(
              title: const Text('编辑维保项目').fontSize(20.sp),
              constraints: const BoxConstraints(maxWidth: 800, maxHeight: 500),
              content: EditProjectsContent(key: key),
              actions: [
                Button(
                    child: const Text('取消'),
                    onPressed: () {
                      SmartDialog.dismiss(tag: 'equipment_item');
                    }),
                FilledButton(
                    child: const Text('保存'),
                    onPressed: () async {
                      EditProjectsContentState state =
                          key.currentState! as EditProjectsContentState;
                      if (state.selectedRows.isEmpty) {
                        SmartDialog.dismiss(tag: 'equipment_item');
                      } else {
                        var result = await state.updateMaintainProject();
                        if (result == true) {
                          SmartDialog.dismiss(tag: 'equipment_item');
                          PopupMessage.showSuccessInfoBar('操作成功');
                          controller.getMaintainProject();
                        } else {
                          PopupMessage.showFailInfoBar('操作失败');
                        }
                      }
                    })
              ]);
        });
  }

  Widget _buildTopBar() {
    var formRow = Row(
      children: [
        LineFormLabel(
            label: '设备编号',
            width: 200,
            isExpanded: true,
            child: TextBox(
              placeholder: '设备编号',
              controller: controller.equipmentNoController,
              onChanged: (value) {},
            )),
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
                icon: FluentIcons.search,
                label: '查询',
                onPressed: controller.queryEquipments),
            FilledButton(
              onPressed: openAddEquipmentDialog,
              child: const Text('添加设备'),
            ),
            FilledButton(
                child: const Text('删除设备'),
                onPressed: () {
                  if (controller.equipmentStateManager.checkedRows.length !=
                      1) {
                    PopupMessage.showWarningInfoBar('请选择要删除的设备');
                    return;
                  }
                  controller.deleteEquipment();
                }),
          ],
        ))
      ],
    );

    return Container(
      padding: globalTheme.contentPadding,
      decoration: globalTheme.contentDecoration,
      child: Column(children: [formRow, 10.verticalSpace, buttonRow]),
    );
  }

  // 设备表格
  Widget _buildEquipmentTable() {
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
              title: '设备编号',
              field: 'equipmentNo',
              type: PlutoColumnType.text(),
              enableEditingMode: false),
          PlutoColumn(
              title: '设备名称',
              field: 'equipmentName',
              type: PlutoColumnType.text(),
              enableEditingMode: false),
          PlutoColumn(
              title: '设备类型',
              field: 'equipmentType',
              type: PlutoColumnType.text(),
              enableEditingMode: false),
          PlutoColumn(
              title: '设备型号',
              field: 'equipmentModel',
              type: PlutoColumnType.text(),
              enableEditingMode: false),
          PlutoColumn(
              title: '设备位置',
              field: 'equipmentPosition',
              type: PlutoColumnType.text(),
              enableEditingMode: false),
          PlutoColumn(
              title: '使用部门',
              field: 'userDepartment',
              type: PlutoColumnType.text(),
              enableEditingMode: false)
        ],
        rows: controller.equipmentTableRows,
        onLoaded: (event) {
          controller.equipmentStateManager = event.stateManager;
          controller.queryEquipments();
        },
        onRowChecked: (event) {
          // 单选模式
          if (event.isAll) {
            controller.equipmentStateManager.toggleAllRowChecked(false);
          } else {
            if (event.isChecked == true) {
              controller.equipmentStateManager.toggleAllRowChecked(false);
              controller.equipmentStateManager.setRowChecked(event.row!, true);
            }
          }
        },
        configuration: globalTheme.plutoGridConfig.copyWith(
            columnSize: const PlutoGridColumnSizeConfig(
                autoSizeMode: PlutoAutoSizeMode.scale)),
      ),
    );
  }

  // 下方控制栏
  Widget _buildBottomBar() {
    return Container(
      padding: globalTheme.contentPadding,
      decoration: globalTheme.contentDecoration,
      child: Row(children: [
        Expanded(
            child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            FilledIconButton(
                icon: FluentIcons.search,
                label: '查询',
                onPressed: controller.getMaintainProject),
            FilledButton(
              onPressed: openEquipmentItemDialog,
              child: const Text('设备项目'),
            ),
          ],
        ))
      ]),
    );
  }

  // 设备项目tabView
  Widget _buildEquipmentProjectTabView() {
    return Container(
      padding: globalTheme.contentPadding,
      decoration: globalTheme.contentDecoration,
      child: TabBox(tabList: [
        Tab(text: const Text('保养项目'), body: _buildMaintainTable()),
        Tab(text: const Text('点检项目'), body: _buildSpotCheckTable()),
      ]),
    );
  }

  // 保养项目表格
  Widget _buildMaintainTable() {
    return PlutoGrid(
      columns: [
        PlutoColumn(
            title: 'id',
            field: 'id',
            type: PlutoColumnType.text(),
            width: 80,
            // enableRowChecked: true,
            enableEditingMode: false),
        PlutoColumn(
            title: '保养项目',
            field: 'maintenanceProgram',
            type: PlutoColumnType.text(),
            enableEditingMode: false),
        PlutoColumn(
            title: '保养部位',
            field: 'maintenancePosition',
            type: PlutoColumnType.text(),
            enableEditingMode: false),
        PlutoColumn(
            title: '保养内容',
            field: 'maintenanceContent',
            type: PlutoColumnType.text(),
            enableEditingMode: false),
        PlutoColumn(
            title: '保养标准',
            field: 'maintenanceStandard',
            type: PlutoColumnType.text(),
            enableEditingMode: false),
        PlutoColumn(
            title: '备注',
            field: 'remarks',
            type: PlutoColumnType.text(),
            enableEditingMode: false),
      ],
      rows: controller.maintainRows,
      onLoaded: (event) {
        controller.maintainStateManager = event.stateManager;
        controller.getMaintainProject();
      },
      configuration: globalTheme.plutoGridConfig.copyWith(
          columnSize: const PlutoGridColumnSizeConfig(
              autoSizeMode: PlutoAutoSizeMode.scale)),
    );
  }

  // 点检项目表格
  Widget _buildSpotCheckTable() {
    return PlutoGrid(
      columns: [
        PlutoColumn(
            title: 'id',
            field: 'id',
            type: PlutoColumnType.text(),
            width: 80,
            // enableRowChecked: true,
            enableEditingMode: false),
        PlutoColumn(
            title: '点检项目',
            field: 'maintenanceProgram',
            type: PlutoColumnType.text(),
            enableEditingMode: false),
        PlutoColumn(
            title: '点检部位',
            field: 'maintenancePosition',
            type: PlutoColumnType.text(),
            enableEditingMode: false),
        PlutoColumn(
            title: '点检内容',
            field: 'maintenanceContent',
            type: PlutoColumnType.text(),
            enableEditingMode: false),
        PlutoColumn(
            title: '点检标准',
            field: 'maintenanceStandard',
            type: PlutoColumnType.text(),
            enableEditingMode: false),
        PlutoColumn(
            title: '备注',
            field: 'remarks',
            type: PlutoColumnType.text(),
            enableEditingMode: false),
      ],
      rows: controller.spotCheckRows,
      onLoaded: (event) {
        controller.spotCheckStateManager = event.stateManager;
      },
      configuration: globalTheme.plutoGridConfig.copyWith(
          columnSize: const PlutoGridColumnSizeConfig(
              autoSizeMode: PlutoAutoSizeMode.scale)),
    );
  }

  // 主视图
  Widget _buildView() {
    return Container(
      padding: globalTheme.pagePadding,
      child: Column(children: [
        Expanded(
            child: Column(
          children: [
            _buildTopBar(),
            globalTheme.contentDistance.verticalSpace,
            Expanded(child: _buildEquipmentTable())
          ],
        )),
        globalTheme.contentDistance.verticalSpace,
        Expanded(
            child: Column(
          children: [
            _buildBottomBar(),
            globalTheme.contentDistance.verticalSpace,
            Expanded(child: _buildEquipmentProjectTabView())
          ],
        ))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MaintenanceManagementController>(
      init: MaintenanceManagementController(),
      id: "maintenance_management",
      builder: (_) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(),
        );
      },
    );
  }
}
