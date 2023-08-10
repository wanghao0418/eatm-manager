import 'package:eatm_manager/common/api/menu.dart';
import 'package:eatm_manager/common/extension/main.dart';
import 'package:eatm_manager/common/index.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Tab;
import 'package:flutter/foundation.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
// import 'package:flutter/material.dart' as material;
import 'package:get/get.dart';
import './widgets/fluent_tab.dart';

import '../../../common/utils/http.dart';

class MainController extends GetxController {
  MainController();
  final viewKey = GlobalKey(debugLabel: 'Navigation View Key');
  final searchKey = GlobalKey(debugLabel: 'Search Bar Key');
  final tabViewKey = GlobalKey(debugLabel: 'Tab View Key');
  final navigationPaneKey = GlobalKey(debugLabel: 'Navigation Pane Key');
  final searchFocusNode = FocusNode();
  final searchController = TextEditingController();
  late PageController pageController;
  var currentTabIndex = 0.obs;
  // 是否全屏
  var isFullScreen = false.obs;
  // 是否收缩导航
  var isCollapseNavigation = false.obs;

  Key? currentTabKey;
  String? currentTabUrl;
  List<Tab> tabs = [];
  List<MenuItem> menuDataList = [
    // MenuItem(
    //   id: '99',
    //   url: '/home',
    //   name: '首页',
    // )
  ];
  // final List<NavigationPaneItem> menuItems = [];
  // final List<NavigationPaneItem> footerItems = [
  //   PaneItemSeparator(),
  //   PaneItem(
  //     key: const Key('/settings'),
  //     icon: const Icon(FluentIcons.settings),
  //     title: const Text('Settings'),
  //     body: const SizedBox.shrink(),
  //     onTap: () {},
  //   ),
  // ];

  _initData() {
    update(["main"]);
  }

  // 获取菜单
  getMenuList() async {
    ResponseApiBody response = await MenuApi.getMenuList();
    if (response.success == true) {
      var dataList =
          (response.data as List).map((e) => MenuItem.fromJson(e)).toList();
      dataList.sort((a, b) => a.orderBy!.compareTo(b.orderBy!));
      // menuItems.clear();
      var childrenKeys = [];
      for (var menu in dataList) {
        if (menu.url!.isNotEmpty) {
          menuDataList.add(menu);
          // menuItems.add(PaneItem(
          //   key: Key('menu-${menu.url}-${menu.id}'),
          //   icon: Icon(MainChildPages.getIcon(menu.url!)),
          //   title: Text(menu.name ?? ''),
          //   body: const SizedBox.shrink(),
          //   onTap: () => onMenuTap(menu),
          // ));
        } else {
          var childrenList =
              dataList.where((element) => element.pid == menu.id).toList();
          childrenKeys
              .addAll(childrenList.map((e) => Key('menu-${e.url}')).toList());
          menu.children = childrenList;
          menuDataList.add(menu);
          // menuItems.add(
          //   PaneItemExpander(
          //       key: Key('expand-menu-${menu.id!}'),
          //       title: Text(menu.name ?? ''),
          //       icon: const Icon(FluentIcons.list),
          //       // onItemPressed: (value) {
          //       //   var index = childrenKeys
          //       //       .indexWhere((element) => element == value.key);
          //       //   if (index > -1) {
          //       //     onMenuTap(childrenList[index]);
          //       //   }
          //       // },
          //       items: childrenList
          //           .map((e) => PaneItem(
          //                 key: Key('menu-${e.url}-${e.id}'),
          //                 icon: Icon(MainChildPages.getIcon(e.url!)),
          //                 title: Text(e.name ?? ''),
          //                 body: const SizedBox.shrink(),
          //                 onTap: () => onMenuTap(e),
          //               ))
          //           .toList(),
          //       body: const SizedBox.shrink(),
          //       infoBadge:
          //           InfoBadge(source: Text(childrenList.length.toString()))),
          // );
        }
      }
      menuDataList.removeWhere(
          (element) => childrenKeys.contains(Key('menu-${element.url!}')));
      if (menuDataList.isNotEmpty) {
        // 打开第一个菜单
        //如果第一个菜单是父级菜单，则打开第一个子菜单
        if (menuDataList.first.children == null) {
          onMenuTap(menuDataList.first);
        } else {
          onMenuTap(menuDataList.first.children!.first);
        }
      }
      // menuItems.removeWhere((element) => childrenKeys.contains(element.key));
      // if (menuItems.isNotEmpty) {
      //   // menuItems.insert(0, PaneItemSeparator());
      //   onMenuTap(menuDataList.first);
      // }
      update(["main"]);
    }
  }

