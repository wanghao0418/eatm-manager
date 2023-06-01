import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as material;
import 'package:get/get.dart';

import '../../../common/widgets/index.dart';
import 'index.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _MainViewGetX();
  }
}

class _MainViewGetX extends GetView<MainController> {
  const _MainViewGetX({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return NavigationView(
      key: controller.viewKey,
      // appBar: kIsWeb
      //     ? null
      //     : NavigationAppBar(
      //         height: 40.r,
      //         automaticallyImplyLeading: false,
      //         // leading: () {
      //         //   if (kIsWeb) return null;
      //         //   final enabled = widget.shellContext != null && router.canPop();

      //         //   final onPressed = enabled
      //         //       ? () {
      //         //           if (router.canPop()) {
      //         //             context.pop();
      //         //             setState(() {});
      //         //           }
      //         //         }
      //         //       : null;
      //         //   return NavigationPaneTheme(
      //         //     data: NavigationPaneTheme.of(context).merge(NavigationPaneThemeData(
      //         //       unselectedIconColor: ButtonState.resolveWith((states) {
      //         //         if (states.isDisabled) {
      //         //           return ButtonThemeData.buttonColor(context, states);
      //         //         }
      //         //         return ButtonThemeData.uncheckedInputColor(
      //         //           FluentTheme.of(context),
      //         //           states,
      //         //         ).basedOnLuminance();
      //         //       }),
      //         //     )),
      //         //     child: Builder(
      //         //       builder: (context) => PaneItem(
      //         //         icon: const Center(child: Icon(FluentIcons.back, size: 12.0)),
      //         //         title: Text(localizations.backButtonTooltip),
      //         //         body: const SizedBox.shrink(),
      //         //         enabled: enabled,
      //         //       ).build(
      //         //         context,
      //         //         false,
      //         //         onPressed,
      //         //         displayMode: PaneDisplayMode.compact,
      //         //       ),
      //         //     ),
      //         //   );
      //         // }(),
      //         // title: () {
      //         //   if (kIsWeb) {
      //         //     return const Align(
      //         //       alignment: AlignmentDirectional.centerStart,
      //         //       child: Text(appTitle),
      //         //     );
      //         //   }
      //         //   return const DragToMoveArea(
      //         //     child: Align(
      //         //       alignment: AlignmentDirectional.centerStart,
      //         //       child: Text(appTitle),
      //         //     ),
      //         //   );
      //         // }(),
      //         actions: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      //           // Container(
      //           //   height: double.infinity,
      //           //   padding: EdgeInsets.only(right: 10),
      //           //   alignment: AlignmentDirectional.centerEnd,
      //           //   child: ToggleSwitch(
      //           //     content: const Text('Dark mode'),
      //           //     checked: FluentTheme.of(context).brightness.isDark,
      //           //     onChanged: (v) {
      //           //       // if (v) {
      //           //       //   appTheme.mode = ThemeMode.dark;
      //           //       // } else {
      //           //       //   appTheme.mode = ThemeMode.light;
      //           //       // }
      //           //       Get.changeThemeMode(v ? ThemeMode.dark : ThemeMode.light);
      //           //     },
      //           //   ),
      //           // ),
      //           if (!kIsWeb) const WindowButtons(),
      //         ]),
      //       ),
      paneBodyBuilder: (item, child) {
        return TabView(
          currentIndex: controller.currentTabIndex.value,
          tabs: controller.tabs,
          onChanged: (value) {
            controller.currentTabIndex.value = value;
            controller.currentTabKey = controller.tabs![value].key;
            controller.update(["main"]);
          },
          onReorder: (oldIndex, newIndex) {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final item = controller.tabs!.removeAt(oldIndex);
            controller.tabs!.insert(newIndex, item);

            if (controller.currentTabIndex.value == newIndex) {
              controller.currentTabIndex.value = oldIndex;
            } else if (controller.currentTabIndex.value == oldIndex) {
              controller.currentTabIndex.value = newIndex;
            }
            controller.update(["main"]);
          },
          footer: kIsWeb ? null : WindowButtons(),
        );
      },
      pane: NavigationPane(
        selected: controller.calculateSelectedIndex(),
        header: SizedBox(
          height: kOneLineTileHeight,
          child: ShaderMask(
            shaderCallback: (rect) {
              // final color = appTheme.color.defaultBrushFor(
              //   theme.brightness,
              // );
              final color = Colors.blue;
              return LinearGradient(
                colors: [
                  color,
                  color,
                ],
              ).createShader(rect);
            },
            child: Image.asset(
              'assets/images/layout/eman.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        displayMode: PaneDisplayMode.compact,
        // indicator: () {
        //   switch (appTheme.indicator) {
        //     case NavigationIndicators.end:
        //       return const EndNavigationIndicator();
        //     case NavigationIndicators.sticky:
        //     default:
        //       return const StickyNavigationIndicator();
        //   }
        // }(),
        items: controller.menuItems,
        autoSuggestBox: AutoSuggestBox(
          key: controller.searchKey,
          focusNode: controller.searchFocusNode,
          controller: controller.searchController,
          unfocusedColor: Colors.transparent,
          items: controller.menuItems.whereType<PaneItem>().map((item) {
            assert(item.title is Text);
            final text = (item.title as Text).data!;
            return AutoSuggestBoxItem(
              label: text,
              value: text,
              onSelected: () {
                item.onTap?.call();
                controller.searchController.clear();
              },
            );
          }).toList(),
          trailingIcon: IgnorePointer(
            child: IconButton(
              onPressed: () {
                controller.searchFocusNode.requestFocus();
              },
              icon: const Icon(FluentIcons.search),
            ),
          ),
          placeholder: 'Search',
        ),
        autoSuggestBoxReplacement: const Icon(FluentIcons.search),
        footerItems: controller.footerItems,
      ),
      // onOpenSearch: () {
      //   searchFocusNode.requestFocus();
      // },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      init: MainController(),
      id: "main",
      builder: (_) {
        return material.Scaffold(
          body: _buildView(),
        );
      },
    );
  }
}
