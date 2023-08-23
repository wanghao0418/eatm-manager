/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-18 17:57:37
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-22 10:27:53
 * @FilePath: /eatm_manager/lib/pages/business/scheduling/single_machine_operation/widgets/scheduling_gantt_chart.dart
 * @Description: 排产甘特图
 */
import 'package:dotted_border/dotted_border.dart';
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/components/themed_text.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/pages/business/scheduling/enum.dart';
import 'package:eatm_manager/pages/business/scheduling/models.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';

class SchedulingGanttChart extends StatefulWidget {
  const SchedulingGanttChart(
      {Key? key,
      required this.deviceName,
      required this.schedulingList,
      required this.deviceStatus})
      : super(key: key);
  final String deviceName;
  final int deviceStatus;
  final List<ProductionOrders?> schedulingList;

  @override
  _SchedulingGanttChartState createState() => _SchedulingGanttChartState();
}

class _SchedulingGanttChartState extends State<SchedulingGanttChart> {
  GlobalTheme get globalTheme => GlobalTheme.instance;
  late DateTime fromDate;
  late DateTime toDate;
  // 时间间隔宽度 (1小时)
  final double _intervalWidth = 150.r;
  final DateFormat _formatter = DateFormat('yyyy-MM-dd hh:mm:ss');

  // 图例
  Widget _buildLegend() {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 10,
        alignment: WrapAlignment.end,
        runSpacing: 10,
        children: SchedulingStatus.values
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
      ),
    );
  }

  // 生成时间间隔
  List<Widget> _buildTimeLines() {
    List<Widget> timeLines = [];
    int viewNum = 24;

    DateTime tempDate = fromDate;
    for (int i = 0; i <= viewNum; i++) {
      timeLines.add(SizedBox(
          width: _intervalWidth,
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
      tempDate = tempDate.add(const Duration(hours: 1));
    }

    return timeLines;
  }

  // 绘制排产
  Widget _buildScheduling() {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: constraints.maxHeight,
        child: Stack(children: [
          Row(
            children: [
              // 时间间隔
              ..._buildTimeLines(),
            ],
          ),
          ...widget.schedulingList.map((e) {
            // 排产开始时间
            DateTime startTime = _formatter.parse(e!.startTime ?? '');
            // 排产结束时间
            DateTime endTime = _formatter.parse(e.endTime ?? '');
            // 排产时长
            int duration = endTime.difference(startTime).inMinutes;
            // 排产开始时间与当前时间的间隔
            int startInterval = startTime.difference(fromDate).inMinutes;
            // 排产结束时间与当前时间的间隔
            // int endInterval = endTime.difference(fromDate).inMinutes;
            // 排产开始时间与当前时间的间隔
            int startIntervalWidth =
                (startInterval / 60 * _intervalWidth).toInt();
            // 排产结束时间与当前时间的间隔
            // int endIntervalWidth = (endInterval / 60 * _intervalWidth).toInt();
            // 排产开始时间与当前时间的间隔
            int durationWidth = (duration / 60 * _intervalWidth).toInt();

            return Positioned(
                left: startIntervalWidth.toDouble() + _intervalWidth / 2,
                top: constraints.maxHeight / 2 - 25.r,
                child: Container(
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
                ));
          }).toList()
        ]),
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
          height: 230.r,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                LineFormLabel(
                    label: '状态',
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
                        Text(SchedulingStatus.fromValue(order.colorNum)!.label)
                            .fontSize(16.sp)
                      ],
                    )),
                LineFormLabel(
                    label: '件号',
                    child: Text(order.partSn ?? '').fontSize(16.sp)),
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

  initDate() {
    var today = DateTime.now();
    // fromDate = DateTime(today.year, today.month, today.day, 0, 0);
    ProductionOrders firstOrder;
    if (widget.schedulingList.isNotEmpty) {
      firstOrder = widget.schedulingList.first!;
    } else {
      firstOrder = ProductionOrders(startTime: today.toString());
    }
    var startTime = _formatter.parse(firstOrder.startTime ?? '');
    fromDate = DateTime(
        startTime.year, startTime.month, startTime.day, startTime.hour, 0);
    toDate = fromDate.add(const Duration(days: 1));
  }

  @override
  void initState() {
    initDate();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SchedulingGanttChart oldWidget) {
    // TODO: implement didUpdateWidget
    initDate();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          _buildLegend(),
          20.verticalSpace,
          Expanded(
              child: Row(
            children: [
              // 运行状态
              Container(
                decoration: BoxDecoration(
                  color: MachineStatus.fromValue(widget.deviceStatus)!.color,
                  //设置四周圆角 角度
                  borderRadius: BorderRadius.all(Radius.circular(5.r)),
                ),
                width: 10.r,
                height: 10.r,
              ),
              5.horizontalSpaceRadius,
              ThemedText(
                widget.deviceName,
                style:
                    TextStyle(fontSize: 18.spMin, fontWeight: FontWeight.bold),
              ),
              5.horizontalSpace,
              Expanded(
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: _buildScheduling()))
            ],
          ))
        ]));
  }
}
