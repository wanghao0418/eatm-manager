/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-22 10:17:23
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-23 09:23:23
 * @FilePath: /eatm_manager/lib/pages/business/scheduling/multiple_machine_operation/widgets/machine_warning_card.dart
 * @Description: 机床预警卡片
 */
import 'package:eatm_manager/common/components/themed_text.dart';
import 'package:eatm_manager/common/components/title_card.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/utils/log.dart';
import 'package:eatm_manager/pages/business/scheduling/models.dart';
import 'package:eatm_manager/pages/business/scheduling/multiple_machine_operation/widgets/tool_warning_bar.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart' as material;
import 'package:get_storage/get_storage.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:styled_widget/styled_widget.dart';

class MachineWarningCard extends StatefulWidget {
  const MachineWarningCard(
      {Key? key, required this.schedulingData, required this.warningDuration})
      : super(key: key);
  final DeviceResources schedulingData;
  final double warningDuration;

  @override
  _MachineWarningCardState createState() => _MachineWarningCardState();
}

class _MachineWarningCardState extends State<MachineWarningCard> {
  GlobalTheme get globalTheme => GlobalTheme.instance;
  // 机床预警提示
  String planTips = '';

  // 当前时间间隔下限提示
  String get currentTips =>
      double.parse(widget.schedulingData.planRunTime!) < widget.warningDuration
          ? planTips.replaceAll('运行', '后空闲')
          : planTips;

  // 取出括号中的时间
  String extractTextInParentheses(String input) {
    int startIndex = input.indexOf("（");
    int endIndex = input.indexOf("）");

    if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
      return input.substring(startIndex + 1, endIndex);
    } else {
      return ""; // 如果找不到括号，返回一个空字符串或者你认为合适的默认值
    }
  }

  // 构建预警卡片
  Widget _buildWarningBox() {
    late WarningStatus warningStatus;
    planTips = widget.schedulingData.planStatus ?? '';
    if (widget.schedulingData.deviceInlineStatus ==
        OnlineStatus.offline.value) {
      // 离线
      warningStatus = WarningStatus.idle;
      if (widget.schedulingData.statusReason != '未上线') {
        warningStatus = WarningStatus.offline;
      }
    } else {
      // 在线
      if (double.parse(widget.schedulingData.planRunTime!) >=
          widget.warningDuration) {
        // 机床运行时间大于预警时间
        warningStatus = WarningStatus.normal;
      } else {
        // 机床运行时间小于预警时间
        if (widget.schedulingData.pictureStatus ==
            WarningStatus.toolWarning.value) {
          warningStatus = WarningStatus.toolWarning;
        } else {
          warningStatus = WarningStatus.materialMissing;
        }
      }
      if (planTips.contains('后停机')) {
        // 取出括号中的时间
        var reg = RegExp(r"\（(.+?)\）");
        var match = reg.firstMatch(planTips);
        if (match != null) {
          // 去掉括号
          var timeStr = extractTextInParentheses(match.group(0) ?? '');
          LogUtil.f(timeStr);
          // 计算时间差
          int diffInMinutes =
              DateTime.parse(timeStr).difference(DateTime.now()).inMinutes;
          if (diffInMinutes < 0) {
            planTips = '检测到机床刀具寿命到期\n请更换刀具';
            warningStatus = WarningStatus.toolWarning;
          }
        }
      }
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        color: warningStatus.color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 0),
            blurRadius: 10,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.r),
          child: Row(
            children: [
              warningStatus == WarningStatus.idle
                  ? Container(
                      width: 50.r,
                      height: 50.r,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25)),
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            material.Icons.hourglass_full,
                            size: 40.sp,
                            color: material.Colors.grey,
                          ),
                        ],
                      ),
                    )
                  : Icon(
                      warningStatus.icon,
                      color: Colors.grey,
                      size: 60.sp,
                    ),
              10.horizontalSpaceRadius,
              Text(currentTips).textColor(Colors.white).fontSize(16.sp),
            ],
          ),
        )),
        if (warningStatus == WarningStatus.toolWarning ||
            warningStatus == WarningStatus.materialMissing)
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.r, horizontal: 20.r),
            decoration: BoxDecoration(
              color: material.Colors.orange[800],
            ),
            child: Row(
              children: [
                Icon(
                  warningStatus == WarningStatus.toolWarning
                      ? FluentIcons.developer_tools
                      : FluentIcons.build_issue,
                  color: Colors.white,
                  size: 20.sp,
                ),
                20.horizontalSpaceRadius,
                Text(
                  warningStatus == WarningStatus.toolWarning
                      ? widget.schedulingData.statusReason ?? ''
                      : '物料缺失',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
      ]),
    );
  }

  // 刀具寿命
  Widget _buildToolLife() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ThemedText(
          '最小刀具寿命',
          style: TextStyle(fontSize: 16.sp),
        ),
        5.verticalSpacingRadius,
        Expanded(
            child: ToolWarningBar(
          deviceToolNoArr: widget.schedulingData.deviceToolNoArr ?? [],
        ))
      ],
    );
  }

  // 物料信息
  Widget _buildMaterialInfo() {
    double chipRemoval = 0;
    double cuttingFluid = 0;
    if (widget.schedulingData.chipRemoval?.first.theoreticalTime?.toInt() ==
        0) {
      chipRemoval = 0;
    } else {
      chipRemoval = widget.schedulingData.chipRemoval!.first.usedTime! /
          widget.schedulingData.chipRemoval!.first.theoreticalTime! *
          100;
      if (chipRemoval > 100)
        chipRemoval = 100;
      else if (chipRemoval < 0) chipRemoval = 0;
      chipRemoval = chipRemoval.toInt().toDouble();
    }

    if (widget.schedulingData.cuttingFluid?.first.theoreticalTime?.toInt() ==
        0) {
      cuttingFluid = 0;
    } else {
      cuttingFluid = widget.schedulingData.cuttingFluid!.first.usedTime! /
          widget.schedulingData.cuttingFluid!.first.theoreticalTime! *
          100;
      if (cuttingFluid > 100)
        cuttingFluid = 100;
      else if (cuttingFluid < 0) cuttingFluid = 0;
      cuttingFluid = cuttingFluid.toInt().toDouble();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 100.0.r,
              child: ThemedText(
                '机床排屑',
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
            10.horizontalSpaceRadius,
            Expanded(
              child: LinearPercentIndicator(
                animation: true,
                lineHeight: 20.0.r,
                animationDuration: 2000,
                percent: chipRemoval / 100,
                center: Text("$chipRemoval%").fontSize(16.sp),
                barRadius: Radius.circular(10.r),
                progressColor: Color.fromARGB(255, 130, 228, 121),
              ),
            ),
          ],
        ),
        10.verticalSpacingRadius,
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 100.0.r,
              child: ThemedText(
                '切屑液',
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
            10.horizontalSpaceRadius,
            Expanded(
                child: LinearPercentIndicator(
              animation: true,
              lineHeight: 20.0.r,
              animationDuration: 2000,
              percent: cuttingFluid / 100,
              center: Text("$cuttingFluid%").fontSize(16.sp),
              barRadius: Radius.circular(10.r),
              progressColor: Color.fromARGB(255, 130, 228, 121),
            )),
          ],
        ),
      ],
    );
  }

  @override
  void didUpdateWidget(covariant MachineWarningCard oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    LogUtil.f('didUpdateWidget');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TitleCard(
        title: widget.schedulingData.deviceName ?? '',
        titleRight: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            color: OnlineStatus.fromValue(
                    widget.schedulingData.deviceInlineStatus ?? 0)
                .color,
          ),
          child: ThemedText(
            OnlineStatus.fromValue(
                    widget.schedulingData.deviceInlineStatus ?? 0)
                .label,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
            ),
          ),
        ),
        headBorderColor: Colors.transparent,
        cardBackgroundColor: globalTheme.isDarkMode
            ? const Color.fromARGB(223, 62, 60, 60)
            : Colors.white,
        containChild: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildWarningBox()),
              5.verticalSpacingRadius,
              Expanded(child: _buildToolLife()),
              Expanded(child: _buildMaterialInfo()),
            ],
          ),
        ));
  }
}

