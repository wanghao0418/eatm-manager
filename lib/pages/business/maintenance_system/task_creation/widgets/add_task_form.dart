import 'package:date_format/date_format.dart';
import 'package:eatm_manager/common/api/maintenance_system_api.dart';
import 'package:eatm_manager/common/components/themed_text.dart';
import 'package:eatm_manager/common/models/selectOption.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/utils/http.dart';
import 'package:eatm_manager/common/utils/log.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:eatm_manager/common/widgets/pop_date_picker.dart';
import 'package:eatm_manager/pages/business/maintenance_system/models.dart';
import 'package:eatm_manager/pages/business/maintenance_system/task_creation/models.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:styled_widget/styled_widget.dart';

class AddTaskForm extends StatefulWidget {
  const AddTaskForm({Key? key}) : super(key: key);

  @override
  AddTaskFormState createState() => AddTaskFormState();
}

class AddTaskFormState extends State<AddTaskForm> {
  GlobalTheme get globalTheme => GlobalTheme.instance;
  // 设备编号
  List<SelectOption> equipmentOptionList = [];
  MaintenanceTaskAdd addForm = MaintenanceTaskAdd(
      reminderInterval: 5,
      createTime: formatDate(
          DateTime.now(), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]));
  int currentTabIndex = 0;
  // 保养项目
  List<MaintenanceProgram> maintainProjects = [];
  // 点检项目
  List<MaintenanceProgram> spotCheckPrograms = [];
  late PlutoGridStateManager maintainStateManager;
  late PlutoGridStateManager spotCheckStateManager;
  List<PlutoRow> maintainRows = [];
  List<PlutoRow> spotCheckRows = [];
  late material.PageController pageController;

  // 确认
  bool confirm() {
    if (addForm.validate() == false) {
      PopupMessage.showWarningInfoBar('请确认必选项');
      return false;
    }
    var ids = [];
    if (maintainStateManager.checkedRows.isNotEmpty) {
      ids.addAll(
          maintainStateManager.checkedRows.map((e) => e.cells['id']!.value));
    }
    if (spotCheckStateManager.checkedRows.isNotEmpty) {
      ids.addAll(
          spotCheckStateManager.checkedRows.map((e) => e.cells['id']!.value));
    }
    if (ids.isEmpty) {
      PopupMessage.showWarningInfoBar('请选择项目');
      return false;
    } else {
      addForm.projectID = ids.join(',');
    }
    return true;
  }

  // 获取设备列表
  void getEquipmentList() async {
    ResponseApiBody res = await MaintenanceSystemApi.queryEquipmentList();
    if (res.success!) {
      equipmentOptionList = (res.data as List).map((e) {
        return SelectOption(label: e['equipmentNo'], value: e['equipmentNo']);
      }).toList();
      setState(() {});
    }
  }

  // 获取维保项目
  void getMaintainProject() async {
    ResponseApiBody res = await MaintenanceSystemApi.queryMaintenanceItem();
    if (res.success!) {
      setState(() {
        maintainProjects = (res.data['maintenance'] as List)
            .map((e) => MaintenanceProgram.fromJson(e))
            .toList();
        spotCheckPrograms = (res.data['spotCheck'] as List)
            .map((e) => MaintenanceProgram.fromJson(e))
            .toList();
        updateRows();
      });
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 更新表格
  void updateRows() {
    maintainRows.clear();
    spotCheckRows.clear();
    maintainStateManager.appendRows(maintainProjects
        .map((e) => PlutoRow(cells: {
              'id': PlutoCell(value: e.id),
              'maintenanceProgram': PlutoCell(value: e.maintenanceProgram),
              'maintenancePosition': PlutoCell(value: e.maintenancePosition),
              'maintenanceContent': PlutoCell(value: e.maintenanceContent),
              'maintenanceStandard': PlutoCell(value: e.maintenanceStandard),
              'remarks': PlutoCell(value: e.remarks),
            }))
        .toList());
    spotCheckStateManager.appendRows(spotCheckPrograms
        .map((e) => PlutoRow(cells: {
              'id': PlutoCell(value: e.id),
              'maintenanceProgram': PlutoCell(value: e.maintenanceProgram),
              'maintenancePosition': PlutoCell(value: e.maintenancePosition),
              'maintenanceContent': PlutoCell(value: e.maintenanceContent),
              'maintenanceStandard': PlutoCell(value: e.maintenanceStandard),
              'remarks': PlutoCell(value: e.remarks),
            }))
        .toList());
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getEquipmentList();
    super.initState();
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
            enableRowChecked: true,
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
      rows: maintainRows,
      onLoaded: (event) {
        maintainStateManager = event.stateManager;
        getMaintainProject();
      },
      configuration: globalTheme.plutoGridConfig,
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
            enableRowChecked: true,
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
      rows: spotCheckRows,
      onLoaded: (event) {
        spotCheckStateManager = event.stateManager;
      },
      configuration: globalTheme.plutoGridConfig,
    );
  }

  Widget _buildTopForm() {
    return Row(
      children: [
        Expanded(
            child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            InfoLabel(
                label: '设备编号:',
                child: SizedBox(
                  width: 200.0,
                  child: ComboBox<String>(
                    placeholder: const Text('设备编号'),
                    value: addForm.deviceNum,
                    items: equipmentOptionList
                        .map((e) => ComboBoxItem<String>(
                            value: e.value,
                            child: Tooltip(
                              message: e.label,
                              child: Text(e.label!),
                            )))
                        .toList(),
                    onChanged: (value) {
                      addForm.deviceNum = value;
                      setState(() {});
                    },
                  ),
                )),
            InfoLabel.rich(
                label: TextSpan(children: [
                  TextSpan(text: '*').textColor(Colors.red),
                  TextSpan(text: '设备名称:'),
                ]),
                child: SizedBox(
                  width: 200,
                  child: TextBox(
                    placeholder: '维保人员',
                    onChanged: (value) {
                      addForm.name = value;
                    },
                  ),
                )),
            InfoLabel(
                label: '提醒时间间隔(分钟):',
                child: SizedBox(
                  width: 200,
                  child: NumberBox(
                    mode: SpinButtonPlacementMode.none,
                    value: addForm.reminderInterval,
                    placeholder: '提醒时间间隔',
                    onChanged: (value) {
                      addForm.reminderInterval = value;
                    },
                  ),
                )),
            InfoLabel.rich(
                label: TextSpan(children: [
                  TextSpan(text: '*').textColor(Colors.red),
                  TextSpan(text: '保养周期:'),
                ]),
                child: SizedBox(
                  width: 200,
                  child: ComboBox<String>(
                    value: addForm.inspectionCycle,
                    placeholder: const Text('保养周期'),
                    items: [
                      SelectOption(label: '日', value: '日'),
                      SelectOption(label: '周', value: '周'),
                      SelectOption(label: '月', value: '月'),
                    ]
                        .map((e) => ComboBoxItem<String>(
                            value: e.value,
                            child: Tooltip(
                              message: e.label,
                              child: Text(e.label!),
                            )))
                        .toList(),
                    onChanged: (value) {
                      addForm.inspectionCycle = value;
                      setState(() {});
                    },
                  ),
                )),
            InfoLabel(
              label: '创建时间:',
              child: SizedBox(
                width: 200,
                child: PopDatePicker(
                  pickTime: true,
                  value: addForm.createTime,
                  onChange: (dateStr) {
                    addForm.createTime = dateStr;
                  },
                  dateFormat: const [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn],
                ),
              ),
            )
          ],
        ))
      ],
    );
  }

  Widget _buildNoteRow() {
    return Row(
      children: [
        Expanded(
          child: InfoLabel(
            label: '备注:',
            child: TextBox(
              minLines: 5,
              maxLines: 5,
              placeholder: '备注',
              onChanged: (value) {
                addForm.notes = value;
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _buildProjectTab() {
    return FluentTheme(
      data: FluentThemeData(
          resources: globalTheme.isDarkMode
              ? ResourceDictionary.dark(
                  solidBackgroundFillColorTertiary: globalTheme.accentColor)
              : ResourceDictionary.light(
                  solidBackgroundFillColorTertiary: globalTheme.accentColor)),
      child: Column(
        children: [
          SizedBox(
            height: 38.5,
            child: TabView(
                tabWidthBehavior: TabWidthBehavior.sizeToContent,
                closeButtonVisibility: CloseButtonVisibilityMode.never,
                currentIndex: currentTabIndex,
                onChanged: (value) {
                  setState(() {
                    currentTabIndex = value;
                  });
                },
                tabs: [
                  Tab(
                      icon: null,
                      text: ThemedText(
                        '保养项目',
                        style: TextStyle(
                            fontWeight:
                                currentTabIndex == 0 ? FontWeight.bold : null,
                            decorationColor: Colors.white,
                            decoration: currentTabIndex == 0
                                ? TextDecoration.underline
                                : TextDecoration.none,
                            color: currentTabIndex == 0 ? Colors.white : null),
                      ),
                      body: Container()),
                  Tab(
                      icon: null,
                      text: ThemedText(
                        '点检项目',
                        style: TextStyle(
                            fontWeight:
                                currentTabIndex == 1 ? FontWeight.bold : null,
                            decorationColor: Colors.white,
                            decoration: currentTabIndex == 1
                                ? TextDecoration.underline
                                : TextDecoration.none,
                            color: currentTabIndex == 1 ? Colors.white : null),
                      ),
                      body: Container())
                ]),
          ),
          Expanded(
              child: IndexedStack(
            index: currentTabIndex,
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                child: _buildMaintainTable(),
              ).border(all: 1, color: globalTheme.accentColor),
              Container(
                padding: EdgeInsets.all(10.r),
                child: _buildSpotCheckTable(),
              ).border(all: 1, color: globalTheme.accentColor)
            ],
          ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _buildTopForm(),
      10.verticalSpace,
      _buildNoteRow(),
      10.verticalSpace,
      Expanded(child: _buildProjectTab())
    ]);
  }
}
