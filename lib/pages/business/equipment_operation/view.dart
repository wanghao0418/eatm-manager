/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-08 17:14:16
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-11 09:58:55
 * @FilePath: /eatm_manager/lib/pages/business/equipment_operation/view.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:dotted_border/dotted_border.dart';
import 'package:eatm_manager/common/components/hover_float.dart';
import 'package:eatm_manager/common/components/themed_text.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/pages/business/equipment_operation/enum.dart';
import 'package:eatm_manager/pages/business/equipment_operation/models.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:intl/intl.dart';

import 'index.dart';

class EquipmentOperationPage extends StatefulWidget {
  const EquipmentOperationPage({Key? key}) : super(key: key);

  @override
  State<EquipmentOperationPage> createState() => _EquipmentOperationPageState();
}

class _EquipmentOperationPageState extends State<EquipmentOperationPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _EquipmentOperationViewGetX();
  }
}

class _EquipmentOperationViewGetX
    extends GetView<EquipmentOperationController> {
  const _EquipmentOperationViewGetX({Key? key}) : super(key: key);
  GlobalTheme get globalTheme => GlobalTheme.instance;

  // 图例
  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Wrap(
          spacing: 10,
          alignment: WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 10,
          children: [
            ...EquipmentRunStatus.values
                .map((e) => Wrap(
                      children: [
                        Container(
                          width: 20.r,
                          height: 20.r,
                          color: e.color,
                        ).decorated(
                            borderRadius: BorderRadius.circular(2.r),
                            border: Border.all(color: Colors.grey, width: 1)),
                        const SizedBox(
                          width: 10,
                        ),
                        ThemedText(e.label, style: TextStyle(fontSize: 14.sp))
                      ],
                    ))
                .toList(),
          ],
        )
      ],
    );
  }

  // 机床列表
  Widget _buildMacList() {
    return Padding(
      padding: EdgeInsets.only(top: 35.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: controller.equipmentRunMap.keys
            .map((e) => SizedBox(
                  height: 50.0.r,
                  child: Row(
                    children: [
                      Icon(FluentIcons.connect_virtual_machine,
                          size: 20.r, color: globalTheme.buttonIconColor),
                      5.horizontalSpaceRadius,
                      ThemedText(
                        e,
                        style: TextStyle(
                            fontSize: 18.spMin, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  // 生成时间间隔
  List<Widget> _buildTimeLines(BuildContext context, double maxWidth) {
    List<Widget> timeLines = [];
    var hourWidth = (maxWidth / 25).floor().toDouble();
    DateTime now = DateTime.now();
    DateTime tempDate = DateTime.parse(
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}');
    for (int i = 0; i <= 24; i++) {
      timeLines.add(SizedBox(
          width: hourWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(DateFormat('HH:mm').format(tempDate),
                      textAlign: TextAlign.center,
                      style: FluentTheme.of(context).typography.caption!)
                  .fontSize(14.sp),
              20.verticalSpacingRadius,
              Expanded(
                  child: DottedBorder(
                      customPath: (size) =>
                          Path()..lineTo(0, size.height), // PathBuilder
                      color: globalTheme.buttonIconColor,
                      dashPattern: [3, 3],
                      strokeWidth: 1,
                      child: const SizedBox(
                        width: 1,
                        height: double.infinity,
                      )))
            ],
          )));
      // 间隔时间
      tempDate = tempDate.add(Duration(minutes: (60).toInt()));
    }

    return timeLines;
  }

  // 图表
  Widget _buildChart() {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: constraints.maxHeight,
        child: Stack(children: [
          Row(
            children: [
              // 时间间隔
              ..._buildTimeLines(context, constraints.maxWidth),
            ],
          ),
          Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: EdgeInsets.only(top: 35.r),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: controller.equipmentRunMap.values
                        .map((e) => _buildSingleMacRun(e, constraints.maxWidth))
                        .toList()),
              )),
        ]),
      );
    });
  }

  // 单机运行状态
  Widget _buildSingleMacRun(
      List<EquipmentRunStatusData> list, double maxWidth) {
    var hourWidth = (maxWidth / 25).floor().toDouble();
    return Container(
      width: double.infinity,
      height: 50.r,
      padding: EdgeInsets.only(left: (hourWidth / 2)),
      child: Row(children: [
        Expanded(
            child: Stack(
          children: list.map((e) {
            // 开始时间
            DateTime startTime = DateTime.parse(e.startTime ?? '');
            // 结束时间
            DateTime endTime = DateTime.parse(e.endTime ?? '');

            DateTime now = DateTime.now();
            DateTime tempDate = DateTime.parse(
                '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}');

            double left =
                startTime.difference(tempDate).inMinutes / 60 * hourWidth;

            // 时长
            int duration = endTime.difference(startTime).inMinutes;

            double durationWidth = duration / 60 * hourWidth;

            return duration > 0
                ? Positioned(
                    left: left,
                    width: durationWidth.toDouble(),
                    height: 50.r,
                    child: Tooltip(
                      message:
                          "开始时间：${e.startTime}\n结束时间：${e.endTime}\n状态：${EquipmentRunStatus.findByStatus(int.parse(e.state!))!.label}",
                      child: HoverEffectWidget(
                          child: Container(
                        color: EquipmentRunStatus.findByStatus(
                                int.parse(e.state!))!
                            .color,
                        // child: Center(
                        //   child: ThemedText(
                        //     e.state ?? '',
                        //     style: TextStyle(
                        //         fontSize: 14.spMin,
                        //         fontWeight: FontWeight.bold,
                        //         overflow: TextOverflow.ellipsis),
                        //   ),
                        // ),
                      )),
                    ),
                  )
                : Container();
          }).toList(),
        ))
      ]),
    );
  }

  // 主视图
  Widget _buildView() {
    return Container(
      padding: globalTheme.pagePadding,
      child: Container(
        decoration: globalTheme.contentDecoration,
        padding: globalTheme.contentPadding,
        child: Column(
          children: [
            _buildLegend(),
            20.verticalSpace,
            Expanded(
              child: Row(children: [
                _buildMacList(),
                5.horizontalSpace,
                Expanded(child: _buildChart())
              ]),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EquipmentOperationController>(
      init: EquipmentOperationController(),
      id: "equipment_operation",
      builder: (_) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(),
        );
      },
    );
  }
}
