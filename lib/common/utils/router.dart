/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-30 11:03:50
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-08 11:17:04
 * @FilePath: /eatm_manager/lib/common/utils/router.dart
 * @Description: 路由工具类
 */

import 'package:eatm_manager/common/extension/main.dart';
import 'package:eatm_manager/common/utils/log.dart';
import 'package:eatm_manager/pages/system/main/controller.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';

class RouterUtils {
  static MainController get mainController => Get.find<MainController>();

  // 获取可跳转菜单
  static List<MenuItem> get jumpableMenuItems =>
      mainController.jumpableMenuList;

  // 跳转一个子页面
  static void jumpToChildPage(String url) {
    MenuItem? menu =
        jumpableMenuItems.firstWhereOrNull((menuItem) => menuItem.url == url);
    if (menu != null) mainController.onMenuTap(menu);
  }

  // 关闭其他子页面
  static void closeOtherChildPage(String url) {
    mainController.currentTabUrl = url;
    mainController.currentTabIndex.value = 1;
    mainController.currentTabKey = Key('menu-$url');
    mainController.tabs
        .removeWhere((tab) => tab.url != url && tab.url != '/home');
    mainController.update(['main']);
  }
}
