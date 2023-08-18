/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-18 09:32:53
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-18 09:37:34
 * @FilePath: /eatm_manager/lib/pages/business/reporting/enum.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
// 工序状态枚举

enum WpState {
  // 未开工
  notStarted(value: '0', label: '未开工'),
  // 加工中
  processing(value: '1', label: '加工中'),
  // 暂停
  pause(value: '2', label: '暂停'),
  // 继续加工中
  continueProcessing(value: '3', label: '加工中'),
  // 完工
  completed(value: '4', label: '完工');

  final String value;
  final String label;
  const WpState({required this.value, required this.label});

  static WpState? fromValue(String? value) {
    switch (value) {
      case '0':
        return WpState.notStarted;
      case '1':
        return WpState.processing;
      case '2':
        return WpState.pause;
      case '3':
        return WpState.continueProcessing;
      case '4':
        return WpState.completed;
      default:
        return null;
    }
  }
}
