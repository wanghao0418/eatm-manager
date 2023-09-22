import 'package:eatm_manager/common/components/filled_icon_button.dart';
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/components/themed_text.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:eatm_manager/common/widgets/pop_date_picker.dart';
import 'package:eatm_manager/pages/business/maintenance_system/enum.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:styled_widget/styled_widget.dart';

import 'index.dart';

class HistoryQueryPage extends StatefulWidget {
  const HistoryQueryPage({Key? key}) : super(key: key);

  @override
  State<HistoryQueryPage> createState() => _HistoryQueryPageState();
}

class _HistoryQueryPageState extends State<HistoryQueryPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _HistoryQueryViewGetX();
  }
}

class _HistoryQueryViewGetX extends GetView<HistoryQueryController> {
  const _HistoryQueryViewGetX({Key? key}) : super(key: key);
  GlobalTheme get globalTheme => GlobalTheme.instance;

  // 顶部操作栏
  Widget _buildTopBar() {
    var formRow = Row(
      children: [
        Expanded(
            child: Wrap(spacing: 10, runSpacing: 10, children: [
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
                  controller.update(['history_query']);
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
                  controller.update(['history_query']);
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
                  controller.update(['history_query']);
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
          LineFormLabel(
              label: '完成时间',
              width: 200,
              isExpanded: true,
              child: PopDatePicker(
                value: controller.search.finishTime,
                onChange: (value) {
                  controller.search.finishTime = value;
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
                  controller.resetForm();
                  controller.query();
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
              enableEditingMode: false,
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
            title: '设备编号',
            field: 'equipmentNo',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
          ),
          PlutoColumn(
            title: '维保项目',
            field: 'maintenanceProject',
            type: PlutoColumnType.text(),
            width: 120,
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
            title: '异常说明',
            field: 'exceptionDescription',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
          ),
          PlutoColumn(
            title: '维保人员',
            field: 'maintenancePersonnel',
            type: PlutoColumnType.text(),
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
            title: '开始时间',
            field: 'startTime',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
          ),
          PlutoColumn(
            title: '完成时间',
            field: 'endTime',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
          ),
        ],
        rows: controller.rows,
        onLoaded: (event) {
          controller.stateManager = event.stateManager;
          controller.query();
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
    return GetBuilder<HistoryQueryController>(
      init: HistoryQueryController(),
      id: "history_query",
      builder: (_) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(),
        );
      },
    );
  }
}
