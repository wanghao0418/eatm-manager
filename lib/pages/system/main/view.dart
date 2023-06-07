import 'package:eatm_manager/common/index.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Tab;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../common/widgets/index.dart';
import 'index.dart';
import 'widgets/cached_page_view.dart';
import './widgets/fluent_tab.dart';

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
        print('onPageChanged: $value');
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
        FluentTab(
          key: controller.tabViewKey,
          currentIndex: controller.currentTabIndex.value,
          tabs: controller.tabs,
          onChanged: (value) {
            if (value == controller.currentTabIndex.value) return;
            controller.currentTabIndex.value = value;
            controller.currentTabKey = controller.tabs[value].key;
            controller.update(['main']);
          },
          footer: kIsWeb ? null : WindowButtons(),
        ),
        Expanded(child: _buildTabContent()),
      ]),
    );
  }

  // 主视图
  Widget _buildView(context) {
    return NavigationView(
      key: controller.viewKey,
      // appBar: kIsWeb
      //     ? null
      //     : NavigationAppBar(
      //         height: 40,
      //         automaticallyImplyLeading: false,
      //         actions: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      //           if (!kIsWeb) const WindowButtons(),
      //         ]),
      //       ),
      paneBodyBuilder: (item, child) {
        return _buildTabView(context);
      },
      pane: NavigationPane(
        key: controller.navigationPaneKey,
        size: const NavigationPaneSize(
          openWidth: 200,
        ),
        selected: controller.calculateSelectedIndex(),
        header: SizedBox(
          height: kOneLineTileHeight,
          child: ShaderMask(
            shaderCallback: (rect) {
              final color = AppTheme.systemAccentColor.defaultBrushFor(
                Get.theme.brightness,
              );
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
        items: controller.menuItems,
        autoSuggestBox: AutoSuggestBox(
          key: controller.searchKey,
          focusNode: controller.searchFocusNode,
          controller: controller.searchController,
          unfocusedColor: Colors.transparent,
          items:
              controller.canSelectMenuItems.whereType<PaneItem>().map((item) {
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
          body: _buildView(context),
        );
      },
    );
  }
}
