/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-03 09:24:12
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-03 09:27:36
 * @FilePath: /eatm_manager/lib/common/models/selectOption.dart
 * @Description: 通用下拉选项类
 */
class SelectOption {
  String? label;
  dynamic value;

  SelectOption({this.label, this.value});

  SelectOption.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['value'] = this.value;
    return data;
  }
}
