/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-23 08:58:14
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-23 09:38:31
 * @FilePath: /eatm_manager/lib/pages/business/scheduling/multiple_machine_operation/widgets/tool_warning_bar.dart
 * @Description: 刀具预警柱状图
 */
import 'package:eatm_manager/pages/business/scheduling/models.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ToolWarningBar extends StatefulWidget {
  const ToolWarningBar({Key? key, required this.deviceToolNoArr})
      : super(key: key);
  final List<DeviceToolNoArr> deviceToolNoArr;

  @override
  _ToolWarningBarState createState() => _ToolWarningBarState();
}

class _ToolWarningBarState extends State<ToolWarningBar> {
  List<DeviceToolNoArr> getMinimumLifetimeList() {
    var list = widget.deviceToolNoArr;
    list.sort((a, b) => a.leftTime!.compareTo(b.leftTime!));
    var sortedList = list;
    return (sortedList.length > 3 ? sortedList.sublist(0, 3) : sortedList)
        .reversed
        .toList();
  }

  // 设置最大值
  double setMaxNum(List<DeviceToolNoArr> list) {
    int maxNum = 0;
    for (var i = 0; i < list.length; i++) {
      if (list[i].theoreticalTime! > maxNum) {
        maxNum = list[i].theoreticalTime!;
      }
    }
    return maxNum.toDouble();
  }

  List<CartesianChartAnnotation> buildChartLabel(List<DeviceToolNoArr> list) {
    var maxNum = setMaxNum(list);
    return list
        .map(
          (e) => CartesianChartAnnotation(
              widget: Container(
                  child: Text(
                      e.leftTime == 0
                          ? '${e.usedTime}/${e.theoreticalTime}'
                          : '${e.leftTime}/${e.theoreticalTime}',
                      style: TextStyle(fontSize: 12.spMin))),
              coordinateUnit: CoordinateUnit.point,
              x: e.toolTypeNo,
              y: maxNum * 1.4),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    var toolLIst = getMinimumLifetimeList();

    return Container(
      child: SfCartesianChart(
          primaryXAxis: CategoryAxis(
            axisBorderType: AxisBorderType.rectangle,
            majorGridLines: const MajorGridLines(width: 0),
          ),
          primaryYAxis: NumericAxis(
            maximum: setMaxNum(toolLIst) == 0 ? 20 : setMaxNum(toolLIst) * 1.6,
            isVisible: false,
            majorTickLines: const MajorTickLines(size: 0),
          ),
          annotations: buildChartLabel(toolLIst),
          series: <ChartSeries>[
            StackedBarSeries<DeviceToolNoArr, String>(
                groupName: "Group A",
                dataLabelSettings: DataLabelSettings(
                    isVisible: false, showCumulativeValues: true),
                dataSource: toolLIst,
                xValueMapper: (DeviceToolNoArr data, _) => data.toolTypeNo,
                yValueMapper: (DeviceToolNoArr data, _) => data.leftTime,
                color: Color.fromARGB(255, 130, 228, 121)),
            StackedBarSeries<DeviceToolNoArr, String>(
              groupName: "Group A",
              dataLabelSettings: DataLabelSettings(
                  isVisible: false,
                  showCumulativeValues: true,
                  offset: Offset(40, 0)),
              dataSource: toolLIst,
              xValueMapper: (DeviceToolNoArr data, _) => data.toolTypeNo,
              yValueMapper: (DeviceToolNoArr data, _) =>
                  (data.leftTime == 0 ? 0 : data.usedTime),
              color: Colors.grey[100],
            ),
            StackedBarSeries<DeviceToolNoArr, String>(
              groupName: "Group A",
              dataLabelSettings: DataLabelSettings(
                isVisible: false,
                showCumulativeValues: true,
              ),
              dataSource: toolLIst,
              xValueMapper: (DeviceToolNoArr data, _) => data.toolTypeNo,
              yValueMapper: (DeviceToolNoArr data, _) =>
                  (data.leftTime == 0 ? data.theoreticalTime : 0),
              color: Colors.red.withOpacity(0.7),
            )
          ]),
    );
  }
}
