/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-18 17:57:37
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-18 18:53:09
 * @FilePath: /eatm_manager/lib/pages/business/scheduling/single_machine_operation/widgets/scheduling_gantt_chart.dart
 * @Description: 排产甘特图
 */
import 'package:dotted_border/dotted_border.dart';
import 'package:eatm_manager/common/components/themed_text.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/pages/business/scheduling/single_machine_operation/enum.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';

class SchedulingGanttChart extends StatefulWidget {
  const SchedulingGanttChart({Key? key}) : super(key: key);

  @override
  _SchedulingGanttChartState createState() => _SchedulingGanttChartState();
}

class _SchedulingGanttChartState extends State<SchedulingGanttChart> {
  GlobalTheme get globalTheme => GlobalTheme.instance;
  late DateTime fromDate;
  late DateTime toDate;
  // 时间间隔宽度 (1小时)
  final double _intervalWidth = 150.r;
  DateFormat _formatter = DateFormat('yyyy-MM-dd hh:mm:ss');

  // 图例
  Widget _buildLegend() {
    return Container(
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
                    Text(e.label).fontSize(14.sp)
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
    Path customPath = Path()..lineTo(0, 150);

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
              const SizedBox(
                height: 20,
              ),
              DottedBorder(
                  customPath: (size) => customPath, // PathBuilder
                  color: globalTheme.buttonIconColor,
                  dashPattern: [3, 3],
                  strokeWidth: 1,
                  child: const SizedBox(
                    width: 1,
                    height: 150,
                  ))
            ],
          )));
      tempDate = tempDate.add(Duration(hours: 1));
    }

    return timeLines;
  }

  @override
  void initState() {
    var today = DateTime.now();
    fromDate = DateTime(today.year, today.month, today.day, 0, 0);
    toDate = fromDate.add(const Duration(days: 1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          _buildLegend(),
          10.verticalSpace,
          Row(
            children: [
              ThemedText(
                '机床1',
                style:
                    TextStyle(fontSize: 18.spMin, fontWeight: FontWeight.bold),
              ),
              20.horizontalSpace,
              Expanded(
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [..._buildTimeLines()],
                      )))
            ],
          ),
        ]));
  }
}
