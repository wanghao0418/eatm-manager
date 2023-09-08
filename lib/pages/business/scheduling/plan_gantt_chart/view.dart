/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-21 14:33:18
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-05 10:47:40
 * @FilePath: /eatm_manager/lib/pages/business/scheduling/plan_gantt_chart/view.dart
 * @Description: 甘特图视图层
 */
import 'package:dotted_border/dotted_border.dart';
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/components/themed_text.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/pages/business/scheduling/enum.dart';
import 'package:eatm_manager/pages/business/scheduling/models.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'index.dart';
import 'package:intl/intl.dart';

class PlanGanttChartPage extends StatefulWidget {
  const PlanGanttChartPage({Key? key}) : super(key: key);

  @override
  State<PlanGanttChartPage> createState() => _PlanGanttChartPageState();
}

class _PlanGanttChartPageState extends State<PlanGanttChartPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _PlanGanttChartViewGetX();
  }
}

// ignore: must_be_immutable
class _PlanGanttChartViewGetX extends GetView<PlanGanttChartController> {
  const _PlanGanttChartViewGetX({Key? key}) : super(key: key);
  GlobalTheme get globalTheme => GlobalTheme.instance;

  // 打开设置时间间隔弹窗
  openSettingDialog() {
    var value = controller.interval;
    SmartDialog.show(builder: (context) {
      return ContentDialog(
        title: const Text('时间间隔设置').fontSize(20.sp),
        content: SizedBox(
          width: double.infinity,
          height: 100.r,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('时间间隔: ${controller.interval}小时(最小0.5)'),
            10.verticalSpacingRadius,
            SizedBox(
              width: 200.0.r,
              child: NumberBox<double>(
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
                controller.interval = value;
                controller.update(['plan_gantt_chart']);
                SmartDialog.dismiss();
              },
              child: Text('确定')),
        ],
      );
    });
  }

