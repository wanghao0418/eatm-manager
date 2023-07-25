import 'package:eatm_manager/common/store/user.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../routers/index.dart';

/// 检查是否登录
class RouteAuthMiddleware extends GetMiddleware {
  final GetStorage _storage = GetStorage('user');
  // priority 数字小优先级高
  @override
  int? priority = 0;

  RouteAuthMiddleware({required this.priority});

  @override
  RouteSettings? redirect(String? route) {
    var token = _storage.read('token') ?? '';
    if (route == RouteNames.systemLogin || token.isNotEmpty) {
      return null;
    } else {
      // Future.delayed(
      //     Duration(seconds: 1), () => Get.snackbar("提示", "登录过期,请重新登录"));
      return RouteSettings(name: RouteNames.systemLogin);
    }
  }
}
