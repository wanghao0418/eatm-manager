import 'package:eatm_manager/common/api/line_body_api.dart';
import 'package:eatm_manager/common/models/machineInfo.dart';
import 'package:eatm_manager/common/utils/http.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:get/get.dart';
import 'dart:math';

class UtilizationStatisticsController extends GetxController {
  UtilizationStatisticsController();
  List<MachineInfo> macList = [];
  MachineInfo? currentMachine;

  _initData() {
    update(["utilization_statistics"]);
  }

  // 获取机床列表
  void getMachineList() async {
    PopupMessage.showLoading();
    ResponseApiBody res = await LineBodyApi.getMachineList();
    PopupMessage.closeLoading();
    if (res.success!) {
      macList = (res.data as List).map((e) => MachineInfo.fromJson(e)).toList();
      _initData();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 获取 0 到 10 随机 double
  double getRandomDouble(double min, double max) {
    Random random = Random();
    return min + random.nextDouble() * (max - min);
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    getMachineList();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
