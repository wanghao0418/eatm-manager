/*
 * @Description: 生产线体控制视图层
 */
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/components/themed_text.dart';
import 'package:eatm_manager/common/components/title_card.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/pages/business/home/enum.dart';
import 'package:eatm_manager/pages/business/production_line_control/widgets/progress_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../dataBoard/line_body.dart';
import 'index.dart';

class ProductionLineControlPage extends StatefulWidget {
  const ProductionLineControlPage({Key? key}) : super(key: key);

  @override
  State<ProductionLineControlPage> createState() =>
      _ProductionLineControlPageState();
}

class _ProductionLineControlPageState extends State<ProductionLineControlPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _ProductionLineControlViewGetX();
  }
}

class _ProductionLineControlViewGetX
    extends GetView<ProductionLineControlController> {
  const _ProductionLineControlViewGetX({Key? key}) : super(key: key);
  GlobalTheme get globalTheme => GlobalTheme.instance;

  // 设备状态
  Widget _buildEquipmentStatusBox() {
    return Container(
      decoration: globalTheme.contentDecoration,
      child: TitleCard(
        cardBackgroundColor: globalTheme.pageContentBackgroundColor,
        title: '设备状态',
        containChild: ListView.builder(
          padding: EdgeInsets.all(5.r),
          itemCount: controller.macRunDataList.length,
          itemBuilder: (context, index) {
            var mac = controller.macRunDataList[index];
            return Expander(
              header: Wrap(
                spacing: 10.r,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    height: 15.r,
                    width: 10.r,
                    color: MachineState.getStatus(mac.machineState!)!.color,
                  ),
                  ThemedText(mac.machineSn!)
                ],
              ),
              content: Column(children: [
                LineFormLabel(
                    label: '运行状态',
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    child:
                        Text(MachineState.getStatus(mac.machineState!)!.label)),
                10.r.verticalSpace,
                LineFormLabel(
                    label: '稼动率',
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    child: Text(mac.utilizationRate!)),
                10.r.verticalSpace,
                LineFormLabel(
                    label: '运行时间',
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    child: Text(mac.statisRunTime!)),
                10.r.verticalSpace,
                LineFormLabel(
                    label: '统计时间',
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    child: Text(mac.statisticalTime!))
              ]),
            );
          },
        ),
      ),
    );
  }

  // 订单进度
  Widget _buildOrderProgressBox() {
    return Container(
      decoration: globalTheme.contentDecoration,
      child: TitleCard(
        cardBackgroundColor: globalTheme.pageContentBackgroundColor,
        title: '加工进度',
        containChild: Padding(
          padding: EdgeInsets.all(10.r),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                  spacing: 5.r,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ThemedText(
                      '已完成',
                      style: TextStyle(fontSize: 14.r),
                    ),
                    Container(
                      width: 20.r,
                      height: 10.r,
                      color: Color.fromARGB(255, 122, 234, 102),
                    ),
                  ],
                ),
                10.r.horizontalSpace,
                Wrap(
                  spacing: 5.r,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ThemedText(
                      '未完成',
                      style: TextStyle(fontSize: 14.r),
                    ),
                    Container(
                      width: 20.r,
                      height: 10.r,
                      color: Color(0xff999999),
                    ),
                  ],
                ),
              ],
            ),
            10.r.verticalSpace,
            Expanded(
                child: ListView.builder(
              itemCount: controller.macOrderList.length,
              itemBuilder: (context, index) {
                var data = controller.macOrderList[index];

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.r),
                  child: LineFormLabel(
                      label: data.machineSn!,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      child: Wrap(
                        spacing: 10.r,
                        alignment: WrapAlignment.end,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Stack(
                            children: [
                              ///灰色线进度条
                              Container(
                                margin: EdgeInsets.only(left: 10.r),
                                height: 13.r,
                                width: 100.r,
                                decoration: BoxDecoration(
                                  color: Color(0xff999999),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),

                              ///蓝色完成任务的进度条
                              Container(
                                margin: EdgeInsets.only(left: 10.r),
                                height: 13.r,
                                width:
                                    (data.completeNum! / data.waitWorkNum!).r *
                                        100,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 122, 234, 102),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                            ],
                          ),
                          10.r.verticalSpace,
                          SizedBox(
                            width: 50.0.r,
                            child: ThemedText(
                              '总数 ${data.waitWorkNum}',
                              style: TextStyle(
                                  fontSize: 14.r,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          )
                        ],
                      )),
                );
              },
            ))
          ]),
        ),
      ),
    );
  }

  // 近期加工图表
  Widget _buildRecentProcessingChart() {
    return Container(
      decoration: globalTheme.contentDecoration,
      child: TitleCard(
        cardBackgroundColor: globalTheme.pageContentBackgroundColor,
        title: '近14天加工',
        containChild: Padding(
          padding: EdgeInsets.all(15.r),
          child: LineChart(
            LineChartData(
              lineTouchData: const LineTouchData(
                enabled: false,
              ),
              gridData: const FlGridData(show: true),
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
                      color: globalTheme.buttonIconColor.withOpacity(0.4),
                      width: 2),
                  left: BorderSide(
                      color: globalTheme.buttonIconColor.withOpacity(0.4),
                      width: 2),
                  right: const BorderSide(color: Colors.transparent),
                  top: const BorderSide(color: Colors.transparent),
                ),
              ),
              lineBarsData: [
                lineChartBarData,
              ],
              minX: 0,
              maxX: 14,
              maxY: 10,
              minY: 0,
            ),
            duration: Duration(milliseconds: 150), // Optional
            curve: Curves.linear, // Optional
          ),
        ),
      ),
    );
  }

  LineChartBarData get lineChartBarData => LineChartBarData(
        isCurved: true,
        // curveSmoothness: 0,
        color: Color.fromARGB(255, 98, 208, 255),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: getSpotsList(0, 10),
      );

  // 获取随机点数据
  List<FlSpot> getSpotsList(double min, double max) {
    List<FlSpot> list = [];
    for (var i = 0; i < 14; i++) {
      list.add(FlSpot(i.toDouble(), controller.getRandomDouble(min, max)));
    }
    return list;
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(fontSize: 14.r, color: globalTheme.buttonIconColor);
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10';
        break;
      case 2:
        text = '20';
        break;
      case 3:
        text = '30';
        break;
      case 4:
        text = '40';
        break;
      case 5:
        text = '50';
        break;
      case 6:
        text = '60';
        break;
      case 7:
        text = '70';
        break;
      case 8:
        text = '80';
        break;
      case 9:
        text = '90';
        break;
      case 10:
        text = '100';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    TextStyle style =
        TextStyle(fontSize: 14.r, color: globalTheme.buttonIconColor);
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text('09-04', style: style);
        break;
      case 1:
        text = Text('09-05', style: style);
        break;
      case 2:
        text = Text('09-06', style: style);
        break;
      case 3:
        text = Text('09-07', style: style);
        break;
      case 4:
        text = Text('09-08', style: style);
        break;
      case 5:
        text = Text('09-09', style: style);
        break;
      case 6:
        text = Text('09-10', style: style);
        break;
      case 7:
        text = Text('09-11', style: style);
        break;
      case 8:
        text = Text('09-12', style: style);
        break;
      case 9:
        text = Text('09-13', style: style);
        break;
      case 10:
        text = Text('09-14', style: style);
        break;
      case 11:
        text = Text('09-15', style: style);
        break;
      case 12:
        text = Text('09-16', style: style);
        break;
      case 13:
        text = Text('09-17', style: style);
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

  // 设备稼动率
  Widget _buildEquipmentUtilizationRateBox() {
    return LayoutBuilder(
      builder: (context, constraints) {
        var height =
            (constraints.maxHeight - 2 * globalTheme.contentDistance.r - 20.r) /
                3;
        return ListView.builder(
          padding: EdgeInsets.all(10.r),
          itemCount: controller.macRunDataList.length,
          itemBuilder: (context, index) {
            var data = controller.macRunDataList[index];
            return Container(
              height: height,
              margin: EdgeInsets.only(bottom: globalTheme.contentDistance.r),
              decoration: globalTheme.contentDecoration,
              child: TitleCard(
                cardBackgroundColor: globalTheme.pageContentBackgroundColor,
                title: '设备稼动率',
                headBorderColor: Colors.transparent,
                containChild: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.r, horizontal: 20.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ThemedText(
                              data.machineSn!,
                              style: TextStyle(
                                  fontSize: 18.r, fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                                child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ThemedText(
                                  '${data.utilizationRate!}%',
                                  style: TextStyle(
                                      fontSize: 24.r,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ))
                          ]),
                      ArcProgressBar(
                        progress: double.tryParse(data.utilizationRate!)!,
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 线体预览图
  Widget _buildLineBodyBox() {
    return Container(
      decoration: globalTheme.contentDecoration,
      child: TitleCard(
          cardBackgroundColor: globalTheme.pageContentBackgroundColor,
          title: '线体预览',
          containChild: LineBody()
          // Container(
          //   decoration: const BoxDecoration(
          //       image: DecorationImage(
          //           fit: BoxFit.cover,
          //           image: AssetImage('/images/dataBoard/line_body.png'))),
          //   child: Stack(children: []),
          // ),
          ),
    );
  }

  // 主视图
  Widget _buildView() {
    return Container(
        padding: globalTheme.pagePadding,
        child: Column(
          children: [
            Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(child: _buildEquipmentStatusBox()),
                    globalTheme.contentDistance.horizontalSpace,
                    Expanded(child: _buildOrderProgressBox()),
                    globalTheme.contentDistance.horizontalSpace,
                    Expanded(flex: 2, child: _buildRecentProcessingChart()),
                  ],
                )),
            globalTheme.contentDistance.verticalSpace,
            Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Expanded(child: _buildEquipmentUtilizationRateBox()),
                    globalTheme.contentDistance.horizontalSpace,
                    Expanded(flex: 3, child: _buildLineBodyBox()),
                  ],
                ))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductionLineControlController>(
      init: ProductionLineControlController(),
      id: "production_line_control",
      builder: (_) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(),
        );
      },
    );
  }
}
