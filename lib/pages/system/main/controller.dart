import 'package:eatm_manager/common/api/menu.dart';
import 'package:eatm_manager/common/extension/main.dart';
import 'package:eatm_manager/common/index.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';

import '../../../common/utils/http.dart';

class MainController extends GetxController {
  MainController();
  final viewKey = GlobalKey(debugLabel: 'Navigation View Key');
  final searchKey = GlobalKey(debugLabel: 'Search Bar Key');
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
            key: Key(menu.url!),
            icon: Icon(FluentIcons.home),
            title: Text(menu.name ?? ''),
            body: SizedBox.shrink(),
            onTap: () => onMenuTap(menu.url!, menu.name!),
          ));
        } else {
          var childrenList =
              dataList.where((element) => element.pid == menu.id).toList();
          childrenKeys.addAll(childrenList.map((e) => Key(e.url!)).toList());
          menu.children = childrenList;
          menuDataList.add(menu);
          menuItems.add(PaneItemExpander(
              key: Key(menu.name!),
              title: Text(menu.name ?? ''),
              icon: Icon(FluentIcons.list),
              items: childrenList
                  .map((e) => PaneItem(
                        key: Key(e.url!),
                        icon: Icon(FluentIcons.home),
                        title: Text(e.name ?? ''),
                        body: SizedBox.shrink(),
                        onTap: () => onMenuTap(e.url!, e.name!),
                      ))
                  .toList(),
              body: SizedBox.shrink()));
        }
      }
      menuDataList
          .removeWhere((element) => childrenKeys.contains(Key(element.url!)));
      menuItems.removeWhere((element) => childrenKeys.contains(element.key));
      if (menuItems.isNotEmpty) {
        // menuItems.insert(0, PaneItemSeparator());
        onMenuTap(menuDataList[0].url!, menuDataList[0].name!);
      }
      update(["main"]);
    }
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
  void onMenuTap(String url, String title) {
    if (tabs.firstWhereOrNull((e) => e.key == Key(url)) == null) {
      tabs.add(Tab(
        key: Key(url),
        text: Text(title),
        body: MainChildPages.getPage(url),
        onClosed: () {
          if (tabs.length == 1) {
            return;
          }
          tabs.removeWhere((element) => element.key == Key(url));
          currentTabIndex.value = tabs.length - 1;
          currentTabKey = tabs.last.key;
          update(["main"]);
        },
      ));
      currentTabIndex.value = tabs.length - 1;
      currentTabKey = Key(url);
      update(["main"]);
    } else {
      currentTabIndex.value =
          tabs.indexWhere((element) => element.key == Key(url));
      currentTabKey = Key(url);
      update(["main"]);
    }
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
