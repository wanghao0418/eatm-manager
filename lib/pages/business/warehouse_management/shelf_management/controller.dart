/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-25 13:37:07
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-25 18:30:22
 * @FilePath: /eatm_manager/lib/pages/business/warehouse_management/shelf_management/controller.dart
 * @Description: 货架管理逻辑层
 */
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class ShelfManagementController extends GetxController {
  ShelfManagementController();
  ShelfManagementForm shelfManagementForm = ShelfManagementForm();
  List<String> artifactTypeList = ['1', '2', '3'];
  List<String> storageTypeList = ['入库类型1', '入库类型2', '入库类型3'];
  List<String> taskList = ['任务1', '任务2', '任务3', '任务4', '任务5'];
  List shelfList = ['货架1', '货架2', '货架3', '货架4', '货架5'];
  List<PlutoRow> rows = [];
  late final PlutoGridStateManager stateManager;
  final currentShelf = '货架1'.obs;
  final toggle = false.obs;
  final currentTask = '任务1'.obs;

  _initData() {
    update(["shelf_management"]);
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

class ShelfManagementForm {
  String? artifactType;
  String? storageType;
  String? aGVStorageNum;

  ShelfManagementForm(
      {this.artifactType, this.storageType, this.aGVStorageNum});

  ShelfManagementForm.fromJson(Map<String, dynamic> json) {
    artifactType = json['artifactType'];
    storageType = json['storageType'];
    aGVStorageNum = json['AGVStorageNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['artifactType'] = this.artifactType;
    data['storageType'] = this.storageType;
    data['AGVStorageNum'] = this.aGVStorageNum;
    return data;
  }
}
