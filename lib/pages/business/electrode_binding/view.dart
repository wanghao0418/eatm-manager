/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-01 10:02:57
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-01 18:12:43
 * @FilePath: /eatm_manager/lib/pages/business/electrode_binding/view.dart
 * @Description: 多电极绑定视图层
 */
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/components/themed_text.dart';
import 'package:eatm_manager/common/components/title_card.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/pages/business/electrode_binding/widgets/clip_binding_table.dart';
import 'package:eatm_manager/pages/business/electrode_binding/widgets/clip_details.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import 'index.dart';

class ElectrodeBindingPage extends StatefulWidget {
  const ElectrodeBindingPage({Key? key}) : super(key: key);

  @override
  State<ElectrodeBindingPage> createState() => _ElectrodeBindingPageState();
}

class _ElectrodeBindingPageState extends State<ElectrodeBindingPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _ElectrodeBindingViewGetX();
  }
}

class _ElectrodeBindingViewGetX extends GetView<ElectrodeBindingController> {
  const _ElectrodeBindingViewGetX({Key? key}) : super(key: key);
  GlobalTheme get globalTheme => GlobalTheme.instance;

  // 打开信息弹窗
  void openInfoDialog() {
    SmartDialog.show(
      tag: 'clipBindingTable',
      keepSingle: true,
      bindPage: true,
      builder: (context) {
        return ContentDialog(
          constraints: BoxConstraints(maxHeight: 800.r, maxWidth: 1200.r),
          title: const Text('绑定').fontSize(18.sp),
          content: ClipBindingTable(
            chipBindDataList: controller.chipBindDataList,
          ),
          actions: [
            Button(
                child: const Text('取消'),
                onPressed: () => SmartDialog.dismiss(tag: 'clipBindingTable')),
            FilledButton(child: const Text('确定'), onPressed: () {})
          ],
        );
      },
    );
  }

  // 操作栏
  Widget _buildActionBar() {
    var barcode = Row(
      children: [
        Expanded(
            child: Wrap(
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            LineFormLabel(
                label: '芯片Id',
                width: 250,
                isExpanded: true,
                child: TextBox(
                  placeholder: '芯片Id',
                  onChanged: (value) {},
                )),
          ],
        ))
      ],
    );

    var buttons = Row(
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            FilledButton(child: const Text('清除数据'), onPressed: () {}),
            FilledButton(child: const Text('解除绑定'), onPressed: () {}),
            FilledButton(child: const Text('一键绑定'), onPressed: () {}),
            FilledButton(child: const Text('显示绑定'), onPressed: () {}),
          ],
        )
      ],
    );

    var limit = Wrap(
      spacing: 10,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.end,
      children: [
        LineFormLabel(
            label: '长*宽*高限制',
            width: 300,
            isExpanded: true,
            child: Wrap(
              spacing: 5,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 50.0,
                  child: NumberBox(
                    value: 120,
                    clearButton: false,
                    mode: SpinButtonPlacementMode.none,
                    onChanged: (value) {},
                  ),
                ),
                const ThemedText('*'),
                SizedBox(
                    width: 50,
                    child: NumberBox(
                      value: 120,
                      clearButton: false,
                      mode: SpinButtonPlacementMode.none,
                      onChanged: (value) {},
                    )),
                const ThemedText('*'),
                SizedBox(
                    width: 50.0,
                    child: NumberBox(
                      value: 120,
                      clearButton: false,
                      mode: SpinButtonPlacementMode.none,
                      onChanged: (value) {},
                    ))
              ],
            )),
        FilledButton(child: Text('设置'), onPressed: () {})
      ],
    );

    return Container(
      decoration: globalTheme.contentDecoration,
      padding: globalTheme.contentPadding,
      child: Column(
        children: [barcode, 10.verticalSpace, buttons],
      ),
    );
  }

  //底部栏
  Widget _buildBottomBar() {
    return Container(
      decoration: globalTheme.contentDecoration,
      padding: globalTheme.contentPadding,
      child: Row(
        children: [
          Expanded(
              child: Wrap(
            spacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              LineFormLabel(
                  label: '托盘编号',
                  width: 300,
                  isExpanded: true,
                  child: TextBox(
                    placeholder: '托盘编号',
                    onChanged: (value) {},
                  )),
              FilledButton(child: const Text('一键绑定'), onPressed: () {}),
              FilledButton(child: const Text('显示绑定'), onPressed: () {}),
            ],
          ))
        ],
      ),
    );
  }

  // 夹具列表
  Widget _buildFixtureList() {
    double spacing = 15.0;
    double runSpacing = 15.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        var width = (constraints.maxWidth - 2 * spacing) / 3;
        var height = (constraints.maxHeight - 2 * spacing) / 3;

        return SingleChildScrollView(
          child: Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            children: List.generate(
                4,
                (index) => Container(
                      width: width,
                      height: height,
                      decoration: globalTheme.contentDecoration,
                      child: HoverButton(
                        cursor: SystemMouseCursors.click,
                        builder: (p0, state) {
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: controller.currentIndex == index
                                    ? Border.all(color: globalTheme.accentColor)
                                    : Border.all(color: Colors.transparent)),
                            child: TitleCard(
                              cardBackgroundColor: state.isHovering
                                  ? globalTheme.accentColor.withOpacity(0.5)
                                  : globalTheme.pageContentBackgroundColor,
                              title: '${index + 1}号夹位',
                              containChild: ClipDetails(),
                            ),
                          );
                        },
                        onPressed: () {
                          if (index != controller.currentIndex) {
                            controller.currentIndex = index;
                            controller.update(['electrode_binding']);
                          }
                          openInfoDialog();
                        },
                      ),
                    )),
          ),
        );
      },
    );
  }

  // 主视图
  Widget _buildView() {
    return Container(
      padding: globalTheme.pagePadding,
      child: Column(
        children: [
          _buildActionBar(),
          globalTheme.contentDistance.verticalSpace,
          Expanded(child: _buildFixtureList()),
          // globalTheme.contentDistance.verticalSpace,
          // _buildBottomBar()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ElectrodeBindingController>(
      init: ElectrodeBindingController(),
      id: "electrode_binding",
      builder: (_) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(),
        );
      },
    );
  }
}
