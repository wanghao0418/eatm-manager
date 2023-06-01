import 'package:eatm_manager/common/store/user.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../routers/index.dart';

/// 检查是否登录
class RouteAuthMiddleware extends GetMiddleware {
  // priority 数字小优先级高
  @override
  int? priority = 0;

  RouteAuthMiddleware({required this.priority});

  @override
  RouteSettings? redirect(String? route) {
    if (route == RouteNames.systemLogin || UserStore.instance.isLogin) {
      return null;
    } else {
      // Future.delayed(
      //     Duration(seconds: 1), () => Get.snackbar("提示", "登录过期,请重新登录"));
      return RouteSettings(name: RouteNames.systemLogin);
    }
  }
}
