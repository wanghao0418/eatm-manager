/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-27 11:32:57
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-27 15:23:31
 * @FilePath: /eatm_manager/lib/pages/business/warehouse_management/storage_records/controller.dart
 * @Description: 入库记录逻辑层
 */
import 'package:get/get.dart';

class StorageRecordsController extends GetxController {
  StorageRecordsController();
  StorageRecordsSearch search = StorageRecordsSearch();
  List<String> palletTypeList = ['托盘类型1', '托盘类型2', '托盘类型3'];

  _initData() {
    update(["storage_records"]);
  }

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

class StorageRecordsSearch {
  String? startTime;
  String? endTime;
  String? palletType;

  StorageRecordsSearch({this.startTime, this.endTime, this.palletType});

  StorageRecordsSearch.fromJson(Map<String, dynamic> json) {
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
