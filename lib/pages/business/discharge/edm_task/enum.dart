/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-31 10:10:03
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-31 11:22:16
 * @FilePath: /eatm_manager/lib/pages/business/discharge/edm_task/enum.dart
 * @Description: 枚举
 */
enum EdmTaskState {
  // 加工中
  processing(label: '加工中', state: 1),
  // 暂停
  pause(label: '暂停', state: 2),
  // 取消
  cancel(label: '初始状态', state: 3),
  // 删除
  delete(label: '删除', state: 4);

  final String label;
  final int state;

  const EdmTaskState({required this.label, required this.state});
}
