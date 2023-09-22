import 'package:eatm_manager/common/api/maintenance_system_api.dart';
import 'package:eatm_manager/common/components/themed_text.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/utils/http.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:eatm_manager/pages/business/maintenance_system/maintenance_management/controller.dart';
import 'package:eatm_manager/pages/business/maintenance_system/models.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:styled_widget/styled_widget.dart';

class EditProjectsContent extends StatefulWidget {
  const EditProjectsContent({Key? key}) : super(key: key);

  @override
  EditProjectsContentState createState() => EditProjectsContentState();
}

class EditProjectsContentState extends State<EditProjectsContent> {
  GlobalTheme get globalTheme => GlobalTheme.instance;
  // 保养项目
  List<MaintenanceProgram> maintainProjects = [];
  // 点检项目
  List<MaintenanceProgram> spotCheckPrograms = [];
  late PlutoGridStateManager maintainStateManager;
  late PlutoGridStateManager spotCheckStateManager;
  List<PlutoRow> maintainRows = [];
  List<PlutoRow> spotCheckRows = [];
  int currentTabIndex = 0;

  List<PlutoRow> get selectedRows {
    List<PlutoRow> list = maintainStateManager.checkedRows;
    List<PlutoRow> list2 = spotCheckStateManager.checkedRows;
    return [...list, ...list2];
  }

  // 更新维保项目
  Future<bool> updateMaintainProject() async {
    ResponseApiBody res = await MaintenanceSystemApi.updateMaintenanceItem({
      "params": selectedRows
          .map((e) => {
                "ID": e.cells['id']!.value,
                "MaintenanceType": e.cells['maintenanceType']!.value,
                "Item": e.cells['maintenanceProgram']!.value,
                "Part": e.cells['maintenancePosition']!.value,
                "Content": e.cells['maintenanceContent']!.value,
                "Standard": e.cells['maintenanceStandard']!.value,
                "Notes": e.cells['remarks']!.value
              })
          .toList()
    });
    return res.success!;
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
              'maintenanceType': PlutoCell(value: 1),
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
              'maintenanceType': PlutoCell(value: 2),
            }))
        .toList());
    setState(() {});
  }

  // 新加表格行
  void addRow() {
    if (currentTabIndex == 0) {
      maintainStateManager.appendRows([
        PlutoRow(cells: {
          'id': PlutoCell(value: 0),
          'maintenanceProgram': PlutoCell(value: '设备'),
          'maintenancePosition': PlutoCell(value: ''),
          'maintenanceContent': PlutoCell(value: ''),
          'maintenanceStandard': PlutoCell(value: ''),
          'remarks': PlutoCell(value: ''),
          'maintenanceType': PlutoCell(value: 1),
        })
      ]);
    } else {
      spotCheckStateManager.appendRows([
        PlutoRow(cells: {
          'id': PlutoCell(value: 0),
          'maintenanceProgram': PlutoCell(value: '设备'),
          'maintenancePosition': PlutoCell(value: ''),
          'maintenanceContent': PlutoCell(value: ''),
          'maintenanceStandard': PlutoCell(value: ''),
          'remarks': PlutoCell(value: ''),
          'maintenanceType': PlutoCell(value: 2),
        })
      ]);
    }
  }

  // 删除项目
  void deleteProject() {
    if (selectedRows.isEmpty) {
      PopupMessage.showWarningInfoBar('请选择要删除的项目');
      return;
    }
    PopupMessage.showConfirmDialog(
        title: '确认',
        message: '是否确认删除所选项目？',
        onConfirm: () async {
          // 去掉新加行
          maintainStateManager.removeRows(selectedRows
              .where((element) => element.cells['id']!.value == 0)
              .toList());
          spotCheckStateManager.removeRows(selectedRows
              .where((element) => element.cells['id']!.value == 0)
              .toList());
          // 剩下的就是数据库中已有数据
          if (selectedRows.isNotEmpty) {
            // 同步数据并修改状态
            ResponseApiBody res =
                await MaintenanceSystemApi.deleteMaintenanceItem({
              "params": {
                "ID": selectedRows
                    .map((e) => e.cells['id']!.value)
                    .toList()
                    .join(',')
              }
            });
            if (res.success == true) {
              PopupMessage.showSuccessInfoBar('操作成功');
              getMaintainProject();
              MaintenanceManagementController controller =
                  Get.find<MaintenanceManagementController>();
              controller.getMaintainProject();
            } else {
              PopupMessage.showFailInfoBar(res.message as String);
            }
          }
        });
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
            frozen: PlutoColumnFrozen.start,
            enableRowChecked: true,
            enableEditingMode: false),
        PlutoColumn(
          title: '维保项目',
          field: 'maintenanceProgram',
          type: PlutoColumnType.select(['设备', '线体']),
        ),
        PlutoColumn(
          title: '保养部位',
          field: 'maintenancePosition',
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: '保养内容',
          field: 'maintenanceContent',
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: '保养标准',
          field: 'maintenanceStandard',
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: '备注',
          field: 'remarks',
          type: PlutoColumnType.text(),
        ),
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
            frozen: PlutoColumnFrozen.start,
            enableRowChecked: true,
            enableEditingMode: false),
        PlutoColumn(
          title: '维保项目',
          field: 'maintenanceProgram',
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: '点检部位',
          field: 'maintenancePosition',
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: '点检内容',
          field: 'maintenanceContent',
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: '点检标准',
          field: 'maintenanceStandard',
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: '备注',
          field: 'remarks',
          type: PlutoColumnType.text(),
        ),
      ],
      rows: spotCheckRows,
      onLoaded: (event) {
        spotCheckStateManager = event.stateManager;
      },
      configuration: globalTheme.plutoGridConfig,
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
                footer: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 5,
                    children: [
                      IconButton(
                          icon: Icon(
                            FluentIcons.circle_addition_solid,
                            size: 16,
                            color: GlobalTheme.instance.buttonIconColor,
                          ),
                          onPressed: addRow),
                      IconButton(
                          icon: Icon(
                            FluentIcons.delete,
                            size: 16,
                            color: GlobalTheme.instance.buttonIconColor,
                          ),
                          onPressed: deleteProject),
                    ]),
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
    return _buildProjectTab();
  }
}
