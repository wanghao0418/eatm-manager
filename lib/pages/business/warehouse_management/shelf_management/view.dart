/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-25 13:37:07
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-25 18:30:45
 * @FilePath: /eatm_manager/lib/pages/business/warehouse_management/shelf_management/view.dart
 * @Description: 货架管理页面
 */
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/widgets/colorBorder_content_card.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:styled_widget/styled_widget.dart';

import 'index.dart';

class ShelfManagementPage extends StatefulWidget {
  const ShelfManagementPage({Key? key}) : super(key: key);

  @override
  State<ShelfManagementPage> createState() => _ShelfManagementPageState();
}

class _ShelfManagementPageState extends State<ShelfManagementPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _ShelfManagementViewGetX();
  }
}

class _ShelfManagementViewGetX extends GetView<ShelfManagementController> {
  const _ShelfManagementViewGetX({Key? key}) : super(key: key);
  GlobalTheme get globalTheme => GlobalTheme.instance;

  // 头部
  Widget _buildHeader(BuildContext context) {
    // 左侧表单
    var leftForm = Wrap(
      spacing: 10.r,
      runSpacing: 10.r,
      children: [
        SizedBox(
          width: 250.0,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.only(right: 5),
                child: RichText(
                    text: TextSpan(
                  // text: '*',
                  // style: TextStyle(color: Colors.redAccent),
                  children: [
                    TextSpan(
                        text: '工件类型:',
                        style: FluentTheme.of(context).typography.body),
                  ],
                )),
              ),
              10.horizontalSpaceRadius,
              Expanded(
                  child: ComboBox<String>(
                // value: controller.currentMachine,
                isExpanded: true,
                value: controller.shelfManagementForm.artifactType,
                placeholder: Text(
                  '请选择',
                  style: FluentTheme.of(context).typography.body,
                ),
                items: controller.artifactTypeList
                    .map((e) => ComboBoxItem(
                        value: e,
                        child: Tooltip(
                          message: e,
                          child: Text(
                            e,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )))
                    .toList(),

                onChanged: (val) {
                  controller.shelfManagementForm.artifactType = val;
                  controller.update(['shelf_management']);
                },
              ))
            ],
          ),
        ),
        SizedBox(
          width: 250.0,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.only(right: 5),
                child: RichText(
                    text: TextSpan(
                  // text: '*',
                  // style: TextStyle(color: Colors.redAccent),
                  children: [
                    TextSpan(
                        text: '入库类型:',
                        style: FluentTheme.of(context).typography.body),
                  ],
                )),
              ),
              10.horizontalSpaceRadius,
              Expanded(
                  child: ComboBox<String>(
                // value: controller.currentMachine,
                isExpanded: true,
                value: controller.shelfManagementForm.artifactType,
                placeholder: Text(
                  '请选择',
                  style: FluentTheme.of(context).typography.body,
                ),
                items: controller.storageTypeList
                    .map((e) => ComboBoxItem(
                        value: e,
                        child: Tooltip(
                          message: e,
                          child: Text(
                            e,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )))
                    .toList(),

                onChanged: (val) {
                  controller.shelfManagementForm.artifactType = val;
                  controller.update(['shelf_management']);
                },
              ))
            ],
          ),
        ),
        SizedBox(
          width: 250.0,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.only(right: 5),
                child: RichText(
                    text: TextSpan(
                  // text: '*',
                  // style: TextStyle(color: Colors.redAccent),
                  children: [
                    TextSpan(
                        text: 'AGV入库数量:',
                        style: FluentTheme.of(context).typography.body),
                  ],
                )),
              ),
              10.horizontalSpaceRadius,
              Expanded(
                  child: NumberBox<int>(
                mode: SpinButtonPlacementMode.none,
                placeholder: '请输入',
                value: (controller.shelfManagementForm.aGVStorageNum != null &&
                        controller
                            .shelfManagementForm.aGVStorageNum!.isNotEmpty)
                    ? int.tryParse(
                        controller.shelfManagementForm.aGVStorageNum!)
                    : null,
                onChanged: (value) {
                  controller.shelfManagementForm.aGVStorageNum =
                      value != null ? value.toString() : '';
                  // setState(() {});
                },
              ))
            ],
          ),
        ),
      ],
    );
    // 左侧按钮
    var leftButtons = Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10.r,
      runSpacing: 10.r,
      children: [
        FilledButton(child: const Text('托盘入库'), onPressed: () {}),
        FilledButton(child: const Text('托盘出库'), onPressed: () {}),
        FilledButton(child: const Text('工件入库'), onPressed: () {}),
        FilledButton(child: const Text('货位出库'), onPressed: () {}),
        Button(child: const Text('AGV出库'), onPressed: () {}),
        Button(child: const Text('AGV入库'), onPressed: () {}),
        FilledButton(
            child: const Wrap(
              spacing: 5,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(FluentIcons.search),
                Text('搜索'),
              ],
            ),
            onPressed: () {}),
        FilledButton(child: const Text('Excel输出'), onPressed: () {}),
      ],
    );

    // 右侧表单
    var rightForm = SizedBox(
      child: Row(children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 5,
          children: [
            Text('自动出入库开关:', style: FluentTheme.of(context).typography.body),
            ToggleSwitch(
              checked: controller.toggle.value,
              onChanged: (value) {
                controller.toggle.value = value;
                controller.update(['shelf_management']);
              },
            )
          ],
        ),
        10.horizontalSpaceRadius,
        SizedBox(
          width: 150.0,
          child: ComboBox<String>(
            // value: controller.currentMachine,
            isExpanded: true,
            value: controller.currentTask.value,
            placeholder: Text(
              '请选择任务',
              style: FluentTheme.of(context).typography.body,
            ),
            items: controller.taskList
                .map((e) => ComboBoxItem(
                    value: e,
                    child: Tooltip(
                      message: e,
                      child: Text(
                        e,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )))
                .toList(),

            onChanged: (val) {
              controller.currentTask.value = val!;
              controller.update(['shelf_management']);
            },
          ),
        )
      ]),
    );

    // 右侧按钮
    var rightButtons = Wrap(
      spacing: 10.r,
      runSpacing: 10.r,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        FilledButton(
            child: const Text('暂停'),
            onPressed: () {},
            style: ButtonStyle().copyWith(
              backgroundColor: ButtonState.all(Colors.red),
            )),
        FilledButton(
            child: const Text('继续'),
            onPressed: () {},
            style: ButtonStyle().copyWith(
              backgroundColor: ButtonState.all(Colors.successPrimaryColor),
            )),
        FilledButton(
            child: const Text('执行任务'),
            onPressed: () {},
            style: ButtonStyle().copyWith(
              backgroundColor: ButtonState.all(Colors.blue),
            )),
      ],
    );

    return Container(
        decoration: BoxDecoration(
            color: globalTheme.pageContentBackgroundColor,
            borderRadius: globalTheme.contentRadius,
            boxShadow: [globalTheme.boxShadow]),
        padding: globalTheme.pagePadding,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: leftForm),
                20.horizontalSpaceRadius,
                rightForm
              ],
            ),
            10.verticalSpacingRadius,
            Row(
              children: [
                Expanded(child: leftButtons),
                20.horizontalSpaceRadius,
                rightButtons
              ],
            ),
          ],
        ));
  }

  // 底部导航栏
  Widget _buildBottomBar(BuildContext context) {
    return Card(
        padding: const EdgeInsets.all(10),
        child: Container(
          height: 40,
          child: Row(
            children: [
              Expanded(
                  child: Text(
                '提示信息:',
                style: FluentTheme.of(context).typography.body,
              )),
              Expanded(
                  child: Text(
                'AGV状态:',
                style: FluentTheme.of(context).typography.body,
              )),
            ],
          ),
        ));
  }

  // 内容
  Widget _buildContent(BuildContext context) {
    // 货架列表侧边栏
    var shelfList = Container(
      decoration: globalTheme.contentDecoration,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: 150.0,
        child: Column(children: [
          Text(
            '全部货架',
            style: FluentTheme.of(context).typography.bodyLarge,
          ).fontSize(16).fontWeight(FontWeight.bold),
          10.verticalSpace,
          const Divider(),
          10.verticalSpace,
          Expanded(
              child: ListView.builder(
            itemCount: controller.shelfList.length,
            itemBuilder: (context, index) {
              var item = controller.shelfList[index];
              return ListTile.selectable(
                selected: controller.currentShelf.value == item,
                title: Text(item ?? ''),
                onPressed: () {
                  controller.currentShelf.value = item;
                  controller.update(['shelf_management']);
                },
              );
            },
          ))
        ]),
      ),
    );

    // 货架表格
    var shelfTable = Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: globalTheme.pageContentBackgroundColor,
          borderRadius: globalTheme.contentRadius,
          boxShadow: [globalTheme.boxShadow]),
      child: PlutoGrid(
        columns: [
          PlutoColumn(
              title: '序号',
              field: 'shelfId',
              width: 60,
              readOnly: true,
              type: PlutoColumnType.text()),
          PlutoColumn(
              title: '货位号', field: 'shelfName', type: PlutoColumnType.text()),
          PlutoColumn(
              title: '托盘SN', field: 'shelfType', type: PlutoColumnType.text()),
          PlutoColumn(
              title: '托盘芯片',
              field: 'shelfStatus',
              type: PlutoColumnType.text()),
          PlutoColumn(
              title: '工件SN',
              field: 'shelfLocation',
              type: PlutoColumnType.text()),
          PlutoColumn(
              title: '工件类型', field: 'shelfLayer', type: PlutoColumnType.text()),
          PlutoColumn(
              title: '托盘类型',
              field: 'shelfColumn',
              type: PlutoColumnType.text()),
          PlutoColumn(
              title: '托盘重量', field: 'shelfRow', type: PlutoColumnType.text()),
          PlutoColumn(
              title: '更新时间', field: 'shelfRow2', type: PlutoColumnType.text()),
          PlutoColumn(
              title: '禁用', field: 'shelfRow3', type: PlutoColumnType.text()),
          PlutoColumn(
              title: '当前状态', field: 'shelfRow4', type: PlutoColumnType.text()),
        ],
        rows: controller.rows,
        onLoaded: (PlutoGridOnLoadedEvent event) {
          controller.stateManager = event.stateManager;
        },
        onRowChecked: (event) {
          print(event);
        },
        configuration: PlutoGridConfiguration(
          localeText: const PlutoGridLocaleText.china(),
          columnSize: const PlutoGridColumnSizeConfig(
              autoSizeMode: PlutoAutoSizeMode.scale),
          style: PlutoGridStyleConfig(
            gridBorderColor: Colors.transparent,
            gridBackgroundColor: globalTheme.pageContentBackgroundColor,
            columnTextStyle: FluentTheme.of(context).typography.body!,
            iconColor: globalTheme.buttonIconColor,
          ),
        ),
      ),
    );

    return Container(
      child: Row(
        children: [
          shelfList,
          globalTheme.contentDistance.horizontalSpace,
          Expanded(child: shelfTable)
        ],
      ),
    );
  }

  // 主视图
  Widget _buildView(BuildContext context) {
    return Padding(
        padding: globalTheme.pagePadding,
        child: Column(
          children: [
            _buildHeader(context),
            globalTheme.contentDistance.verticalSpace,
            Expanded(child: _buildContent(context)),
            globalTheme.contentDistance.verticalSpace,
            _buildBottomBar(context)
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShelfManagementController>(
      init: ShelfManagementController(),
      id: "shelf_management",
      builder: (_) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(context),
        );
      },
    );
  }
}
