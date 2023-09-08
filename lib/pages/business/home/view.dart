/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-06 10:37:03
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-08 15:28:01
 * @FilePath: /eatm_manager/lib/pages/business/home/view.dart
 * @Description: 首页视图层
 */
import 'package:card_swiper/card_swiper.dart';
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/components/themed_text.dart';
import 'package:eatm_manager/common/components/title_card.dart';
import 'package:eatm_manager/common/models/userInfo.dart';
import 'package:eatm_manager/common/store/index.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/utils/get_storage.dart';
import 'package:eatm_manager/common/utils/log.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:eatm_manager/common/utils/router.dart';
import 'package:eatm_manager/pages/business/home/enum.dart';
import 'package:eatm_manager/pages/business/home/models.dart';
import 'package:eatm_manager/pages/business/home/widgets/fast_entry.dart';
import 'package:eatm_manager/pages/business/home/widgets/visit_history.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'index.dart';
import 'widgets/edit_fast_entry.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _HomeViewGetX();
  }
}

class _HomeViewGetX extends GetView<HomeController> {
  const _HomeViewGetX({Key? key}) : super(key: key);
  GlobalTheme get globalTheme => GlobalTheme.instance;

  // 用户信息
  Widget _buildUserInfo() {
    UserInfo user = UserStore.instance.getCurrentUserInfo();

    // 头像
    Widget avatar = Container(
      width: 50.r,
      height: 50.r,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage('assets/images/user/default_avatar.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );

    // 昵称
    Widget nickName = ThemedText(
      '${user.userName != '' ? user.userName : 'hello'}，${controller.isMorning ? '上午' : '下午'}好！',
      style: TextStyle(fontSize: 20.sp, color: const Color(0xff666666)),
    );
    var now = DateTime.now();
    var dateStr = DateFormat('yyyy/MM/dd').format(now);

    // 日期
    Widget date = ThemedText(
      dateStr,
      style: TextStyle(fontSize: 14.sp, color: const Color(0xff999999)),
    );

    String weekdayName = DateFormat('EEEE', 'zh_CN').format(now);

    // 星期
    Widget weekday = ThemedText(
      weekdayName,
      style: TextStyle(fontSize: 14.sp, color: const Color(0xff999999)),
    );

    return Container(
      padding: globalTheme.contentPadding,
      child: Row(
        children: [
          Expanded(
              child: Wrap(
            spacing: 10.r,
            runSpacing: 10.r,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [avatar, nickName, date, weekday],
          ))
        ],
      ),
    );
  }

  // 线体状态
  Widget _buildLineBodyStatus() {
    return Container(
      decoration: globalTheme.contentDecoration,
      height: 200.h,
      child: TitleCard(
        title: '线体概况',
        headPadding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 5.r),
        cardBackgroundColor: globalTheme.pageContentBackgroundColor,
        titleRight: Row(
          children: [
            ThemedText(
              '平均稼动率 ${controller.averageUtilizationRate}%',
              style: const TextStyle(fontSize: 14),
            ),
            5.r.horizontalSpace,
            IconButton(
                icon: Icon(
                  FluentIcons.go_to_dashboard,
                  size: 16,
                  color: globalTheme.buttonIconColor,
                ),
                onPressed: () => RouterUtils.jumpToChildPage('/dataBoard'))
          ],
        ),
        containChild: Container(
          padding: globalTheme.contentPadding,
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: controller.macRunDataList.map((e) {
                var status = MachineState.getStatus(e.machineState ?? -1);
                bool isLast = e == controller.macRunDataList.last;
                return Container(
                  width: 200.r,
                  margin: isLast ? null : EdgeInsets.only(right: 10.r),
                  child: TitleCard(
                      cardBackgroundColor: globalTheme.isDarkMode
                          ? Color(0xff181818)
                          : Color.fromARGB(255, 235, 234, 234),
                      headBorderColor: Colors.transparent,
                      headPadding:
                          EdgeInsets.symmetric(horizontal: 5.r, vertical: 5.r),
                      title: e.machineSn ?? '',
                      titleRight: Card(
                          padding: EdgeInsets.all(5.r),
                          backgroundColor: status?.color ?? Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                status!.icon,
                                size: 18.r,
                              ),
                              10.horizontalSpaceRadius,
                              Text(status.label)
                                  .fontSize(14.sp)
                                  .fontWeight(FontWeight.bold),
                            ],
                          )),
                      containChild: Padding(
                        padding: globalTheme.contentPadding,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return SizedBox(
                              height: constraints.maxHeight,
                              width: constraints.maxHeight,
                              child: Stack(children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: ProgressRing(
                                    strokeWidth: 8.5.r,
                                    value: double.tryParse(
                                        e.utilizationRate ?? '0'),
                                    activeColor: getChartColor(double.tryParse(
                                        (e.utilizationRate != '' &&
                                                e.utilizationRate != null)
                                            ? e.utilizationRate!
                                            : '0')!),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: ThemedText(
                                      '${e.utilizationRate ?? '0'}%',
                                      style: TextStyle(fontSize: 14.r),
                                    ),
                                  ),
                                )
                              ]),
                            );
                          },
                        ),
                      )),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  // 获取环形图颜色
  Color getChartColor(double percentage) {
    switch (percentage) {
      case >= 80:
        return Color.fromARGB(255, 103, 252, 86);
      case >= 60:
        return Color.fromARGB(255, 244, 255, 99);
      default:
        return Color(0xffFF5963);
    }
  }

  // 今日任务数
  Widget _buildTodayTaskNum() {
    return Container(
      decoration: globalTheme.contentDecoration,
      child: TitleCard(
        title: '今日任务',
        cardBackgroundColor: globalTheme.pageContentBackgroundColor,
        containChild: Padding(
          padding: EdgeInsets.all(5.r),
          child: LayoutBuilder(
            builder: (context, constraints) {
              int lineCount = 2;
              int columnCount = 3;
              double spacing = 10.r;
              double width =
                  ((constraints.maxWidth - spacing * (lineCount - 1)) /
                          lineCount)
                      .floorToDouble();
              double height =
                  ((constraints.maxHeight - spacing * (columnCount - 1)) /
                          columnCount)
                      .floorToDouble();

              return SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    Container(
                      height: height,
                      width: width,

                      padding: EdgeInsets.symmetric(horizontal: 5.r),
                      // color: globalTheme.accentColor.withAlpha(50),
                      child: LineFormLabel(
                          label: '加工',
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          child: ThemedText(
                              controller.todayMacTaskNum?.cncTotal.toString() ??
                                  '')),
                    ),
                    Container(
                      width: width,

                      height: height,
                      padding: EdgeInsets.symmetric(horizontal: 5.r),

                      // color: globalTheme.accentColor.withAlpha(50),
                      child: LineFormLabel(
                          label: '放电',
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          child: ThemedText(
                              controller.todayMacTaskNum?.edmTotal.toString() ??
                                  '')),
                    ),
                    Container(
                      height: height,
                      width: width,

                      padding: EdgeInsets.symmetric(horizontal: 5.r),

                      // color: globalTheme.accentColor.withAlpha(50),
                      child: LineFormLabel(
                          label: '检测',
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          child: ThemedText(
                              controller.todayMacTaskNum?.cmmTotal.toString() ??
                                  '')),
                    ),
                    Container(
                      height: height,
                      width: width,

                      padding: EdgeInsets.symmetric(horizontal: 5.r),

                      // color: globalTheme.accentColor.withAlpha(50),
                      child: LineFormLabel(
                          label: '清洗',
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          child: ThemedText(controller
                                  .todayMacTaskNum?.cleanTotal
                                  .toString() ??
                              '')),
                    ),
                    Container(
                      height: height,
                      width: width,

                      padding: EdgeInsets.symmetric(horizontal: 5.r),

                      // color: globalTheme.accentColor.withAlpha(50),
                      child: LineFormLabel(
                          label: '烘干',
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          child: ThemedText(
                              controller.todayMacTaskNum?.dryTotal.toString() ??
                                  '')),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTodayTaskNum2() {
    return Container(
      decoration: globalTheme.contentDecoration,
      child: TitleCard(
          title: '今日任务',
          cardBackgroundColor: globalTheme.pageContentBackgroundColor,
          containChild: SfCircularChart(
              legend: Legend(position: LegendPosition.top, isVisible: true),
              tooltipBehavior: TooltipBehavior(enable: true),
              centerY: 100.r.toString(),
              palette: [
                Colors.green.lightest,
                Colors.blue.lightest,
                Colors.yellow.lightest,
                Colors.teal.lightest,
                Colors.orange.lightest
              ],
              series: [
                DoughnutSeries<ChartSampleData, String>(
                    startAngle: -90,
                    endAngle: 90,
                    explode: true,
                    radius: 100.r.toString(),
                    dataSource: [
                      ChartSampleData(
                          x: '加工',
                          y: int.parse(
                            controller.todayMacTaskNum?.cncTotal ?? '0',
                          ),
                          text:
                              '加工:${controller.todayMacTaskNum?.cncTotal ?? '0'}'),
                      ChartSampleData(
                          x: '放电',
                          y: int.parse(
                              controller.todayMacTaskNum?.edmTotal ?? '0'),
                          text:
                              '放电:${controller.todayMacTaskNum?.edmTotal ?? '0'}'),
                      ChartSampleData(
                          x: '检测',
                          y: int.parse(
                              controller.todayMacTaskNum?.cmmTotal ?? '0'),
                          text:
                              '检测:${controller.todayMacTaskNum?.cmmTotal ?? '0'}'),
                      ChartSampleData(
                          x: '清洗',
                          y: int.parse(
                              controller.todayMacTaskNum?.cleanTotal ?? '0'),
                          text:
                              '清洗:${controller.todayMacTaskNum?.cleanTotal ?? '0'}'),
                      ChartSampleData(
                          x: '烘干',
                          y: int.parse(
                              controller.todayMacTaskNum?.dryTotal ?? '0'),
                          text:
                              '烘干:${controller.todayMacTaskNum?.dryTotal ?? '0'}'),
                    ],
                    xValueMapper: (ChartSampleData data, _) => data.x,
                    yValueMapper: (ChartSampleData data, _) => data.y,
                    dataLabelMapper: (ChartSampleData data, _) => data.text,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                    name: '任务数')
              ])),
    );
  }

  // 累计任务数
  Widget _buildGrandTaskTotal() {
    return Container(
      decoration: globalTheme.contentDecoration,
      child: TitleCard(
        title: '累计完成任务',
        cardBackgroundColor: globalTheme.pageContentBackgroundColor,
        containChild: controller.totalTaskNumMap.isNotEmpty
            ? Container(
                // padding: EdgeInsets.all(10.r),
                child: Swiper(
                itemCount: controller.totalTaskNumMap.length,
                indicatorLayout: PageIndicatorLayout.COLOR,
                autoplay: true,
                pagination: SwiperPagination(margin: EdgeInsets.all(5.r)),
                control:
                    SwiperControl(size: 20, color: globalTheme.accentColor),
                itemBuilder: (context, index) {
                  var e = controller.totalTaskNumMap.entries.toList()[index];
                  return Card(
                      padding: EdgeInsets.all(10.r),
                      child: Row(
                        children: [
                          SizedBox(
                            height: double.infinity,
                            child: ThemedText(
                              e.key,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.r),
                            ),
                          ),
                          5.r.horizontalSpace,
                          Expanded(child: _buildTaskPieChart(e.value.first))
                        ],
                      ));
                },
              ))
            : Container(),
      ),
    );
  }

  // 生成累计任务扇形图
  SfCircularChart _buildTaskPieChart(CompletedNumData data) {
    return SfCircularChart(
      // title: ChartTitle(text: 'Sales by sales person'),
      legend: Legend(isVisible: true),
      series: <PieSeries<ChartSampleData, String>>[
        PieSeries<ChartSampleData, String>(
            explode: true,
            explodeIndex: 0,
            explodeOffset: '5%',
            dataSource: <ChartSampleData>[
              ChartSampleData(
                x: '加工',
                y: data.numberCompletedCNC ?? 0,
                text: '加工:${data.numberCompletedCNC ?? 0}',
              ),
              ChartSampleData(
                  x: '放电',
                  y: data.numberCompletedEDM ?? 0,
                  text: '放电:${data.numberCompletedEDM ?? 0}'),
              ChartSampleData(
                  x: '检测',
                  y: data.numberCompletedCMM ?? 0,
                  text: '检测:${data.numberCompletedCMM ?? 0}'),
              ChartSampleData(
                  x: '清洗',
                  y: data.numberCompletedCLEAN ?? 0,
                  text: '清洗:${data.numberCompletedCLEAN ?? 0}'),
              ChartSampleData(
                  x: '烘干',
                  y: data.numberCompletedDRY ?? 0,
                  text: '烘干:${data.numberCompletedDRY ?? 0}'),
            ],
            xValueMapper: (ChartSampleData data, _) => data.x,
            yValueMapper: (ChartSampleData data, _) => data.y,
            dataLabelMapper: (ChartSampleData data, _) => data.text,
            startAngle: 90,
            endAngle: 90,
            dataLabelSettings: const DataLabelSettings(isVisible: true)),
      ],
    );
  }

  // 加工任务
  Widget _buildProcessTask() {
    // 柱状图
    SfCartesianChart bar = SfCartesianChart(
      plotAreaBorderWidth: 0,
      // title: ChartTitle(text: 'Winter olympic medals count - 2022'),
      primaryXAxis: CategoryAxis(
        name: '机床编号',
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          name: '加工数',
          maximum: 100,
          minimum: 0,
          interval: 10,
          axisLine: const AxisLine(width: 1),
          majorTickLines: const MajorTickLines(size: 0)),
      series: getBarColumnData(),
      legend: const Legend(
        isVisible: true,
        position: LegendPosition.top,
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
    );

    return Container(
      decoration: globalTheme.contentDecoration,
      child: TitleCard(
          title: '任务看板',
          cardBackgroundColor: globalTheme.pageContentBackgroundColor,
          containChild: Container(
            width: double.infinity,
            height: double.infinity,
            child: bar,
          )),
    );
  }

  // 柱状图图例
  List<ColumnSeries<ChartSampleData, String>> getBarColumnData() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(

          /// To apply the column width here.
          width: 0.8,

          /// To apply the spacing betweeen to two columns here.
          spacing: 0.2,
          dataSource: controller.chartData,
          color: Color.fromARGB(255, 251, 222, 55),
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: '计划加工'),
      ColumnSeries<ChartSampleData, String>(
          dataSource: controller.chartData,
          width: 0.8,
          spacing: 0.2,
          color: Color.fromARGB(255, 138, 236, 139),
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          name: '已加工'),
      // ColumnSeries<ChartSampleData, String>(
      //     dataSource: chartData,
      //     width: 0.8,
      //     spacing: 0.2,
      //     color: Color.fromARGB(255, 232, 84, 81),
      //     xValueMapper: (ChartSampleData sales, _) => sales.x as String,
      //     yValueMapper: (ChartSampleData sales, _) => sales.thirdSeriesYValue,
      //     name: '异常')
    ];
  }

  // 消息中心
  Widget _buildMessageCenter() {
    return Container(
      decoration: globalTheme.contentDecoration,
      child: TitleCard(
        title: '消息中心',
        cardBackgroundColor: globalTheme.pageContentBackgroundColor,
        containChild: Container(
          padding: globalTheme.contentPadding,
          child: ListView.builder(
            itemCount: controller.machineAlarmInfoList.length,
            itemBuilder: (context, index) {
              var info = controller.machineAlarmInfoList[index];
              return Container(
                margin: EdgeInsets.only(bottom: index == 10 ? 0 : 5.r),
                child: InfoBar(
                  severity: InfoBarSeverity.warning,
                  // isLong: true,
                  title: Text('${info.alarmTime}  ${info.machineNum}'),
                  content: Text('机床报警: ${info.macAlarmInfo}'),
                  onClose: () {
                    controller.machineAlarmInfoList.removeAt(index);
                    controller.update(['home']);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // 快捷入口
  Widget _buildQuickEntry() {
    return Container(
      decoration: globalTheme.contentDecoration,
      child: TitleCard(
        title: '快捷入口',
        headPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
        titleRight: IconButton(
          icon: Icon(
            FluentIcons.settings,
            size: 16,
            color: globalTheme.buttonIconColor,
          ),
          onPressed: onEditFastEntry,
        ),
        cardBackgroundColor: globalTheme.pageContentBackgroundColor,
        containChild: const FastEntry(),
      ),
    );
  }

  // 最近访问
  Widget _buildRecentVisit() {
    return Container(
        decoration: globalTheme.contentDecoration,
        child: TitleCard(
          title: '最近访问',
          headPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          titleRight: IconButton(
            icon: Icon(
              FluentIcons.delete,
              size: 16,
              color: globalTheme.buttonIconColor,
            ),
            onPressed: () {
              PopupMessage.showConfirmDialog(
                  title: '确认',
                  message: '确定清除所有访问记录么？',
                  onConfirm: () => GetStorageUtil.cleanVisitHistoryStore());
            },
          ),
          cardBackgroundColor: globalTheme.pageContentBackgroundColor,
          containChild: const VisitHistory(),
        ));
  }

  // 编辑快捷入口
  void onEditFastEntry() {
    SmartDialog.show(
      keepSingle: true,
      tag: 'edit_fast_entry',
      builder: (context) {
        var key = GlobalKey();
        return ContentDialog(
          constraints: const BoxConstraints(maxHeight: 500, maxWidth: 600),
          title: const Text('编辑快捷入口').fontSize(18),
          content: EditFastEntry(
            key: key,
          ),
          actions: [
            Button(
                child: const Text('取消'),
                onPressed: () => SmartDialog.dismiss(tag: 'edit_fast_entry')),
            Button(
                child: const Text('清空'),
                onPressed: () {
                  var state = key.currentState as EditFastEntryState;
                  state.clean();
                }),
            FilledButton(
                child: const Text('确定'),
                onPressed: () {
                  var state = key.currentState as EditFastEntryState;
                  state.save();
                  SmartDialog.dismiss(tag: 'edit_fast_entry');
                })
          ],
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
          _buildUserInfo(),
          globalTheme.contentDistance.verticalSpace,
          _buildLineBodyStatus(),
          globalTheme.contentDistance.verticalSpace,
          Expanded(
              child: Row(
            children: [
              Expanded(
                  child: Column(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Expanded(child: _buildTodayTaskNum2()),
                      globalTheme.contentDistance.horizontalSpace,
                      Expanded(child: _buildGrandTaskTotal()),
                      globalTheme.contentDistance.horizontalSpace,
                      Expanded(child: _buildMessageCenter())
                    ],
                  )),
                  globalTheme.contentDistance.verticalSpace,
                  Expanded(flex: 2, child: _buildProcessTask()),
                ],
              )),
              globalTheme.contentDistance.horizontalSpace,
              SizedBox(
                width: 400.0.r,
                child: Column(children: [
                  SizedBox(
                    height: 300.0.r,
                    child: _buildQuickEntry(),
                  ),
                  globalTheme.contentDistance.verticalSpace,
                  Expanded(child: _buildRecentVisit())
                ]),
              )
            ],
          ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      id: "home",
      builder: (_) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(),
        );
      },
    );
  }
}
