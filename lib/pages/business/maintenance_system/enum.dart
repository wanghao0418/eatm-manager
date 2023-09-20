// 维保类别
import 'dart:ui';

enum MaintenanceCategory {
  // 保养
  maintenance(label: "保养", value: 1),
  // 点检
  check(label: '点检', value: 2);

  final String label;
  final int value;
  const MaintenanceCategory({required this.label, required this.value});

  static MaintenanceCategory fromValue(int value) {
    return values.firstWhere((e) => e.value == value);
  }
}

// 维保项目
enum MaintenanceItem {
  // 设备
  equipment(label: "设备", value: "设备"),
  // 线体
  line(label: '线体', value: '线体');

  final String label;
  final String value;
  const MaintenanceItem({required this.label, required this.value});
}

// 维保状态
enum MaintenanceStatus {
  // 待执行
  notStart(label: "待执行", value: 1, color: Color.fromARGB(255, 254, 235, 63)),
  // 执行中
  inProgress(label: '执行中', value: 2, color: Color(0xff55A1E0)),
  // 已执行
  completed(label: '已执行', value: 3, color: Color(0xff6aa84f));

  final String label;
  final int value;
  final Color color;
  const MaintenanceStatus(
      {required this.label, required this.value, required this.color});

  static MaintenanceStatus? fromValue(int value) {
    return MaintenanceStatus.values
        .firstWhere((element) => element.value == value);
  }

  // 维保处理
  MaintenanceStatus? handle() {
    if (value == MaintenanceStatus.notStart.value) {
      return MaintenanceStatus.inProgress;
    } else if (value == MaintenanceStatus.inProgress.value) {
      return MaintenanceStatus.completed;
    }
    return null;
  }
}
