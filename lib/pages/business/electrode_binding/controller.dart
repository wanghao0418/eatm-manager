/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-01 10:02:57
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-01 15:16:57
 * @FilePath: /eatm_manager/lib/pages/business/electrode_binding/controller.dart
 * @Description: 多电极绑定视图层
 */
import 'package:get/get.dart';

class ElectrodeBindingController extends GetxController {
  ElectrodeBindingController();

  // 当前选中索引
  int? currentIndex;

  _initData() {
    update(["electrode_binding"]);
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
