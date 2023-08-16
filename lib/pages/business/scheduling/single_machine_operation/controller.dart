import 'package:get/get.dart';

class SingleMachineOperationController extends GetxController {
  SingleMachineOperationController();

  _initData() {
    update(["single_machine_operation"]);
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
