/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-28 14:09:16
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-29 17:40:33
 * @FilePath: /eatm_manager/lib/pages/business/programming/view.dart
 * @Description: 程式编程视图层
 */
import 'package:eatm_manager/common/components/filled_icon_button.dart';
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/components/title_card.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:eatm_manager/pages/business/programming/widgets/add_steel_form.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:styled_widget/styled_widget.dart';

import 'index.dart';

class ProgrammingPage extends StatefulWidget {
  const ProgrammingPage({Key? key}) : super(key: key);

  @override
  State<ProgrammingPage> createState() => _ProgrammingPageState();
}

class _ProgrammingPageState extends State<ProgrammingPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _ProgrammingViewGetX();
  }
}

class _ProgrammingViewGetX extends GetView<ProgrammingController> {
  const _ProgrammingViewGetX({Key? key}) : super(key: key);
  GlobalTheme get globalTheme => GlobalTheme.instance;

  // 钢件管理点击回调
  void onSteelManagerClick() async {
    PopupMessage.showLoading();
    bool flag = await controller.getSteelEDMData();
    PopupMessage.closeLoading();
    if (flag) {
      var key = GlobalKey();
      SmartDialog.show(
        builder: (context) {
          return ContentDialog(
            title: const Text('添加').fontSize(20),
            constraints: const BoxConstraints(maxWidth: 500),
            content: AddSteelForm(
              key: key,
              steelEDMDataList: controller.steelEDMDataList,
            ),
            actions: [
              Button(
                child: const Text('取消'),
                onPressed: () => SmartDialog.dismiss(),
              ),
              FilledButton(
                child: const Text('保存'),
                onPressed: () {
                  var state = (key.currentState! as AddSteelFormState);
                  if (state.currentSteel == null) {
                    PopupMessage.showWarningInfoBar('请选择钢件');
                    return;
                  }
                  SmartDialog.dismiss();
                  controller.onSteelDataSave(state.currentSteel!);
                },
              ),
            ],
          );
        },
      );
    }
  }

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
                  label: '机台型号',
                  child: ComboBox<String?>(
                    value: controller.currentMachineBand,
                    placeholder: Text('请选择'),
                    items: controller.machineBandOptions
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
                      controller.currentMachineBand = value;
                      controller.update(["programming"]);
                    },
                  )),
              LineFormLabel(
                width: 200,
                isExpanded: true,
                label: '机台编号',
                child: ComboBox(
                  value: controller.currentMachineName,
                  placeholder: Text('请选择'),
                  items: controller.machineNameOptions
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
                    controller.currentMachineName = value;
                    controller.update(["programming"]);
                  },
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
                icon: FluentIcons.add,
                label: '钢件管理',
                onPressed: onSteelManagerClick),
            FilledIconButton(
                icon: FluentIcons.add, label: '放电任务', onPressed: () {}),
          ],
        ))
      ],
    );

    return Container(
      padding: globalTheme.contentPadding,
      decoration: globalTheme.contentDecoration,
      child: Column(children: [
        formItems,
        10.verticalSpace,
        buttons,
      ]),
    );
  }

  // 模号列表
  Widget _buildModelList() {
    return Container(
      width: 200,
      decoration: globalTheme.contentDecoration,
      child: TitleCard(
          cardBackgroundColor: globalTheme.pageContentBackgroundColor,
          title: '模号',
          containChild: Padding(
            padding: globalTheme.contentPadding,
            child: ListView.builder(
              itemCount: controller.showSteelList.length,
              itemBuilder: (context, index) {
                return ListTile.selectable(
                  selected: controller.currentSteelEDMDataIndex == index,
                  title: Text(
                      '模号:${controller.showSteelList[index].steelMouldSN ?? ''}'),
                  onPressed: () {
                    if (controller.currentSteelEDMDataIndex == index) {
                      return;
                    }
                    controller.currentSteelEDMDataIndex = index;
                    controller.getDischargeData();
                    controller.update(["programming"]);
                  },
                );
              },
            ),
          )),
    );
  }

  // 钢件信息表格
  Widget _buildSteelTable() {
    return Container(
      decoration: globalTheme.contentDecoration,
      child: PlutoGrid(
        columns: [
          PlutoColumn(
            title: '序号',
            field: 'index',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            enableRowChecked: true,
            width: 80,
          ),
          PlutoColumn(
            title: '模号',
            field: 'elecMouldsn',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
          ),
          PlutoColumn(
            title: '件号',
            field: 'elecPartsn',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
          ),
          PlutoColumn(
            title: 'SN',
            field: 'elecsn',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
          ),
          PlutoColumn(
            title: '放电类型',
            field: 'elecEdmType',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 100,
          ),
          PlutoColumn(
            title: '标记节点',
            field: 'elecNodeMark',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 100,
          ),
          PlutoColumn(
            title: '摇动方式',
            field: 'shakingMode',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 100,
          ),
          PlutoColumn(
            title: '钢件材质',
            field: 'steelTexture',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 100,
          ),
          PlutoColumn(
            title: '电极材质',
            field: 'elecTexture',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 100,
          ),
          PlutoColumn(
            title: '电极放电间隙',
            field: 'fireNum',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 100,
          ),
          PlutoColumn(
            title: '电极放电规格',
            field: 'elecSpec',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 100,
          ),
          PlutoColumn(
            title: '钢件模号',
            field: 'steelMouldsn',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
          ),
          PlutoColumn(
            title: '钢件件号',
            field: 'steelPartsn',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
          ),
        ],
        rows: controller.dischargeRows,
        onLoaded: (PlutoGridOnLoadedEvent event) {
          controller.dischargeStateManager = event.stateManager;
        },
        configuration: globalTheme.plutoGridConfig,
      ),
    );
  }

  // 钢件跑位信息表格
  Widget _buildSteelOffsetTable() {
    return Container(
      width: 350,
      decoration: globalTheme.contentDecoration,
      child: PlutoGrid(
        columns: [
          // PlutoColumn(
          //   title: '序号',
          //   field: 'index',
          //   type: PlutoColumnType.text(),
          //   enableEditingMode: false,
          //   width: 50,
          // ),
          PlutoColumn(
            title: '跑位X',
            field: 'steelNumber',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
          ),
          PlutoColumn(
            title: '跑位Y',
            field: 'x',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
          ),
          PlutoColumn(
            title: '跑位Z',
            field: 'y',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
          ),
          PlutoColumn(
            title: '跑位角度',
            field: 'z',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
          ),
        ],
        rows: [],
        configuration: globalTheme.plutoGridConfig.copyWith(
            columnSize: PlutoGridColumnSizeConfig(
                autoSizeMode: PlutoAutoSizeMode.scale)),
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
              _buildModelList(),
              globalTheme.contentDistance.horizontalSpace,
              Expanded(child: _buildSteelTable()),
              globalTheme.contentDistance.horizontalSpace,
              _buildSteelOffsetTable(),
            ],
          ),
        ))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProgrammingController>(
      init: ProgrammingController(),
      id: "programming",
      builder: (_) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(),
        );
      },
    );
  }
}