// 在线状态枚举
enum OnlineStatus {
  // 在线
  online(value: 1, label: '在线', color: Color(0xFF00C853)),
  // 离线
  offline(value: 0, label: '离线', color: Color(0xff999999));

  final int value;
  final Color color;
  final String label;
  const OnlineStatus(
      {required this.value, required this.color, required this.label});
  static OnlineStatus fromValue(int value) {
    switch (value) {
      case 1:
        return OnlineStatus.online;
      case 0:
        return OnlineStatus.offline;
      default:
        return OnlineStatus.offline;
    }
  }
}

// 预警状态
enum WarningStatus {
  // 空闲
  idle(value: -1, label: '空闲', color: Color(0xff999999), icon: null),
  // 离线
  offline(
      value: -2,
      label: '离线',
      color: Color(0xff999999),
      icon: material.Icons.warning_amber),
  // 正常
  normal(
      value: 0,
      label: '正常',
      color: Color.fromARGB(255, 130, 228, 121),
      icon: material.Icons.check_circle),
  // 预警
  toolWarning(
      value: 1,
      label: '刀具寿命到期',
      color: Color.fromARGB(255, 255, 183, 77),
      icon: material.Icons.warning_amber),
  // 机床报警
  alarm(
      value: 2,
      label: '报警',
      color: Color(0xffF44336),
      icon: material.Icons.error),
  // 物料缺失
  materialMissing(
      value: 3,
      label: '物料缺失',
      color: Color.fromARGB(255, 255, 183, 77),
      icon: material.Icons.change_circle);

  final int value;
  final Color color;
  final String label;
  final IconData? icon;
  const WarningStatus(
      {required this.value,
      required this.color,
      required this.label,
      required this.icon});
  static WarningStatus fromValue(int value) {
    switch (value) {
      case 0:
        return WarningStatus.normal;
      case 1:
        return WarningStatus.toolWarning;
      case 2:
        return WarningStatus.alarm;
      case 3:
        return WarningStatus.materialMissing;
      default:
        return WarningStatus.normal;
    }
  }
}
