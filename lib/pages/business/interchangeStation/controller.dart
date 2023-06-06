import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';

class InterchangeStationController extends GetxController {
  InterchangeStationController();
  final GlobalKey pageKey = GlobalKey();
  final FlyoutController menuController = FlyoutController();
  var currentShelfIndex = 0;
  var shelfList = [];
  var menuOffset = Offset.zero;

  _initData() {
    update(["interchangeStation"]);
  }

  // 获取货架列表
  getShelfList() async {
    // ResponseApiBody response = await ShelfApi.getShelfList();
    // if (response.success == true) {
    //   shelfList = (response.data as List).map((e) => Shelf.fromJson(e)).toList();
    //   update(["interchangeStation"]);
    // }
    shelfList = List.generate(
        10,
        (index) => {
              'shelfName': '货架${index}',
              'shelves': List.generate(
                  50,
                  (index) => {
                        'shelvesName': '货位${index}',
                        'status': Random().nextInt(5)
                      })
            });
    update(["interchangeStation"]);
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
    getShelfList();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}

// 货位状态枚举
enum GoodsState {
  Idle(status: 0, label: '空闲', color: Color(0xffebeee3)),
  Wait(status: 1, label: '待加工', color: Color(0xff00ccff)),
  InProcess(status: 2, label: '加工中', color: Color(0xffffa902)),
  Error(status: 3, label: '异常', color: Color(0xffff6300)),
  Complete(status: 4, label: '加工完成', color: Color(0xff00d100));

  final int status;
  final String label;
  final Color color;

  const GoodsState(
      {required this.label, required this.color, required this.status});

  static GoodsState? findByStatus(int status) {
    var index = GoodsState.values
        .indexWhere((GoodsState element) => element.status == status);
    return index >= 0 ? GoodsState.values[index] : null;
  }
}
