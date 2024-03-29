/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-18 13:50:06
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-21 13:21:54
 * @FilePath: /eatm_manager/lib/pages/business/scheduling/single_machine_operation/enum.dart
 * @Description: 枚举
 */

// 运行状态枚举
import 'package:flutter/material.dart';

enum OperatingStatus {
  // 提示
  prompt(
      value: 0,
      icon: Icon(Icons.build_circle, color: Color(0xff333333), size: 60),
      backgroundColor: Color(0xffe9e9eb)),
  // 正常
  normal(
      value: 1,
      icon: Icon(Icons.check_circle, color: Color(0xff333333), size: 60),
      backgroundColor: Color.fromARGB(255, 216, 239, 204)),
  // 报警
  alarm(
      value: 2,
      icon: Icon(Icons.warning_amber, color: Color(0xff333333), size: 60),
      backgroundColor: Color(0xfffef0f0));

  final int value;
  final Icon icon;
  final Color backgroundColor;
  const OperatingStatus(
      {required this.value, required this.icon, required this.backgroundColor});

  static OperatingStatus? fromValue(int? value) {
    switch (value) {
      case 0:
        return OperatingStatus.prompt;
      case 1:
        return OperatingStatus.normal;
      case 2:
        return OperatingStatus.alarm;
      default:
        return OperatingStatus.prompt;
    }
  }
}

// 排产状态
enum SchedulingStatus {
  // 待加工
  unscheduled(
      value: 0, label: '待加工', color: Color.fromARGB(180, 158, 158, 158)),
  // 运行中
  scheduled(value: 1, label: '运行中', color: Color.fromARGB(180, 123, 155, 225)),
  // 报警
  completed(
      value: 2, label: '刀具寿命告警', color: Color.fromARGB(180, 189, 109, 108));

  final int value;
  final String label;
  final Color? color;
  const SchedulingStatus(
      {required this.value, required this.label, required this.color});

  static SchedulingStatus? fromValue(int? value) {
    switch (value) {
      case 0:
        return SchedulingStatus.unscheduled;
      case 1:
        return SchedulingStatus.scheduled;
      case 2:
        return SchedulingStatus.completed;
      default:
        return SchedulingStatus.unscheduled;
    }
  }
}

// 机床运行状态
enum MachineStatus {
  // 异常
  abnormal(value: 0, label: '异常', color: Color.fromARGB(255, 255, 30, 30)),
  // 空闲
  idle(value: 1, label: '空闲', color: Color.fromARGB(255, 158, 167, 188)),
  // 运行
  running(value: 2, label: '运行', color: Color.fromARGB(255, 76, 123, 241));

  final int value;
  final String label;
  final Color? color;
  const MachineStatus(
      {required this.value, required this.label, required this.color});

  static MachineStatus? fromValue(int? value) {
    switch (value) {
      case -1:
        return MachineStatus.abnormal;
      case 0:
        return MachineStatus.idle;
      case 1:
        return MachineStatus.running;
      default:
        return MachineStatus.idle;
    }
  }
}
