import 'package:eatm_manager/common/components/themed_text.dart';
import 'package:eatm_manager/common/components/title_card.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/pages/business/utilization_statistics/enum.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import 'index.dart';

class UtilizationStatisticsPage extends StatefulWidget {
  const UtilizationStatisticsPage({Key? key}) : super(key: key);

  @override
  State<UtilizationStatisticsPage> createState() =>
      _UtilizationStatisticsPageState();
}

class _UtilizationStatisticsPageState extends State<UtilizationStatisticsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _UtilizationStatisticsViewGetX();
  }
}

class _UtilizationStatisticsViewGetX
    extends GetView<UtilizationStatisticsController> {
  const _UtilizationStatisticsViewGetX({Key? key}) : super(key: key);
  GlobalTheme get globalTheme => GlobalTheme.instance;

  // 设备列表
  Widget _buildEquipmentList() {
    return Container(
      width: 250.r,
      decoration: globalTheme.contentDecoration,
      child: TitleCard(
          title: '设备列表',
          containChild: ListView.builder(
            itemBuilder: (context, index) {
              return ListTile.selectable(
                title: Text(controller.macList[index].machineName!),
                selected:
                    controller.currentMachine == controller.macList[index],
                onPressed: () {
                  if (controller.currentMachine == controller.macList[index]) {
                    return;
                  }
                  controller.currentMachine = controller.macList[index];
                  controller.update(['utilization_statistics']);
                },
              );
            },
            itemCount: controller.macList.length,
          ),
          cardBackgroundColor: globalTheme.pageContentBackgroundColor),
    );
  }

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
            ...EquipmentUtilizations.values
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

  // 图表
  Widget _buildLineChart() {
    return Container(
        decoration: globalTheme.contentDecoration,
        padding: globalTheme.contentPadding,
        child: Column(
          children: [
            _buildLegend(),
            20.verticalSpace,
            Expanded(
              child: Padding(
                  padding: EdgeInsets.only(right: 20.r),
                  child: LineChart(
                    LineChartData(
                      lineTouchData: const LineTouchData(
                        enabled: false,
                      ),
                      gridData: const FlGridData(show: false),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 32,
                            interval: 1,
                            getTitlesWidget: bottomTitleWidgets,
                          ),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            getTitlesWidget: leftTitleWidgets,
                            showTitles: true,
                            interval: 1,
                            reservedSize: 42,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          bottom: BorderSide(
                              color:
                                  globalTheme.buttonIconColor.withOpacity(0.4),
                              width: 2),
                          left: BorderSide(
                              color:
                                  globalTheme.buttonIconColor.withOpacity(0.4),
                              width: 2),
                          right: const BorderSide(color: Colors.transparent),
                          top: const BorderSide(color: Colors.transparent),
                        ),
                      ),
                      lineBarsData: [
                        lineChartBarData2_1,
                        lineChartBarData2_2,
                        lineChartBarData2_3,
                      ],
                      minX: 0,
                      maxX: 24,
                      maxY: 10,
                      minY: 0,
                    ),
                    duration: Duration(milliseconds: 150), // Optional
                    curve: Curves.linear, // Optional
                  )),
            )
          ],
        ));
  }

  LineChartBarData get lineChartBarData2_1 => LineChartBarData(
        isCurved: true,
        // curveSmoothness: 0,
        color: EquipmentUtilizations.availability.color,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: getSpotsList(9, 10),
      );

  LineChartBarData get lineChartBarData2_2 => LineChartBarData(
        isCurved: true,
        color: EquipmentUtilizations.utilization.color,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: EquipmentUtilizations.utilization.color.withOpacity(0.2),
        ),
        spots: getSpotsList(0, 10),
      );

  LineChartBarData get lineChartBarData2_3 => LineChartBarData(
        isCurved: true,
        // curveSmoothness: 0,
        color: EquipmentUtilizations.cuttingRate.color,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
            show: true,
            color: EquipmentUtilizations.cuttingRate.color.withOpacity(0.2)),
        spots: getSpotsList(0, 6.5),
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: globalTheme.buttonIconColor);
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10%';
        break;
      case 2:
        text = '20%';
        break;
      case 3:
        text = '30%';
        break;
      case 4:
        text = '40%';
        break;
      case 5:
        text = '50%';
        break;
      case 6:
        text = '60%';
        break;
      case 7:
        text = '70%';
        break;
      case 8:
        text = '80%';
        break;
      case 9:
        text = '90%';
        break;
      case 10:
        text = '100%';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('00:00', style: style);
        break;
      case 1:
        text = const Text('01:00', style: style);
        break;
      case 2:
        text = const Text('02:00', style: style);
        break;
      case 3:
        text = const Text('03:00', style: style);
        break;
      case 4:
        text = const Text('04:00', style: style);
        break;
      case 5:
        text = const Text('05:00', style: style);
        break;
      case 6:
        text = const Text('06:00', style: style);
        break;
      case 7:
        text = const Text('07:00', style: style);
        break;
      case 8:
        text = const Text('08:00', style: style);
        break;
      case 9:
        text = const Text('09:00', style: style);
        break;
      case 10:
        text = const Text('10:00', style: style);
        break;
      case 11:
        text = const Text('11:00', style: style);
        break;
      case 12:
        text = const Text('12:00', style: style);
        break;
      case 13:
        text = const Text('13:00', style: style);
        break;
      case 14:
        text = const Text('14:00', style: style);
        break;
      case 15:
        text = const Text('15:00', style: style);
        break;
      case 16:
        text = const Text('16:00', style: style);
        break;
      case 17:
        text = const Text('17:00', style: style);
        break;
      case 18:
        text = const Text('18:00', style: style);
        break;
      case 19:
        text = const Text('19:00', style: style);
        break;
      case 20:
        text = const Text('20:00', style: style);
        break;
      case 21:
        text = const Text('21:00', style: style);
        break;
      case 22:
        text = const Text('22:00', style: style);
        break;
      case 23:
        text = const Text('23:00', style: style);
        break;
      case 24:
        text = const Text('24:00', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  // 获取随机点数据
  List<FlSpot> getSpotsList(double min, double max) {
    List<FlSpot> list = [];
    for (var i = 0; i < 25; i++) {
      list.add(FlSpot(i.toDouble(), controller.getRandomDouble(min, max)));
    }
    return list;
  }

  // 主视图
  Widget _buildView() {
    return Container(
      padding: globalTheme.pagePadding,
      child: Row(
        children: [
          _buildEquipmentList(),
          globalTheme.contentDistance.horizontalSpace,
          Expanded(child: _buildLineChart())
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UtilizationStatisticsController>(
      init: UtilizationStatisticsController(),
      id: "utilization_statistics",
      builder: (_) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(),
        );
      },
    );
  }
}
