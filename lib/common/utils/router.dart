/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-30 11:03:50
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-30 11:30:16
 * @FilePath: /eatm_manager/lib/common/utils/router.dart
 * @Description: 路由工具类
 */

import 'package:eatm_manager/common/extension/main.dart';
import 'package:eatm_manager/common/utils/log.dart';
import 'package:eatm_manager/pages/system/main/controller.dart';
import 'package:get/get.dart';

class RouterUtils {
  // 跳转一个子页面
  static void jumpToChildPage(String url) {
    MainController mainController = Get.find<MainController>();
    MenuItem? menu;
    for (var menuItem in mainController.menuDataList) {
      if (menuItem.children != null) {
        menu = menuItem.children!.firstWhereOrNull((menu) => menu.url == url);
      } else if (menuItem.url == url) {
        menu = menuItem;
      }
      if (menu != null) break;
    }

    if (menu != null) mainController.onMenuTap(menu);
  }
}
