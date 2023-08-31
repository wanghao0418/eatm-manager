/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-30 10:32:45
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-31 13:55:04
 * @FilePath: /eatm_manager/lib/pages/business/discharge/edm_task/view.dart
 * @Description: 放电任务视图层
 */

import 'package:eatm_manager/common/components/filled_icon_button.dart';
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/components/themed_text.dart';
import 'package:eatm_manager/common/components/title_card.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/utils/log.dart';
import 'package:eatm_manager/pages/business/discharge/edm_task/enum.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'index.dart';

class EdmTaskPage extends StatefulWidget {
  const EdmTaskPage({Key? key}) : super(key: key);

  @override
  State<EdmTaskPage> createState() => _EdmTaskPageState();
}

class _EdmTaskPageState extends State<EdmTaskPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _EdmTaskViewGetX();
  }
}

class _EdmTaskViewGetX extends GetView<EdmTaskController> {
  const _EdmTaskViewGetX({Key? key}) : super(key: key);
  GlobalTheme get globalTheme => GlobalTheme.instance;

  // 顶部搜索栏
  Widget _buildSearchBar() {
    var formItems = Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              LineFormLabel(
                  width: 200,
                  isExpanded: true,
                  label: '任务状态',
                  child: ComboBox<String?>(
                    value: controller.currentTaskState,
                    placeholder: const Text('请选择'),
                    items: controller.taskStateOptions
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
                      controller.currentTaskState = value;
                      controller.update(["programming"]);
                    },
                  )),
              LineFormLabel(
                width: 200,
                isExpanded: true,
                label: '任务编号',
                child: TextBox(
                  placeholder: '任务编号',
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
        )
      ],
    );
    var buttons = Row(
      children: [
        Expanded(
            child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            FilledIconButton(
                icon: FluentIcons.play_solid,
                label: '任务开始',
                onPressed: () =>
                    controller.updateTaskState(EdmTaskState.processing)),
            FilledIconButton(
                icon: FluentIcons.pause,
                label: '任务暂停',
                onPressed: () =>
                    controller.updateTaskState(EdmTaskState.pause)),
            FilledIconButton(
                icon: FluentIcons.cancel,
                label: '任务取消',
                onPressed: () =>
                    controller.updateTaskState(EdmTaskState.cancel)),
            FilledIconButton(
                icon: FluentIcons.delete,
                label: '删除任务',
                onPressed: controller.onDeleteTask),
          ],
        ))
      ],
    );

    return Container(
      padding: globalTheme.contentPadding,
      decoration: globalTheme.contentDecoration,
      child: Column(children: [
        // formItems,
        // 10.verticalSpace,
        buttons,
      ]),
    );
  }

  // 机台任务列表
  Widget _buildFixtureTypeList() {
    return Container(
      width: 250,
      decoration: globalTheme.contentDecoration,
      child: TitleCard(
          cardBackgroundColor: globalTheme.pageContentBackgroundColor,
          title: '机台编号',
          containChild: Padding(
            padding: globalTheme.contentPadding,
            child: ListView.separated(
              separatorBuilder: (context, index) => 10.r.verticalSpace,
              itemCount: controller.fixtureTypeList.length,
              itemBuilder: (context, index) {
                var fixture = controller.fixtureTypeList[index];
                return Button(
                    style: controller.currentName == fixture
                        ? ButtonStyle(
                            border: ButtonState.all(BorderSide(
                            color: globalTheme.accentColor,
                          )))
                        : null,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 85,
                            color: Colors.green,
                          ),
                        ),
                        Expanded(
                          flex: 9,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const ThemedText('机台编号：'),
                                    ThemedText(
                                      fixture,
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const ThemedText('当前任务：'),
                                    ThemedText(
                                      controller
                                          .fixtureTypeMap[fixture]!['taskId']
                                          .toString(),
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const ThemedText('任务状态：'),
                                    ThemedText(
                                      controller.fixtureTypeMap[fixture]![
                                          'taskState'],
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      controller.onMacTaskSelect(fixture);
                    });
              },
            ),
          )),
    );
  }

  // 上方表格
  Widget _buildUpTable() {
    return Container(
      decoration: globalTheme.contentDecoration,
      child: PlutoGrid(
        columns: [
          PlutoColumn(
              title: '勾选',
              field: 'isChecked',
              type: PlutoColumnType.text(),
              minWidth: 85,
              width: 85,
              readOnly: true,
              enableEditingMode: false,
              frozen: PlutoColumnFrozen.start,
              renderer: (rendererContext) {
                var rowIndex = rendererContext.row.cells['index']!.value;

                return Center(
                  child: SizedBox(
                    width: 20.0,
                    height: 20,
                    child: Checkbox(
                        checked: controller.selectedTaskRowIndex == rowIndex,
                        onChanged: (val) {
                          controller.selectedTaskRowIndex =
                              val == true ? rowIndex : null;
                          controller.taskManager.toggleAllRowChecked(false);

                          if (val == true) {
                            controller.taskManager.setRowChecked(
                                rendererContext.row, val!,
                                notify: true);
                            var taskId =
                                rendererContext.row.cells['edmTaskId']!.value;
                            var fixture =
                                rendererContext.row.cells['fixtureType']!.value;
                            controller.fixtureTypeMap[fixture]!['taskId'] =
                                taskId;
                            controller.loadInfoData(taskId);
                          } else {
                            controller.infoRows.clear();
                          }
                          controller.update(['edm_task']);
                        }),
                  ),
                );
              }),
          PlutoColumn(
            title: '序号',
            field: 'index',
            type: PlutoColumnType.number(),
            width: 50,
            hide: true,
            enableEditingMode: false,
          ),
          PlutoColumn(
            title: '任务编号',
            field: 'edmTaskId',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
          ),
          PlutoColumn(
            title: '任务状态',
            field: 'taskState',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
          ),
          PlutoColumn(
            title: '创建时间',
            field: 'createTime',
            type: PlutoColumnType.time(),
            enableEditingMode: false,
          ),
          PlutoColumn(
            title: '任务创建者',
            field: 'creator',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
          ),
          PlutoColumn(
            title: '状态改变时间',
            field: 'stateChangeTime',
            type: PlutoColumnType.time(),
            enableEditingMode: false,
          ),
          PlutoColumn(
            title: '状态改变人',
            field: 'stateChanger',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
          ),
          PlutoColumn(
            title: '钢件编号',
            field: 'steelMouldSN',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
          ),
        ],
        rows: controller.taskRows,
        onLoaded: (event) {
          controller.taskManager = event.stateManager;
        },
        onRowChecked: (event) {
          LogUtil.t(event.isRow);
          LogUtil.t(event.isAll);
          LogUtil.t(event.row);
          // 单选
          if (event.isRow) {
            if (event.isChecked == true) {}
          } else if (event.isAll) {}
        },
        configuration: globalTheme.plutoGridConfig,
      ),
    );
  }

  // 下方表格
  Widget _buildDownTable() {
    return Container(
      decoration: globalTheme.contentDecoration,
      child: PlutoGrid(
        columns: [
          PlutoColumn(
            title: '电极模号',
            field: 'elecMouldSN',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
          ),
          PlutoColumn(
            title: '电极件号',
            field: 'elecPartSN',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
          ),
          PlutoColumn(
            title: '放电顺序',
            field: 'dischargeOrder',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
          ),
          PlutoColumn(
            title: '当前状态',
            field: 'curState',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
          ),
          PlutoColumn(
            title: '状态改变人',
            field: 'stateChangeAuthor',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
          ),
          PlutoColumn(
            title: '开始时间',
            field: 'startTime',
            type: PlutoColumnType.time(),
            enableEditingMode: false,
          ),
          PlutoColumn(
            title: '结束时间',
            field: 'endTime',
            type: PlutoColumnType.time(),
            enableEditingMode: false,
          ),
        ],
        rows: controller.infoRows,
        onLoaded: (event) {
          controller.infoManager = event.stateManager;
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
        _buildSearchBar(),
        globalTheme.contentDistance.verticalSpace,
        Expanded(
            child: Container(
          child: Row(
            children: [
              _buildFixtureTypeList(),
              globalTheme.contentDistance.horizontalSpace,
              Expanded(
                  child: Column(
                children: [
                  Expanded(child: _buildUpTable()),
                  globalTheme.contentDistance.verticalSpace,
                  Expanded(child: _buildDownTable())
                ],
              ))
            ],
          ),
        ))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EdmTaskController>(
      init: EdmTaskController(),
      id: "edm_task",
      builder: (_) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(),
        );
      },
    );
  }
}
