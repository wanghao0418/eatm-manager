/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-06 13:32:52
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-07 09:15:54
 * @FilePath: /eatm_manager/lib/pages/business/home/enum.dart
 * @Description: 枚举
 */
import 'package:eatm_manager/common/index.dart';
import 'package:fluent_ui/fluent_ui.dart';

enum MachineState {
  // 运行中
  running(
      status: 2, label: '运行', icon: MyIcons.running, color: Color(0xffCCFFCC)),
  // 空闲
  idle(
      status: 3,
      label: '空闲',
      icon: FluentIcons.clock,
      color: Color(0xffeeeeee)),
  // 异常
  exception(
      status: 1,
      label: '异常',
      icon: FluentIcons.warning,
      color: Color(0xffe84f62)),
  // 关机
  shutdown(
      status: 4, label: '关机', icon: MyIcons.shutdown, color: Color(0xffD9D9D9)),
  // 调试
  debug(
      status: 5,
      label: '调试',
      icon: FluentIcons.test_user_solid,
      color: Color(0xff01FFFD)),
  // 手动
  manual(
      status: 6,
      label: '手动',
      icon: FluentIcons.hands_free,
      color: Color(0xffe2bb83));

  final int status;
  final IconData icon;
  final String label;
  final Color color;
  const MachineState({
    required this.status,
    required this.icon,
    required this.label,
    required this.color,
  });

  // 根据状态获取类型
  static MachineState? getStatus(int status) {
    switch (status) {
      case 2:
        return MachineState.running;
      case 3:
        return MachineState.idle;
      case 1:
        return MachineState.exception;
      case 4:
        return MachineState.shutdown;
      case 5:
        return MachineState.debug;
      case 6:
        return MachineState.manual;
      default:
        return null;
    }
  }
}
