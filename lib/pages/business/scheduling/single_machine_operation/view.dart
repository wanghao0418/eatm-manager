/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-16 10:59:00
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-18 18:29:18
 * @FilePath: /eatm_manager/lib/pages/business/scheduling/single_machine_operation/view.dart
 * @Description:  单机负荷视图层
 */
import 'package:eatm_manager/common/components/title_card.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/style/icons.dart';
import 'package:eatm_manager/pages/business/scheduling/single_machine_operation/enum.dart';
import 'package:eatm_manager/pages/business/scheduling/single_machine_operation/widgets/scheduling_gantt_chart.dart';
import 'package:eatm_manager/pages/business/scheduling/single_machine_operation/widgets/time_now.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:styled_widget/styled_widget.dart';

import 'index.dart';

class SingleMachineOperationPage extends StatefulWidget {
  const SingleMachineOperationPage({Key? key}) : super(key: key);

  @override
  State<SingleMachineOperationPage> createState() =>
      _SingleMachineOperationPageState();
}

class _SingleMachineOperationPageState extends State<SingleMachineOperationPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _SingleMachineOperationViewGetX();
  }
}

class _SingleMachineOperationViewGetX
    extends GetView<SingleMachineOperationController> {
  const _SingleMachineOperationViewGetX({Key? key}) : super(key: key);
  GlobalTheme get globalTheme => GlobalTheme.instance;

  // 机床信息
  Widget _buildMacInfo() {
    return Expanded(
        flex: 9,
        child: Container(
          decoration: globalTheme.contentDecoration,
          child: TitleCard(
              title: "机床信息",
              cardBackgroundColor: const Color(0xffd9ecff),
              headBorderColor: Colors.white,
              headTextColor: Colors.black,
              titleRight: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  color: Color(0xfffef0f0),
                ),
                padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
                child: Text(
                  controller.currentMachine?.curStatus ?? '',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              containChild: Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 0,
                      child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      controller.currentMachine?.deviceName ??
                                          '',
                                      style: TextStyle(
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xff333333)),
                                    ),
                                    const TimeNow()
                                  ],
                                )),
                              ),
                            ],
                          )),
                    ),
                    Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                child: Column(
                                  children: [
                                    Text(
                                      '今日在线时长',
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xff606266),
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      controller.currentMachine
                                              ?.todayOnlineTimes ??
                                          '',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          color: const Color(0xff606266),
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                )),
                            Container(
                                child: Column(
                              children: [
                                Text(
                                  '累计运行时长',
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xff606266),
                                      overflow: TextOverflow.ellipsis),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  controller.currentMachine?.allRunTimes ?? '',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: const Color(0xff606266),
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            )),
                          ],
                        )),
                    Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                child: Column(
                                  children: [
                                    Text(
                                      '设备系统类型',
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xff606266),
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      controller.currentMachine?.systemType ??
                                          '',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          color: const Color(0xff606266),
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                )),
                            SizedBox(
                                child: Column(
                              children: [
                                Text(
                                  '设备工艺限制',
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xff606266),
                                      overflow: TextOverflow.ellipsis),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  controller.currentMachine?.chuckCraftLimit ??
                                      '',
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Color(0xff606266),
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            )),
                          ],
                        ))
                  ],
                ),
              )),
        ));
  }

  // 稼动率
  Widget _buildRate() {
    return Expanded(
      flex: 4,
      child: Container(
          decoration: globalTheme.contentDecoration,
          child: TitleCard(
            title: '稼动率',
            cardBackgroundColor: Color(0xffe1f3d8),
            headBorderColor: Colors.white,
            headTextColor: Colors.black,
            containChild: Center(
                child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                SizedBox(
                    width: 100.r,
                    height: 100.r,
                    child: ProgressRing(
                      activeColor: globalTheme.accentColor,
                      value: controller.currentMachine?.utilizationRate
                              ?.toDouble() ??
                          0,
                      strokeWidth: 18.0.r,
                      backgroundColor: Color(0xfff4f4f5),
                    )),
                Text(
                  '${controller.currentMachine?.utilizationRate.toString() ?? '0'}%',
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff333333)),
                )
              ],
            )),
          )),
    );
  }

  // 工件信息
  Widget _buildWorkpieceInfo() {
    double denominator =
        controller.currentProductionOrder?.processFenmu?.toDouble() ?? 0.0;
    double numerator =
        controller.currentProductionOrder?.processFenzi?.toDouble() ?? 0.0;
    double percentageNum =
        numerator < denominator ? numerator / denominator * 100 : 1.0;

    return Expanded(
      flex: 9,
      child: Container(
          decoration: globalTheme.contentDecoration,
          child: TitleCard(
            title: '工件信息',
            cardBackgroundColor: const Color(0xffd9ecff),
            headBorderColor: Colors.white,
            headTextColor: Colors.black,
            titleRight: Text(
              controller.currentProductionOrder?.workpieceSn ?? '',
              style: TextStyle(
                  fontSize: 16.sp,
                  color: FluentTheme.of(Get.context!).typography.body!.color),
            ),
            containChild: Stack(children: [
              Container(
                  padding: EdgeInsets.only(bottom: 50.r),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.r, 10.r, 20.r, 10.r),
                    child: Row(
                      children: [
                        SizedBox(
                            width: 100.r,
                            child: Center(
                                child: Icon(
                              FluentIcons.settings,
                              size: 50.r,
                              color: globalTheme.accentColor,
                            ))),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                margin: EdgeInsets.only(bottom: 20.r),
                                child: Column(
                                  children: [
                                    Text(
                                      '工件模号',
                                      // maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 14.spMin,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xff606266),
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    SizedBox(
                                      height: 5.r,
                                    ),
                                    Text(
                                      controller.currentProductionOrder
                                              ?.mouldSn ??
                                          '',
                                      style: TextStyle(
                                          fontSize: 14.spMin,
                                          color: Color(0xff606266),
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                )),
                            SizedBox(
                                child: Column(
                              children: [
                                Text(
                                  '工件件号',
                                  // maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 14.spMin,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xff606266),
                                      overflow: TextOverflow.ellipsis),
                                ),
                                SizedBox(
                                  height: 5.r,
                                ),
                                Text(
                                  controller.currentProductionOrder?.partSn ??
                                      '',
                                  style: TextStyle(
                                      fontSize: 14.spMin,
                                      color: const Color(0xff606266),
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            )),
                          ],
                        )),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                margin: EdgeInsets.only(bottom: 20.r),
                                child: Column(
                                  children: [
                                    Text(
                                      '计划开始时间',
                                      // maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 14.spMin,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xff606266),
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    SizedBox(
                                      height: 5.r,
                                    ),
                                    Text(
                                      controller
                                              .currentProductionOrder?.startTime
                                              .toString() ??
                                          '',
                                      style: TextStyle(
                                          fontSize: 14.spMin,
                                          color: const Color(0xff606266),
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                )),
                            SizedBox(
                                child: Column(
                              children: [
                                Text(
                                  '计划结束时间',
                                  // maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 14.spMin,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xff606266),
                                      overflow: TextOverflow.ellipsis),
                                ),
                                SizedBox(
                                  height: 5.r,
                                ),
                                Text(
                                  controller.currentProductionOrder?.endTime
                                          .toString() ??
                                      '',
                                  style: TextStyle(
                                      fontSize: 14.spMin,
                                      color: const Color(0xff606266),
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            )),
                          ],
                        ))
                      ],
                    ),
                  )),
              Positioned(
                left: 0,
                bottom: 0,
                right: 0,
                child: Container(
                    height: 50.r,
                    decoration:
                        const BoxDecoration(color: Color.fromARGB(70, 0, 0, 0)),
                    padding: EdgeInsets.all(5.r),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.r),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: ProgressBar(
                                      value: percentageNum,
                                      strokeWidth: 5.r,
                                      backgroundColor: const Color(0xfff4f4f5),
                                      activeColor: percentageNum == 1.0
                                          ? Color.fromARGB(255, 248, 185, 91)
                                          : const Color(0xff67c23a))),
                              10.horizontalSpace,
                              Container(
                                padding: const EdgeInsets.only(right: 20),
                                child: Text(
                                  '${(percentageNum).toStringAsFixed(1)}%',
                                  style: const TextStyle(color: Colors.white),
                                ).fontSize(14.spMin),
                              )
                            ],
                          ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  '已加工时间:${controller.currentProductionOrder?.hasWorkTime ?? 0}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 14.r),
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    "计划剩余时间:${controller.currentProductionOrder?.leftWorkTime ?? 0}",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        color: Colors.white,
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 14.r),
                                  ))
                            ]),
                      ],
                    )),
              ),
            ]),
          )),
    );
  }

  // 机床列表
  Widget _buildMachineList() {
    return Container(
      width: 200,
      decoration: globalTheme.contentDecoration,
      child: TitleCard(
          title: "机床列表",
          cardBackgroundColor: globalTheme.pageContentBackgroundColor,
          containChild: ListView.separated(
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                var value = controller.machineList[index];
                return ListTile.selectable(
                  leading: Icon(
                    MyIcons.machineTool,
                    color: globalTheme.buttonIconColor,
                  ),
                  title: Text(value),
                  selected: controller.currentMachine?.deviceName == value,
                  onPressed: () {
                    controller.selectMachine(value);
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: controller.machineList.length)),
    );
  }

  // 排产
  Widget _buildProductionScheduling() {
    return Container(
      decoration: globalTheme.contentDecoration,
      child: TitleCard(
        title: '排产',
        containChild: SchedulingGanttChart(),
        cardBackgroundColor: globalTheme.pageContentBackgroundColor,
      ),
    );
  }

  // 状态提示
  Widget _renderStatusInfo() {
    return Container(
      width: 400.r,
      decoration: globalTheme.contentDecoration,
      child: TitleCard(
          containChild: Stack(children: [
            Container(
                padding: EdgeInsets.only(bottom: 50.r),
                color: OperatingStatus.fromValue(
                        controller.currentMachine?.colorStatus ?? 0)!
                    .backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 0,
                        child: Container(
                            margin: const EdgeInsets.only(right: 30),
                            child: Center(
                              child: OperatingStatus.fromValue(
                                      controller.currentMachine?.colorStatus ??
                                          0)!
                                  .icon,
                            )),
                      ),
                      Expanded(
                          child: Text(
                        controller.currentMachine?.planStatus ?? '',
                        style: TextStyle(
                            fontSize: 16.spMin, color: const Color(0xff666666)),
                      ))
                    ],
                  ),
                )),
            Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: Container(
                  height: 50.r,
                  decoration:
                      const BoxDecoration(color: Color.fromARGB(70, 0, 0, 0)),
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                              controller.currentMachine?.statusReason ?? '',
                              style: TextStyle(
                                  fontSize: 16.spMin, color: Colors.white),
                              overflow: TextOverflow.ellipsis))
                    ],
                  )),
            ),
          ]),
          cardBackgroundColor: globalTheme.pageContentBackgroundColor),
    );
  }

  // 刀具
  Widget _renderToolTable() {
    return Container(
      decoration: globalTheme.contentDecoration,
      child: TitleCard(
        title: '预警刀具',
        cardBackgroundColor: globalTheme.pageContentBackgroundColor,
        containChild: PlutoGrid(
          columns: [
            PlutoColumn(
                title: '刀具名称',
                field: 'toolTypeNo',
                type: PlutoColumnType.text(),
                readOnly: true),
            PlutoColumn(
                title: '理论时间',
                field: 'theoreticalTime',
                type: PlutoColumnType.text(),
                readOnly: true),
            PlutoColumn(
                title: '使用时间',
                field: 'usedTime',
                type: PlutoColumnType.text(),
                readOnly: true),
            PlutoColumn(
                title: '原因',
                field: 'alarmTip',
                type: PlutoColumnType.text(),
                readOnly: true),
          ],
          rows: controller.currentAlarmTools!
              .map((e) => PlutoRow(cells: {
                    'toolTypeNo': PlutoCell(value: e.toolTypeNo),
                    'theoreticalTime': PlutoCell(value: e.theoreticalTime),
                    'usedTime': PlutoCell(value: e.usedTime),
                    'alarmTip': PlutoCell(value: e.alarmTip),
                  }))
              .toList(),
          onLoaded: (event) {
            controller.stateManager = event.stateManager;
            // controller.updateRows();
          },
          configuration: globalTheme.plutoGridConfig.copyWith(
              columnSize: const PlutoGridColumnSizeConfig(
                  autoSizeMode: PlutoAutoSizeMode.scale)),
        ),
      ),
    );
  }

  // 主视图
  Widget _buildView() {
    return Container(
        padding: globalTheme.pagePadding,
        child: Column(
          children: [
            SizedBox(
              height: 240.r,
              child: Row(
                children: [
                  _buildMacInfo(),
                  globalTheme.contentDistance.horizontalSpace,
                  _buildRate(),
                  globalTheme.contentDistance.horizontalSpace,
                  _buildWorkpieceInfo()
                ],
              ),
            ),
            globalTheme.contentDistance.verticalSpace,
            Expanded(
                child: Row(
              children: [
                _buildMachineList(),
                globalTheme.contentDistance.horizontalSpace,
                Expanded(
                    child: Column(
                  children: [
                    Expanded(
                      child: _buildProductionScheduling(),
                    ),
                    globalTheme.contentDistance.verticalSpace,
                    Expanded(
                        child: Row(
                      children: [
                        _renderStatusInfo(),
                        globalTheme.contentDistance.horizontalSpace,
                        Expanded(child: _renderToolTable())
                      ],
                    ))
                  ],
                )),
              ],
            ))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SingleMachineOperationController>(
      init: SingleMachineOperationController(),
      id: "single_machine_operation",
      builder: (_) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(),
        );
      },
    );
  }
}
