import 'package:eatm_manager/common/index.dart';
import 'package:eatm_manager/common/store/index.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/pages/system/main/widgets/navigation_bar.dart';
import 'package:eatm_manager/pages/system/main/widgets/setting_view.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Tab;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:window_manager/window_manager.dart';

import '../../../common/widgets/index.dart';
import 'index.dart';
import 'widgets/cached_page_view.dart';
import './widgets/fluent_tab.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => MainPageState();
}

late AnimationController animationController;
late Animation<Offset> slideAnimation;
late Animation<Offset> slideAnimationTop;
late Animation<double> fadeAnimation;
late Animation<double> sizeAnimationLeft;
late Animation<double> sizeAnimationTop;

class MainPageState extends State<MainPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    ));

    slideAnimationTop = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, -1.0),
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    ));

    sizeAnimationTop = Tween<double>(
      begin: 40.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    ));

    fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    ));

    animationController.addListener(() {
      var controller = Get.find<MainController>();
      if (animationController.isCompleted) {
        controller.isFullScreen.value = true;
        controller.update(['main']);
      } else if (animationController.isDismissed) {
        controller.update(['main']);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _MainViewGetX();
  }
}

class _MainViewGetX extends GetView<MainController> {
  const _MainViewGetX({Key? key}) : super(key: key);

  // tabContent
  Widget _buildTabContent() {
    return CachedPageView(
      initialPageIndex: controller.currentTabIndex.value,
      children: controller.tabs.isNotEmpty
          ? controller.tabs.map((Tab tab) {
              var page = MainChildPages.getPage(tab.url);
              return KeyedSubtree(
                key: Key('page-${tab.url}-${tab.id}'),
                child: page,
              );
            }).toList()
          : [Container()],
      onPageChanged: (value) {
        // print('onPageChanged: $value');
        // if (value == controller.currentTabIndex.value) return;
        // controller.currentTabIndex.value = value;
        // controller.currentTabKey = controller.tabs[value].key;
        // controller.update(['main']);
      },
      onPageControllerCreated: (pcontroller) {
        controller.pageController = pcontroller;
      },
    );
  }

  // tabView
  Widget _buildTabView(context) {
    return Container(
      child: Column(children: [
        // _buildCustomTab(context),
        if (!controller.isFullScreen.value)
          SlideTransition(
              position: slideAnimationTop,
              child: FadeTransition(
                  opacity: fadeAnimation,
                  child: Stack(
                    children: [
                      FluentTab(
                        key: controller.tabViewKey,
                        currentIndex: controller.currentTabIndex.value,
                        tabs: controller.tabs,
                        onChanged: (value) {
                          if (value == controller.currentTabIndex.value) return;
                          controller.currentTabIndex.value = value;
                          controller.currentTabKey = controller.tabs[value].key;
                          controller.currentTabUrl = controller.tabs[value].url;
                          controller.update(['main']);
                        },
                        // onReorder: (oldIndex, newIndex) {
                        //   controller.reorderTabs(oldIndex, newIndex);
                        // },
                        header: GlobalTheme.instance.navigationBarType ==
                                NavigationBarDisplayType.drawer
                            ? Builder(builder: (BuildContext context) {
                                return IconButton(
                                    icon: Icon(
                                      material.Icons.menu,
                                      size: 16,
                                      color:
                                          GlobalTheme.instance.buttonIconColor,
                                    ),
                                    onPressed: () {
                                      // controller.isFullScreen.value = true;
                                      material.Scaffold.of(context)
                                          .openDrawer();
                                      // controller.update(['main']);
                                    });
                              })
                            : null,
                        footer: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 5,
                            children: [
                              IconButton(
                                  icon: Icon(
                                    FluentIcons.full_screen,
                                    size: 16,
                                    color: GlobalTheme.instance.buttonIconColor,
                                  ),
                                  onPressed: () {
                                    // controller.isFullScreen.value = true;
                                    animationController.forward();
                                    controller.update(['main']);
                                  }),
                              IconButton(
                                  icon: Icon(
                                    FluentIcons.sign_out,
                                    size: 16,
                                    color: GlobalTheme.instance.buttonIconColor,
                                  ),
                                  onPressed: () => _signOut(context)),
                              IconButton(
                                  icon: Icon(
                                    FluentIcons.settings,
                                    size: 16,
                                    color: GlobalTheme.instance.buttonIconColor,
                                  ),
                                  onPressed: () => _openSettings(context)),
                              kIsWeb ? Container() : WindowButtons()
                            ]),
                      ),
                      const Positioned(
                          child: DragToMoveArea(
                              child: SizedBox(
                        width: double.infinity,
                        height: 40,
                      )))
                    ],
                  ))),
        Expanded(child: _buildTabContent())
      ]),
    );
  }

  // 打开设置弹窗
  void _openSettings(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return ContentDialog(
            title: const Text('设置').fontSize(24.sp),
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            content: Container(
              height: 500,
              child: SettingView(),
            ),
            actions: [
              Button(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('确定'),
              ),
            ],
          );
        });
  }

  // 退出
  void _signOut(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return ContentDialog(
            title: const Text('确认').fontSize(24.sp),
            constraints: const BoxConstraints(
              maxWidth: 300,
            ),
            content: Text(
              '确认退出当前用户么?',
              style: FluentTheme.of(context).typography.bodyLarge,
            ).fontSize(16),
            actions: [
              Button(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  UserStore.instance.onLogout();
                },
                child: const Text('确定'),
              ),
            ],
          );
        });
  }

  // 主视图
  Widget _buildView(context) {
    return Container(
      color: FluentTheme.of(context).acrylicBackgroundColor,
      child: Stack(children: [
        Row(
          children: [
            if (!controller.isFullScreen.value &&
                GlobalTheme.instance.navigationBarType !=
                    NavigationBarDisplayType.drawer)
              SlideTransition(
                position: slideAnimation,
                child: FadeTransition(
                  opacity: fadeAnimation,
                  child: NavigationBar(
                    currentTabUrl: controller.currentTabUrl,
                    menuDataList: controller.menuDataList,
                    onMenuClick: controller.onMenuTap,
                  ),
                ),
              ),
            Expanded(child: _buildTabView(context)),
          ],
        ),
      ]),
    );

    // fluent_ui NavigationView

    // return NavigationView(
    //   key: controller.viewKey,
    //   // appBar: kIsWeb
    //   //     ? null
    //   //     : NavigationAppBar(
    //   //         height: 40,
    //   //         automaticallyImplyLeading: false,
    //   //         actions: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
    //   //           if (!kIsWeb) const WindowButtons(),
    //   //         ]),
    //   //       ),
    //   paneBodyBuilder: (item, child) {
    //     return _buildTabView(context);
    //   },
    //   pane: NavigationPane(
    //     key: controller.navigationPaneKey,
    //     size: const NavigationPaneSize(
    //       openWidth: 200,
    //     ),
    //     selected: controller.calculateSelectedIndex(),
    //     header: SizedBox(
    //       height: kOneLineTileHeight,
    //       child: ShaderMask(
    //         shaderCallback: (rect) {
    //           final color = AppTheme.systemAccentColor.defaultBrushFor(
    //             Get.theme.brightness,
    //           );
    //           return LinearGradient(
    //             colors: [
    //               color,
    //               color,
    //             ],
    //           ).createShader(rect);
    //         },
    //         child: Image.asset(
    //           'assets/images/layout/eman.png',
    //           fit: BoxFit.cover,
    //         ),
    //       ),
    //     ),
    //     displayMode: PaneDisplayMode.compact,
    //     items: controller.menuItems,
    //     autoSuggestBox: AutoSuggestBox(
    //       key: controller.searchKey,
    //       focusNode: controller.searchFocusNode,
    //       controller: controller.searchController,
    //       unfocusedColor: Colors.transparent,
    //       items:
    //           controller.canSelectMenuItems.whereType<PaneItem>().map((item) {
    //         assert(item.title is Text);
    //         final text = (item.title as Text).data!;
    //         return AutoSuggestBoxItem(
    //           label: text,
    //           value: text,
    //           onSelected: () {
    //             item.onTap?.call();
    //             controller.searchController.clear();
    //           },
    //         );
    //       }).toList(),
    //       trailingIcon: IgnorePointer(
    //         child: IconButton(
    //           onPressed: () {
    //             controller.searchFocusNode.requestFocus();
    //           },
    //           icon: const Icon(FluentIcons.search),
    //         ),
    //       ),
    //       placeholder: 'Search',
    //     ),
    //     autoSuggestBoxReplacement: const Icon(FluentIcons.search),
    //     footerItems: controller.footerItems,
    //   ),
    //   // onOpenSearch: () {
    //   //   searchFocusNode.requestFocus();
    //   // },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      init: MainController(),
      id: "main",
      builder: (_) {
        return material.Scaffold(
          drawer: material.Drawer(
            width: controller.isCollapseNavigation.value ? 100 : 240,
            backgroundColor: Colors.transparent,
            child: NavigationBar(
              currentTabUrl: controller.currentTabUrl,
              menuDataList: controller.menuDataList,
              onMenuClick: controller.onMenuTap,
            ),
          ),
          floatingActionButton: controller.isFullScreen.value
              ? material.FloatingActionButton(
                  backgroundColor: GlobalTheme.instance.accentColor,
                  child: const Icon(
                    material.Icons.fullscreen_exit,
                    size: 24,
                  ),
                  onPressed: () {
                    controller.isFullScreen.value = false;
                    animationController.reverse();
                    controller.update(['main']);
                  },
                )
              : null,
          body: _buildView(context),
        );
      },
    );
  }
}
