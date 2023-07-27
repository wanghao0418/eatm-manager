/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-27 11:32:57
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-27 16:39:51
 * @FilePath: /eatm_manager/lib/pages/business/warehouse_management/storage_records/view.dart
 * @Description: 入库记录视图层
 */
import 'package:eatm_manager/common/components/filled_icon_button.dart';
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/widgets/pop_date_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'index.dart';

class StorageRecordsPage extends StatefulWidget {
  const StorageRecordsPage({Key? key}) : super(key: key);

  @override
  State<StorageRecordsPage> createState() => _StorageRecordsPageState();
}

class _StorageRecordsPageState extends State<StorageRecordsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _StorageRecordsViewGetX();
  }
}

class _StorageRecordsViewGetX extends GetView<StorageRecordsController> {
  const _StorageRecordsViewGetX({Key? key}) : super(key: key);
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
            10.horizontalSpace,
            LineFormLabel(
              label: '托盘类型',
              child: SizedBox(
                  width: 150.0,
                  child: ComboBox<String>(
                    value: controller.search.palletType,
                    placeholder: Text(
                      '请选择',
                      style: FluentTheme.of(Get.context!).typography.body,
                    ),
                    items: controller.palletTypeList
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
                    onChanged: (value) {
                      controller.search.palletType = value;
                      controller.update(['storage_records']);
                    },
                  )),
            )
          ],
        ),
        10.verticalSpace,
        Wrap(
          children: [
            FilledIconButton(
                icon: FluentIcons.search,
                label: '搜索',
                onPressed: () {
                  print(controller.search.toJson());
                }),
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
                title: '序号',
                field: 'shelfId',
                width: 80,
                readOnly: true,
                type: PlutoColumnType.text()),
            PlutoColumn(
                title: '托盘SN',
                field: 'shelfType',
                type: PlutoColumnType.text()),
            PlutoColumn(
                title: '托盘类型',
                field: 'shelfColumn',
                type: PlutoColumnType.text()),
            PlutoColumn(
                title: '托盘重量', field: 'shelfRow', type: PlutoColumnType.text()),
            PlutoColumn(
                title: '数量',
                field: 'shelfStatus',
                type: PlutoColumnType.text()),
            PlutoColumn(
                title: '入库用户',
                field: 'shelfLocation',
                type: PlutoColumnType.text()),
            PlutoColumn(
                title: '入库时间',
                field: 'shelfRow2',
                width: 300,
                type: PlutoColumnType.text()),
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
    return GetBuilder<StorageRecordsController>(
      init: StorageRecordsController(),
      id: "storage_records",
      builder: (_) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(),
        );
      },
    );
  }
}
