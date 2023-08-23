import 'package:get/get.dart';

class DataEntryController extends GetxController {
  DataEntryController();

  _initData() {
    update(["data_entry"]);
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
