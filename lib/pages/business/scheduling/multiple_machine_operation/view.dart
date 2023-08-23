/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-22 09:04:32
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-22 11:18:32
 * @FilePath: /eatm_manager/lib/pages/business/scheduling/multiple_machine_operation/view.dart
 * @Description: 多机负荷视图层
 */
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart' as material;
import 'package:styled_widget/styled_widget.dart';
import 'index.dart';
import 'widgets/machine_warning_card.dart';

class MultipleMachineOperationPage extends StatefulWidget {
  const MultipleMachineOperationPage({Key? key}) : super(key: key);

  @override
  State<MultipleMachineOperationPage> createState() =>
      _MultipleMachineOperationPageState();
}

class _MultipleMachineOperationPageState
    extends State<MultipleMachineOperationPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _MultipleMachineOperationViewGetX();
  }
}

class _MultipleMachineOperationViewGetX
    extends GetView<MultipleMachineOperationController> {
  const _MultipleMachineOperationViewGetX({Key? key}) : super(key: key);
  GlobalTheme get globalTheme => GlobalTheme.instance;

  // 打开设置时间间隔弹窗
  openSettingDialog() {
    var value = controller.duration;
    SmartDialog.show(builder: (context) {
      return ContentDialog(
        title: const Text('机床无人值守预警设置').fontSize(20.sp),
        content: SizedBox(
          width: double.infinity,
          height: 100.r,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('当前可无人值守时长下限: ${controller.duration}小时').fontSize(16.sp),
            const Text('(若不满足时长下限界面将预警提示)')
                .fontSize(12.sp)
                .textColor(const Color(0xFF999999)),
            10.verticalSpacingRadius,
            SizedBox(
              width: 200.0.r,
              child: NumberBox<double>(
                  placeholder: '时长下限设置()/小时',
                  mode: SpinButtonPlacementMode.none,
                  autofocus: true,
                  inputFormatters: [
                    //只允许输入数字
                    // FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.allow(RegExp(
                        r"^(0|\d|1\d|2[0-3]|([0]{1}))(\.([5]){0,1})?$")), //数字包括小数
                  ],
                  value: value,
                  onChanged: (val) {
                    value = val!;
                  }),
            )
          ]),
        ),
        actions: [
          Button(
              onPressed: () {
                SmartDialog.dismiss();
              },
              child: Text('取消')),
          FilledButton(
              onPressed: () {
                controller.duration = value;
                controller.update(['multiple_machine_operation']);
                SmartDialog.dismiss();
              },
              child: Text('确定')),
        ],
      );
    });
  }

  // 主视图
  Widget _buildView() {
    return Padding(
      padding: globalTheme.pagePadding,
      child: Container(
        decoration: globalTheme.contentDecoration,
        padding: globalTheme.contentPadding,
        child: Column(children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                icon: Icon(
                  material.Icons.build_circle,
                  size: 30,
                  color: globalTheme.accentColor,
                ),
                onPressed: openSettingDialog),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                var width = (constraints.maxWidth - 20 - 100.r) / 4;
                // var spacing = (constraints.maxWidth - 20 - 360.r * 4) / 4;
                var height = (constraints.maxHeight - 20 - 20.r) / 2;
                return SingleChildScrollView(
                  child: Container(
                      width: double.infinity,
                      padding: globalTheme.contentPadding,
                      child: Wrap(
                        spacing: 20.r,
                        runSpacing: 20.r,
                        children: controller.machineSchedulingInfoList
                            .map((e) => SizedBox(
                                  width: width,
                                  height: height,
                                  child: MachineWarningCard(
                                      key: ValueKey(e.deviceId),
                                      schedulingData: e,
                                      warningDuration: controller.duration),
                                ))
                            .toList(),
                      )),
                );
              },
            ),
          )
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MultipleMachineOperationController>(
      init: MultipleMachineOperationController(),
      id: "multiple_machine_operation",
      builder: (_) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(),
        );
      },
    );
  }
}
