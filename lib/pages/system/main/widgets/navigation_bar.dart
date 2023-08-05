/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-24 11:10:08
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-04 14:57:36
 * @FilePath: /eatm_manager/lib/pages/system/main/widgets/navigation_bar.dart
 * @Description: 导航栏组件
 */
import 'package:eatm_manager/common/extension/main.dart';
import 'package:eatm_manager/common/routers/pages.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/pages/system/main/controller.dart';
import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:get/get.dart';

enum NavigationBarDisplayType {
  normal(value: 'normal'),
  drawer(value: 'drawer');

  const NavigationBarDisplayType({required this.value});
  final String value;
}

class NavigationBar extends StatefulWidget {
  const NavigationBar(
      {Key? key,
      required this.menuDataList,
      required this.currentTabUrl,
      required this.onMenuClick})
      : super(key: key);
  final List<MenuItem> menuDataList;
  final String? currentTabUrl;
  final Function(MenuItem)? onMenuClick;
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

const double expandWidth = 240;
const double collapseWidth = 100;
get globalTheme => GlobalTheme.instance;

class _NavigationBarState extends State<NavigationBar> {
  MainController get mainController => Get.find<MainController>();
  bool isHover = false;

  bool isCurrentMenu(MenuItem menu) {
    return widget.currentTabUrl == menu.url;
  }

  // 头部
  Widget _buildNavigationHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 15, 5),
      child: Image(
        height: 78,
        image: AssetImage(mainController.isCollapseNavigation.value
            ? 'assets/images/layout/eman_short.png'
            : 'assets/images/layout/eman.png'),
      ),
    );
  }

  // 菜单
  Widget _buildNavigationMenu() {
    return Material(
      color: Colors.transparent,
      child: ListView(
        children: [
          ...widget.menuDataList
              .map((e) => _buildNavigationMenuItem(e))
              .toList(),
        ],
      ),
    );
  }

  // 菜单项
  Widget _buildNavigationMenuItem(MenuItem menu) {
    var isCurrent = isCurrentMenu(menu);
    var isDarkMode = GlobalTheme.instance.isDarkMode;
    var isChildCurrent = menu.children != null &&
        menu.children!.any((element) => element.url == widget.currentTabUrl);
    if (menu.children != null && menu.children!.isNotEmpty) {
      return ExpansionTile(
        key: Key(menu.id!),
        initiallyExpanded: false,
        // backgroundColor: isDarkMode ? Color(0xff2b2c41) : Color(0xff2e3a51),
        // collapsedBackgroundColor:
        //     isDarkMode ? Color(0xff2b2c41) : Color(0xff2e3a51),
        leading: Icon(
          Icons.menu,
          color: isChildCurrent ? Colors.white : Color(0xffacb1b9),
          size: 20,
        ),
        title: Text(
          mainController.isCollapseNavigation.value ? '' : menu.name!,
          style: TextStyle(
              color: isChildCurrent ? Colors.white : Color(0xffacb1b9)),
        ),
        childrenPadding: EdgeInsets.only(
            left: mainController.isCollapseNavigation.value ? 0 : 20),
        children:
            menu.children!.map((e) => _buildNavigationMenuItem(e)).toList(),
      );
    }
    return Tooltip(
      message: mainController.isCollapseNavigation.value ? menu.name : '',
      textStyle: const TextStyle(
        fontSize: 14.0,
        color: Colors.white,
      ),
      child: ListTile(
        key: Key(menu.id!),
        tileColor: isCurrent
            ? (isDarkMode
                ? Color.fromARGB(237, 77, 79, 122)
                : Color.fromARGB(237, 66, 86, 126))
            : Colors.transparent,
        hoverColor: const Color(0xff2493dc).withOpacity(0.1),
        leading: Icon(
          MainChildPages.getIcon(menu.url!),
          color: isCurrent ? Colors.white : Color(0xffacb1b9),
          size: 20,
        ),
        title: Text(
          mainController.isCollapseNavigation.value ? '' : menu.name!,
          style: TextStyle(color: isCurrent ? Colors.white : Color(0xffacb1b9)),
        ),
        onTap: () {
          widget.onMenuClick!(menu);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: mainController.isCollapseNavigation.value
            ? collapseWidth
            : expandWidth,
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                        color: GlobalTheme.instance.isDarkMode
                            ? Color(0xef2d2e44)
                            : Color(0xef303C54),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.6),
                            offset: Offset(0.5, 0),
                            blurRadius: 10,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(children: [
                        _buildNavigationHeader(),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(
                            height: .5,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: _buildNavigationMenu(),
                        ),
                      ])),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            Positioned(
                top: 30,
                right: 0,
                child: Container(
                    clipBehavior: Clip.antiAlias,
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      // color: Color(0xffa492ff),
                      color: isHover
                          ? GlobalTheme.instance.accentColor
                          : Colors.white,
                      shape: BoxShape.circle,
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.black.withOpacity(0.5),
                      //     offset: Offset(0.5, 0),
                      //     blurRadius: 10,
                      //     spreadRadius: 0,
                      //   ),
                      // ],
                    ),
                    child: InkWell(
                      onHover: (value) {
                        setState(() {
                          isHover = value;
                        });
                      },
                      onTap: () {
                        // 处理按钮点击事件
                        setState(() {
                          mainController.isCollapseNavigation.value =
                              !mainController.isCollapseNavigation.value;
                          mainController.update(["main"]);
                        });
                      },
                      child: Icon(
                        mainController.isCollapseNavigation.value
                            ? fluent.FluentIcons.chevron_right
                            : fluent.FluentIcons.chevron_left,
                        size: 10,
                        color: isHover
                            ? Colors.white
                            : GlobalTheme.instance.accentColor,
                      ),
                      // hoverColor: Colors.blue,
                    )))
          ],
        ));
  }
}