  // 获取可选菜单
  // List<NavigationPaneItem> get canSelectMenuItems {
  //   List<NavigationPaneItem> items = [];
  //   for (var item in menuItems) {
  //     if (item is PaneItemExpander) {
  //       items.addAll([...item.items]);
  //     } else {
  //       items.add(item);
  //     }
  //   }
  //   return items;
  // }

  // 计算当前选中的菜单项
  // int calculateSelectedIndex() {
  //   // final location = Get.currentRoute;
  //   var flatMenuItems = [];
  //   for (var item in menuItems) {
  //     if (item is PaneItemExpander) {
  //       flatMenuItems.addAll([item, ...item.items]);
  //     } else {
  //       flatMenuItems.add(item);
  //     }
  //   }
  //   int indexOriginal = flatMenuItems
  //       .where((element) => element.key != null)
  //       .toList()
  //       .indexWhere((element) => element.key == currentTabKey);

  //   if (indexOriginal == -1) {
  //     int indexFooter = footerItems
  //         .where((element) => element.key != null)
  //         .toList()
  //         .indexWhere((element) => element.key == currentTabKey);
  //     if (indexFooter == -1) {
  //       return 0;
  //     }
  //     return flatMenuItems
  //             .where((element) => element.key != null)
  //             .toList()
  //             .length +
  //         indexFooter;
  //   } else {
  //     return indexOriginal;
  //   }
  // }

  // 切换菜单
  void onMenuTap(MenuItem menu) {
    var (url, title, id) = (menu.url!, menu.name!, menu.id!);

    // 没有tab则新增并打开
    if (tabs.firstWhereOrNull((e) => e.key == Key('menu-$url')) == null) {
      tabs.add(Tab(
        key: Key('menu-$url'),
        text: Text(title),
        icon: Icon(MainChildPages.getIcon(url)),
        url: url,
        id: id,
        closeIcon: menu.url == '/home' ? null : FluentIcons.chrome_close,
        onClosed: () {
          if (tabs.length == 1) {
            return;
          }
          tabs.removeWhere((element) => element.key == Key('menu-$url'));
          if (currentTabKey == Key('menu-$url')) {
            // 关闭当前tab 则打开下一个tab 如果没有下一个tab 则打开最后一个tab
            if (tabs.length > currentTabIndex.value) {
              currentTabKey = tabs[currentTabIndex.value].key;
              currentTabUrl = tabs[currentTabIndex.value].url;
            } else {
              currentTabKey = tabs.last.key;
              currentTabIndex.value = tabs.length - 1;
              currentTabUrl = tabs.last.url;
            }
          } else {
            currentTabIndex.value =
                tabs.indexWhere((element) => element.key == currentTabKey);
          }
          update(["main"]);
        },
      ));
      currentTabIndex.value = tabs.length - 1;
      currentTabKey = Key('menu-$url');
      currentTabUrl = url;
      // }
    } else {
      currentTabIndex.value =
          tabs.indexWhere((element) => element.key == Key('menu-$url'));
      currentTabKey = Key('menu-$url');
      currentTabUrl = url;
    }
    update(["main"]);
  }

  @override
  void onInit() {
    super.onInit();
    currentTabIndex.listen((value) {
      // pageController.animateToPage(
      //   value,
      //   duration: Duration(milliseconds: 300),
      //   curve: Curves.easeInOut,
      // );
      pageController.jumpToPage(value);
    });
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
    PopupMessage.showLoading();
    Future.delayed(Duration(seconds: 1), () {
      PopupMessage.closeLoading();
      getMenuList();
    });
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
