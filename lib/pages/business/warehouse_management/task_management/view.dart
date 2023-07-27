/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-27 16:09:22
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-27 16:20:39
 * @FilePath: /eatm_manager/lib/pages/business/warehouse_management/task_management/view.dart
 * @Description: 任务管理视图层
 */
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/widgets/pop_date_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'index.dart';

class TaskManagementPage extends StatefulWidget {
  const TaskManagementPage({Key? key}) : super(key: key);

  @override
  State<TaskManagementPage> createState() => _TaskManagementPageState();
}

class _TaskManagementPageState extends State<TaskManagementPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _TaskManagementViewGetX();
  }
}

class _TaskManagementViewGetX extends GetView<TaskManagementController> {
  const _TaskManagementViewGetX({Key? key}) : super(key: key);
  GlobalTheme get globalTheme => GlobalTheme.instance;

  // 顶部搜索栏
  Widget _buildSearchBar() {
    return Container(
      width: double.infinity,
      decoration: globalTheme.contentDecoration,
      padding: globalTheme.pagePadding,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          // spacing: 10,
          // crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            LineFormLabel(
                label: '时间范围',
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 5,
                  children: [
                    SizedBox(
                        width: 150.0,
                        child: PopDatePicker(
                          value: controller.search.startTime,
                          placeholder: '开始时间',
                          onChange: (value) {
                            print(value);
                            controller.search.startTime = value;
                          },
                        )),
                    Text(
                      '至',
                      style: FluentTheme.of(Get.context!).typography.body,
                    ),
                    SizedBox(
                      width: 150.0,
                      child: PopDatePicker(
                        value: controller.search.endTime,
                        placeholder: '结束时间',
                        onChange: (value) {
                          print(value);
                          controller.search.endTime = value;
                        },
                      ),
                    ),
                  ],
                )),
          ],
        ),
        10.verticalSpace,
        Wrap(
          children: [
            FilledButton(
                child: const Text(
                  '取消任务',
                ),
                onPressed: () {}),
          ],
        ),
      ]),
    );
  }

  Widget _buildTable() {
    return Container(
      decoration: globalTheme.contentDecoration,
      child: PlutoGrid(
          columns: [
            PlutoColumn(
                title: '任务编号',
                field: 'shelfId',
                readOnly: true,
                type: PlutoColumnType.text()),
            PlutoColumn(
                title: '货位号', field: 'shelfType', type: PlutoColumnType.text()),
            PlutoColumn(
                title: '任务类型',
                field: 'shelfColumn',
                type: PlutoColumnType.text()),
            PlutoColumn(
                title: '托盘SN', field: 'shelfRow', type: PlutoColumnType.text()),
            PlutoColumn(
                title: '工件SN',
                field: 'shelfStatus',
                type: PlutoColumnType.text()),
            PlutoColumn(
                title: '工件类型',
                field: 'shelfLocation',
                type: PlutoColumnType.text()),
            PlutoColumn(
                title: '开始时间',
                field: 'shelfRow2',
                type: PlutoColumnType.text()),
            PlutoColumn(
                title: '完成时间', field: 'field1', type: PlutoColumnType.text()),
            PlutoColumn(
                title: '任务状态', field: 'field2', type: PlutoColumnType.text()),
          ],
          rows: [],
          configuration: globalTheme.plutoGridConfig.copyWith(
            columnSize: const PlutoGridColumnSizeConfig(
                autoSizeMode: PlutoAutoSizeMode.scale),
          )),
    );
  }

  // 主视图
  Widget _buildView() {
    return Container(
      padding: globalTheme.pagePadding,
      child: Column(
        children: [
          _buildSearchBar(),
          globalTheme.contentDistance.verticalSpace,
          Expanded(child: _buildTable()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskManagementController>(
      init: TaskManagementController(),
      id: "task_management",
      builder: (_) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(),
        );
      },
    );
  }
}
