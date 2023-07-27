/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-27 16:09:22
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-27 16:15:28
 * @FilePath: /eatm_manager/lib/pages/business/warehouse_management/task_management/controller.dart
 * @Description: 任务管理逻辑层
 */
import 'package:get/get.dart';

class TaskManagementController extends GetxController {
  TaskManagementController();
  TaskManagementSearch search = TaskManagementSearch();

  _initData() {
    update(["task_management"]);
  }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}

class TaskManagementSearch {
  String? startTime;
  String? endTime;

  TaskManagementSearch({this.startTime, this.endTime});

  TaskManagementSearch.fromJson(Map<String, dynamic> json) {
    startTime = json['startTime'];
    endTime = json['endTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    return data;
  }
}
