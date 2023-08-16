/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-27 11:32:57
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-15 14:34:44
 * @FilePath: /eatm_manager/lib/pages/business/warehouse_management/storage_records/view.dart
 * @Description: 入库记录视图层
 */
import 'package:eatm_manager/common/components/filled_icon_button.dart';
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/widgets/pop_date_picker.dart';
import 'package:eatm_manager/pages/business/warehouse_management/task_management/enum.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'index.dart';

class ExitStorageRecordsPage extends StatefulWidget {
  const ExitStorageRecordsPage({Key? key}) : super(key: key);

  @override
  State<ExitStorageRecordsPage> createState() => _ExitStorageRecordsPageState();
}

class _ExitStorageRecordsPageState extends State<ExitStorageRecordsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _ExitStorageRecordsViewGetX();
  }
}

class _ExitStorageRecordsViewGetX
    extends GetView<ExitStorageRecordsController> {
  const _ExitStorageRecordsViewGetX({Key? key}) : super(key: key);
  GlobalTheme get globalTheme => GlobalTheme.instance;

  // 顶部搜索栏
  Widget _buildSearchBar() {
    return Container(
      width: double.infinity,
      decoration: globalTheme.contentDecoration,
      padding: globalTheme.pagePadding,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Wrap(
          spacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 10,
          children: [
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
                        print(value);
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
                        print(value);
                        controller.search.endTime = value;
                      },
                    ),
                  ],
                )),
            LineFormLabel(
                label: '操作类型',
                width: 200.0,
                isExpanded: true,
                child: ComboBox<int?>(
                  value: controller.search.operationType,
                  placeholder: const Text(
                    '请选择',
                  ),
                  items: controller.operationTypeList
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
                    controller.search.operationType = value;
                    controller.update(['storage_records']);
                  },
                ))
          ],
        ),
        10.verticalSpace,
        Wrap(
          children: [
            FilledIconButton(
                icon: FluentIcons.search,
                label: '搜索',
                onPressed: controller.query),
          ],
        ),
      ]),
    );
  }

  Widget _buildTable(BuildContext context) {
    return Container(
      decoration: globalTheme.contentDecoration,
      child: PlutoGrid(
          columns: [
            PlutoColumn(
                title: '序号',
                field: 'number',
                width: 80,
                readOnly: true,
                type: PlutoColumnType.text()),
            PlutoColumn(
                title: '任务编号', field: 'taskCode', type: PlutoColumnType.text()),
            PlutoColumn(
                title: '货位号',
                field: 'storageNum',
                readOnly: true,
                type: PlutoColumnType.text()),
            PlutoColumn(
                title: '工件SN',
                field: 'workpieceSN',
                readOnly: true,
                type: PlutoColumnType.text()),
            PlutoColumn(
              title: '操作类型',
              field: 'operationType',
              readOnly: true,
              enableEditingMode: false,
              type: PlutoColumnType.text(),
              renderer: (rendererContext) {
                final val = rendererContext.cell.value;
                return Text(OperationType.fromValue(val)!.label,
                    style: FluentTheme.of(context).typography.body);
              },
            ),
            PlutoColumn(
                title: '开始时间',
                field: 'startTime',
                readOnly: true,
                type: PlutoColumnType.text()),
            PlutoColumn(
              title: '完成时间',
              field: 'endTime',
              type: PlutoColumnType.text(),
              readOnly: true,
            ),
            PlutoColumn(
                title: '托盘类型',
                field: 'trayType',
                readOnly: true,
                type: PlutoColumnType.text()),
          ],
          rows: controller.rows,
          onLoaded: (event) {
            controller.stateManager = event.stateManager;
            controller.query();
          },
          configuration: globalTheme.plutoGridConfig.copyWith(
            columnSize: const PlutoGridColumnSizeConfig(
                autoSizeMode: PlutoAutoSizeMode.scale),
          )),
    );
  }

  // 主视图
  Widget _buildView(BuildContext context) {
    return Container(
      padding: globalTheme.pagePadding,
      child: Column(
        children: [
          _buildSearchBar(),
          globalTheme.contentDistance.verticalSpace,
          Expanded(child: _buildTable(context)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExitStorageRecordsController>(
      init: ExitStorageRecordsController(),
      id: "storage_records",
      builder: (_) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(context),
        );
      },
    );
  }
}
