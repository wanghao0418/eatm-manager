/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-04 13:34:16
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-05 11:33:45
 * @FilePath: /eatm_manager/lib/pages/business/warehouse_management/task_management/enum.dart
 * @Description: 枚举集合
 */
// 执行状态枚举
import 'package:eatm_manager/common/models/selectOption.dart';

enum ExecutionStatus {
  // 待执行
  waitExecuted(value: 1, label: '待执行'),
  // 执行中
  executing(value: 2, label: '执行中'),
  // 已完成
  completed(value: 3, label: '已完成');

  final int value;
  final String label;
  const ExecutionStatus({required this.value, required this.label});

  static ExecutionStatus? fromValue(int? value) {
    switch (value) {
      case 1:
        return ExecutionStatus.waitExecuted;
      case 2:
        return ExecutionStatus.executing;
      case 3:
        return ExecutionStatus.completed;
      default:
        return null;
    }
  }

  static List<SelectOption> toSelectOptionList() {
    return [
      SelectOption(label: '全部', value: null),
      SelectOption(label: '待执行', value: 1),
      SelectOption(label: '执行中', value: 2),
      SelectOption(label: '已完成', value: 3),
    ];
  }
}

// 操作类型枚举
enum OperationType {
  // 入库
  inWarehouse(value: 1, label: '入库'),
  // 出库
  outWarehouse(value: 2, label: '出库');

  final int value;
  final String label;
  const OperationType({required this.value, required this.label});

  static OperationType? fromValue(int? value) {
    switch (value) {
      case 1:
        return OperationType.inWarehouse;
      case 2:
        return OperationType.outWarehouse;
      default:
        return null;
    }
  }
}

// 入库类型
enum InWarehouseType {
// 空托盘
  tray(value: 0, label: '托盘'),
  // 钢件
  steel(value: 1, label: '钢件'),
  // 电极
  electrode(value: 2, label: '电极');

  final int value;
  final String label;
  const InWarehouseType({required this.value, required this.label});

  static InWarehouseType? fromValue(int? value) {
    switch (value) {
      case 2:
        return InWarehouseType.electrode;
      case 1:
        return InWarehouseType.steel;
      case 0:
        return InWarehouseType.tray;
      default:
        return null;
    }
  }
}
