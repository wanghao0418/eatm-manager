/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-27 15:54:13
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-27 15:58:39
 * @FilePath: /eatm_manager/lib/pages/business/warehouse_management/exit_records/controller.dart
 * @Description: 出库记录逻辑层
 */
import 'package:get/get.dart';

class ExitRecordsController extends GetxController {
  ExitRecordsController();
  ExitRecordsSearch search = ExitRecordsSearch();
  List<String> palletTypeList = ['托盘类型1', '托盘类型2', '托盘类型3'];

  _initData() {
    update(["exit_records"]);
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

class ExitRecordsSearch {
  String? startTime;
  String? endTime;
  String? palletType;

  ExitRecordsSearch({this.startTime, this.endTime, this.palletType});

  ExitRecordsSearch.fromJson(Map<String, dynamic> json) {
    startTime = json['startTime'];
    endTime = json['endTime'];
    palletType = json['palletType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['palletType'] = this.palletType;
    return data;
  }
}