  // 查看当前排产详情
  openSchedulingDetail(ProductionOrders order) {
    SmartDialog.show(builder: (context) {
      return ContentDialog(
        title: const Text('排产详情').fontSize(20.sp),
        constraints: BoxConstraints(maxWidth: 600.r),
        content: SizedBox(
          width: double.infinity,
          height: 250.r,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                LineFormLabel(
                    label: '提示',
                    child: Wrap(
                      spacing: 5.r,
                      children: [
                        Container(
                          width: 20.r,
                          height: 20.r,
                          color:
                              SchedulingStatus.fromValue(order.colorNum)!.color,
                        ).decorated(
                            borderRadius: BorderRadius.circular(2.r),
                            border: Border.all(color: Colors.grey, width: 1)),
                        Text(order.tipContext ?? '').fontSize(16.sp)
                      ],
                    )),
                LineFormLabel(
                    label: '件号',
                    child: Text(order.partSn ?? '').fontSize(16.sp)),
                LineFormLabel(
                    label: '计划机床',
                    child: Text(order.planMachineName ?? '').fontSize(16.sp)),
                LineFormLabel(
                    label: '模号',
                    child: Text(order.mouldSn ?? '').fontSize(16.sp)),
                LineFormLabel(
                    label: '计划开始时间',
                    child: Text(order.startTime ?? '').fontSize(16.sp)),
                LineFormLabel(
                    label: '计划结束时间',
                    child: Text(order.endTime ?? '').fontSize(16.sp)),
                LineFormLabel(
                    label: '工件名称',
                    child: Text(order.workpieceSn ?? '').fontSize(16.sp)),
              ]),
        ),
        actions: [
          FilledButton(
              onPressed: () {
                SmartDialog.dismiss();
              },
              child: const Text('确定')),
        ],
      );
    });
  }

  // 图例
  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ThemedText(
          '当前设置时间间隔${controller.interval}小时',
          style: TextStyle(fontSize: 16.sp),
        ),
        Wrap(
          spacing: 10,
          alignment: WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 10,
          children: [
            ...SchedulingStatus.values
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
            IconButton(
                icon: Icon(
                  material.Icons.build_circle,
                  size: 30,
                  color: globalTheme.accentColor,
                ),
                onPressed: openSettingDialog)
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
        children: controller.machineSchedulingInfoList
            .map((e) => SizedBox(
                  height: 50.0.r,
                  child: Row(
                    children: [
                      Icon(FluentIcons.connect_virtual_machine,
                          size: 20.r,
                          color: MachineStatus.fromValue(e.deviceInlineStatus)!
                              .color),
                      5.horizontalSpaceRadius,
                      // 运行状态
                      Container(
                        decoration: BoxDecoration(
                          color: MachineStatus.fromValue(e.deviceInlineStatus)!
                              .color,
                          //设置四周圆角 角度
                          borderRadius: BorderRadius.all(Radius.circular(5.r)),
                        ),
                        width: 10.r,
                        height: 10.r,
                      ),

                      5.horizontalSpaceRadius,
                      ThemedText(
                        e.plant ?? '',
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
  List<Widget> _buildTimeLines(BuildContext context) {
    List<Widget> timeLines = [];

    DateTime tempDate = controller.fromDate;
    for (int i = 0; i <= controller.viewNum; i++) {
      timeLines.add(SizedBox(
          width: controller.intervalWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(DateFormat('MM/dd HH:mm').format(tempDate),
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
      tempDate =
          tempDate.add(Duration(minutes: (controller.interval * 60).toInt()));
    }

    return timeLines;
  }

  // 绘制排产
  Widget _buildScheduling(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: constraints.maxHeight,
        child: Stack(children: [
          Row(
            children: [
              // 时间间隔
              ..._buildTimeLines(context),
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
                    children: controller.machineSchedulingInfoList
                        .map((e) => _buildSingleMacScheduling(e.list ?? []))
                        .toList()),
              )),
        ]),
      );
    });
  }

  // 绘制单机床排产
  Widget _buildSingleMacScheduling(List<ProductionOrders> schedulingList) {
    // 计算时间
    DateTime calculateTime = controller.fromDate;

    return Padding(
      padding:
          EdgeInsets.only(left: (controller.intervalWidth / 2).ceilToDouble()),
      child: Row(
        children: schedulingList.map((e) {
          // 排产开始时间
          DateTime startTime = DateTime.parse(e.startTime ?? '');
          // 排产结束时间
          DateTime endTime = DateTime.parse(e.endTime ?? '');

          // 排产时长
          int duration = endTime.difference(startTime).inMinutes;
          // 排产开始时间与当前时间的间隔
          int startInterval = startTime.difference(calculateTime).inMinutes;

          calculateTime = endTime;

          // 排产结束时间与当前时间的间隔
          // int endInterval = endTime.difference(fromDate).inMinutes;
          // 排产开始时间与当前时间的间隔
          int startIntervalWidth = startInterval /
              60 *
              controller.intervalWidth ~/
              controller.interval;
          // 排产结束时间与当前时间的间隔
          // int endIntervalWidth = (endInterval / 60 * _intervalWidth).toInt();
          // 排产开始时间与当前时间的间隔
          int durationWidth =
              duration / 60 * controller.intervalWidth ~/ controller.interval;

          return Container(
            margin: EdgeInsets.only(left: startIntervalWidth.toDouble()),
            width: durationWidth.toDouble(),
            height: 50.r,
            decoration: BoxDecoration(
              color: SchedulingStatus.fromValue(e.colorNum)!.color,
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(5.r)),
            ),
            child: Tooltip(
              message:
                  "模号：${e.mouldSn}\n开始时间：${e.startTime}\n结束时间：${e.endTime}",
              child: Button(
                child: Center(
                  child: ThemedText(
                    e.partSn ?? '',
                    style: TextStyle(
                        fontSize: 14.spMin,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
                onPressed: () => openSchedulingDetail(e),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // 主视图
  Widget _buildView(BuildContext context) {
    return Container(
        padding: globalTheme.pagePadding,
        child: Column(children: [
          Expanded(
            child: Container(
                decoration: globalTheme.contentDecoration,
                padding: globalTheme.contentPadding,
                child: Column(children: [
                  _buildLegend(),
                  20.verticalSpace,
                  Expanded(
                    child: Row(children: [
                      _buildMacList(),
                      5.horizontalSpace,
                      Expanded(
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: _buildScheduling(context)))
                    ]),
                  )
                ])),
          )
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlanGanttChartController>(
      init: PlanGanttChartController(),
      id: "plan_gantt_chart",
      builder: (_) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(context),
        );
      },
    );
  }
}
