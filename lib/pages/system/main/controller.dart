import 'dart:async';

import 'package:eatm_manager/common/api/menu.dart';
import 'package:eatm_manager/common/extension/main.dart';
import 'package:eatm_manager/common/index.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Tab;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import './widgets/fluent_tab.dart';

import '../../../common/utils/http.dart';

// const double kTileHeight = 34.0;
// const double kMinTileWidth = 80.0;
// const double kMaxTileWidth = 240.0;
// const double kButtonWidth = 32.0;

class MainController extends GetxController {
  MainController();
  final viewKey = GlobalKey(debugLabel: 'Navigation View Key');
  final searchKey = GlobalKey(debugLabel: 'Search Bar Key');
  final tabViewKey = GlobalKey(debugLabel: 'Tab View Key');
  final navigationPaneKey = GlobalKey(debugLabel: 'Navigation Pane Key');
  final searchFocusNode = FocusNode();
  final searchController = TextEditingController();
  var currentTabIndex = 0.obs;
  Key? currentTabKey;
  List<Tab> tabs = [];
  List<MenuItem> menuDataList = [];
  final List<NavigationPaneItem> menuItems = [];
  final List<NavigationPaneItem> footerItems = [
    PaneItemSeparator(),
    PaneItem(
      key: const Key('/settings'),
      icon: const Icon(FluentIcons.settings),
      title: const Text('Settings'),
      body: const SizedBox.shrink(),
      onTap: () {},
    ),
  ];

  _initData() {
    update(["main"]);
  }

  // 获取菜单
  getMenuList() async {
    ResponseApiBody response = await MenuApi.getMenuList();
    if (response.success == true) {
      var dataList =
          (response.data as List).map((e) => MenuItem.fromJson(e)).toList();
      menuItems.clear();
      var childrenKeys = [];
      for (var menu in dataList) {
        if (menu.url!.isNotEmpty) {
          menuDataList.add(menu);
          menuItems.add(PaneItem(
            key: Key('menu-${menu.url}-${menu.id}'),
            icon: Icon(MainChildPages.getIcon(menu.url!)),
            title: Text(menu.name ?? ''),
            body: const SizedBox.shrink(),
            onTap: () => onMenuTap(menu),
          ));
        } else {
          var childrenList =
              dataList.where((element) => element.pid == menu.id).toList();
          childrenKeys.addAll(
              childrenList.map((e) => Key('menu-${e.url}-${e.id}')).toList());
          menu.children = childrenList;
          menuDataList.add(menu);
          menuItems.add(
            PaneItemExpander(
                key: Key('expand-menu-${menu.id!}'),
                title: Text(menu.name ?? ''),
                icon: const Icon(FluentIcons.list),
                items: childrenList
                    .map((e) => PaneItem(
                          key: Key('menu-${e.url}-${e.id}'),
                          icon: Icon(MainChildPages.getIcon(e.url!)),
                          title: Text(e.name ?? ''),
                          body: const SizedBox.shrink(),
                          onTap: () => onMenuTap(e),
                        ))
                    .toList(),
                body: const SizedBox.shrink(),
                infoBadge:
                    InfoBadge(source: Text(childrenList.length.toString()))),
          );
        }
      }
      menuDataList.removeWhere((element) =>
          childrenKeys.contains(Key('menu-${element.url!}-${element.id}')));
      menuItems.removeWhere((element) => childrenKeys.contains(element.key));
      if (menuItems.isNotEmpty) {
        // menuItems.insert(0, PaneItemSeparator());
        onMenuTap(menuDataList.first);
      }
      update(["main"]);
    }
  }

  // 获取可选菜单
  List<NavigationPaneItem> get canSelectMenuItems {
    List<NavigationPaneItem> items = [];
    for (var item in menuItems) {
      if (item is PaneItemExpander) {
        items.addAll([...item.items]);
      } else {
        items.add(item);
      }
    }
    return items;
  }

  // 计算当前选中的菜单项
  int calculateSelectedIndex() {
    // final location = Get.currentRoute;
    var flatMenuItems = [];
    for (var item in menuItems) {
      if (item is PaneItemExpander) {
        flatMenuItems.addAll([item, ...item.items]);
      } else {
        flatMenuItems.add(item);
      }
    }
    int indexOriginal = flatMenuItems
        .where((element) => element.key != null)
        .toList()
        .indexWhere((element) => element.key == currentTabKey);

    if (indexOriginal == -1) {
      int indexFooter = footerItems
          .where((element) => element.key != null)
          .toList()
          .indexWhere((element) => element.key == currentTabKey);
      if (indexFooter == -1) {
        return 0;
      }
      return flatMenuItems
              .where((element) => element.key != null)
              .toList()
              .length +
          indexFooter;
    } else {
      return indexOriginal;
    }
  }

  // 切换菜单
  void onMenuTap(MenuItem menu) {
    var (url, title, id) = (menu.url!, menu.name!, menu.id!);

    // 没有tab则新增并打开
    if (tabs.firstWhereOrNull((e) => e.key == Key('menu-$url-$id')) == null) {
      tabs.add(Tab(
        key: Key('menu-$url-$id'),
        text: Text(title),
        icon: Icon(MainChildPages.getIcon(url)),
        url: url,
        id: id,
        onClosed: () {
          if (tabs.length == 1) {
            return;
          }
          tabs.removeWhere((element) => element.key == Key('menu-$url-$id'));
          if (currentTabKey == Key('menu-$url-$id')) {
            currentTabKey = tabs.last.key;
            currentTabIndex.value = tabs.length - 1;
          } else {
            currentTabIndex.value =
                tabs.indexWhere((element) => element.key == currentTabKey);
          }
          update(["main"]);
        },
      ));
      currentTabIndex.value = tabs.length - 1;
      currentTabKey = Key('menu-$url-$id');
      // }
    } else {
      currentTabIndex.value =
          tabs.indexWhere((element) => element.key == Key('menu-$url-$id'));
      currentTabKey = Key('menu-$url-$id');
    }
    update(["main"]);
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
    getMenuList();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
