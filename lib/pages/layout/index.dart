import 'package:eatm_manager/common/icons.dart';
import 'package:eatm_manager/common/request.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Page;
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:window_manager/window_manager.dart';
import 'package:styled_widget/styled_widget.dart';
import '../../api/menu_api.dart';
import '../../routes/router.dart';
import '../../theme.dart';

class Layout extends StatefulWidget {
  const Layout({
    super.key,
    required this.child,
    required this.shellContext,
    required this.state,
  });

  final Widget child;
  final BuildContext? shellContext;
  final GoRouterState state;

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> with WindowListener {
  bool value = false;
  static const String appTitle = 'Eman自动化';

  // int index = 0;

  final viewKey = GlobalKey(debugLabel: 'Navigation View Key');
  final searchKey = GlobalKey(debugLabel: 'Search Bar Key');
  final searchFocusNode = FocusNode();
  final searchController = TextEditingController();

  final List<NavigationPaneItem> originalItems = [
    PaneItem(
      key: const Key('/'),
      icon: const Icon(FluentIcons.home),
      title: const Text('首页'),
      body: const SizedBox.shrink(),
      onTap: () {
        if (router.location != '/') router.pushNamed('home');
      },
    ),
    PaneItem(
      key: const Key('/dashboard'),
      icon: Icon(MyIcons.workmanship),
      title: const Text('工艺绑定'),
      body: const SizedBox.shrink(),
      onTap: () {
        if (router.location != '/dashboard') {
          router.pushNamed('dashboard');
        }
      },
    ),
    // PaneItemHeader(header: const Text('Inputs')),
    PaneItem(
      key: const Key('/interchangeStation'),
      icon: const Icon(FluentIcons.button_control),
      title: const Text('接驳站'),
      body: const SizedBox.shrink(),
      onTap: () {
        if (router.location != '/interchangeStation') {
          router.pushNamed('interchangeStation');
        }
      },
    ),
    // PaneItem(
    //   key: const Key('/inputs/checkbox'),
    //   icon: const Icon(FluentIcons.checkbox_composite),
    //   title: const Text('Checkbox'),
    //   body: const SizedBox.shrink(),
    //   onTap: () {
    //     if (router.location != '/inputs/checkbox') {
    //       router.pushNamed('inputs_checkbox');
    //     }
    //   },
    // ),
    // PaneItem(
    //   key: const Key('/inputs/slider'),
    //   icon: const Icon(FluentIcons.slider),
    //   title: const Text('Slider'),
    //   body: const SizedBox.shrink(),
    //   onTap: () {
    //     if (router.location != '/inputs/slider') {
    //       router.pushNamed('inputs_slider');
    //     }
    //   },
    // ),
    // PaneItem(
    //   key: const Key('/inputs/toggle_switch'),
    //   icon: const Icon(FluentIcons.toggle_left),
    //   title: const Text('ToggleSwitch'),
    //   body: const SizedBox.shrink(),
    //   onTap: () {
    //     if (router.location != '/inputs/toggle_switch') {
    //       router.pushNamed('inputs_toggle_switch');
    //     }
    //   },
    // ),
    // PaneItemHeader(header: const Text('Form')),
    // PaneItem(
    //   key: const Key('/forms/text_box'),
    //   icon: const Icon(FluentIcons.text_field),
    //   title: const Text('TextBox'),
    //   body: const SizedBox.shrink(),
    //   onTap: () {
    //     if (router.location != '/forms/text_box') {
    //       router.pushNamed('forms_text_box');
    //     }
    //   },
    // ),
    // PaneItem(
    //   key: const Key('/forms/auto_suggest_box'),
    //   icon: const Icon(FluentIcons.page_list),
    //   title: const Text('AutoSuggestBox'),
    //   body: const SizedBox.shrink(),
    //   onTap: () {
    //     if (router.location != '/forms/auto_suggest_box') {
    //       router.pushNamed('forms_auto_suggest_box');
    //     }
    //   },
    // ),
    // PaneItem(
    //   key: const Key('/forms/combobox'),
    //   icon: const Icon(FluentIcons.combobox),
    //   title: const Text('ComboBox'),
    //   body: const SizedBox.shrink(),
    //   onTap: () {
    //     if (router.location != '/forms/combobox') {
    //       router.pushNamed('forms_combobox');
    //     }
    //   },
    // ),
    // PaneItem(
    //   key: const Key('/forms/numberbox'),
    //   icon: const Icon(FluentIcons.number),
    //   title: const Text('NumberBox'),
    //   body: const SizedBox.shrink(),
    //   onTap: () {
    //     if (router.location != '/forms/numberbox') {
    //       router.pushNamed('forms_numberbox');
    //     }
    //   },
    // ),
    // PaneItem(
    //   key: const Key('/forms/passwordbox'),
    //   icon: const Icon(FluentIcons.password_field),
    //   title: const Text('PasswordBox'),
    //   body: const SizedBox.shrink(),
    //   onTap: () {
    //     if (router.location != '/forms/passwordbox') {
    //       router.pushNamed('forms_passwordbox');
    //     }
    //   },
    // ),
    // PaneItem(
    //   key: const Key('/forms/time_picker'),
    //   icon: const Icon(FluentIcons.time_picker),
    //   title: const Text('TimePicker'),
    //   body: const SizedBox.shrink(),
    //   onTap: () {
    //     if (router.location != '/forms/time_picker') {
    //       router.pushNamed('forms_time_picker');
    //     }
    //   },
    // ),
    // PaneItem(
    //   key: const Key('/forms/date_picker'),
    //   icon: const Icon(FluentIcons.date_time),
    //   title: const Text('DatePicker'),
    //   body: const SizedBox.shrink(),
    //   onTap: () {
    //     if (router.location != '/forms/date_picker') {
    //       router.pushNamed('forms_date_picker');
    //     }
    //   },
    // ),
    // PaneItemHeader(header: const Text('Navigation')),
    // PaneItem(
    //   key: const Key('/navigation/nav_view'),
    //   icon: const Icon(FluentIcons.navigation_flipper),
    //   title: const Text('NavigationView'),
    //   body: const SizedBox.shrink(),
    //   onTap: () {
    //     if (router.location != '/navigation/nav_view') {
    //       router.pushNamed('navigation_nav_view');
    //     }
    //   },
    // ),
    // PaneItem(
    //   key: const Key('/navigation/tab_view'),
    //   icon: const Icon(FluentIcons.table_header_row),
    //   title: const Text('TabView'),
    //   body: const SizedBox.shrink(),
    //   onTap: () {
    //     if (router.location != '/navigation/tab_view') {
    //       router.pushNamed('navigation_tab_view');
    //     }
    //   },
    // ),
    // PaneItem(
    //   key: const Key('/navigation/tree_view'),
    //   icon: const Icon(FluentIcons.bulleted_tree_list),
    //   title: const Text('TreeView'),
    //   body: const SizedBox.shrink(),
    //   onTap: () {
    //     if (router.location != '/navigation/tree_view') {
    //       router.pushNamed('navigation_tree_view');
    //     }
    //   },
    // ),
    // PaneItemHeader(header: const Text('Surfaces')),
    // PaneItem(
    //   key: const Key('/surfaces/acrylic'),
    //   icon: const Icon(FluentIcons.un_set_color),
    //   title: const Text('Acrylic'),
    //   body: const SizedBox.shrink(),
    //   onTap: () {
    //     if (router.location != '/surfaces/acrylic') {
    //       router.pushNamed('surfaces_acrylic');
    //     }
    //   },
    // ),
    // PaneItem(
    //   key: const Key('/surfaces/command_bar'),
    //   icon: const Icon(FluentIcons.customize_toolbar),
    //   title: const Text('CommandBar'),
    //   body: const SizedBox.shrink(),
    //   onTap: () {
    //     if (router.location != '/surfaces/command_bar') {
    //       router.pushNamed('surfaces_command_bar');
    //     }
    //   },
    // ),
    // PaneItem(
    //   key: const Key('/surfaces/expander'),
    //   icon: const Icon(FluentIcons.expand_all),
    //   title: const Text('Expander'),
    //   body: const SizedBox.shrink(),
    //   onTap: () {
    //     if (router.location != '/surfaces/expander') {
    //       router.pushNamed('surfaces_expander');
    //     }
    //   },
    // ),
    // PaneItem(
    //   key: const Key('/surfaces/info_bar'),
    //   icon: const Icon(FluentIcons.info_solid),
    //   title: const Text('InfoBar'),
    //   body: const SizedBox.shrink(),
    //   onTap: () {
    //     if (router.location != '/surfaces/info_bar') {
    //       router.pushNamed('surfaces_info_bar');
    //     }
    //   },
    // ),
    // PaneItem(
    //   key: const Key('/surfaces/progress_indicators'),
    //   icon: const Icon(FluentIcons.progress_ring_dots),
    //   title: const Text('Progress Indicators'),
    //   body: const SizedBox.shrink(),
    //   onTap: () {
    //     if (router.location != '/surfaces/progress_indicators') {
    //       router.pushNamed('surfaces_progress_indicators');
    //     }
    //   },
    // ),
    // PaneItem(
    //   key: const Key('/surfaces/tiles'),
    //   icon: const Icon(FluentIcons.tiles),
    //   title: const Text('Tiles'),
    //   body: const SizedBox.shrink(),
    //   onTap: () {
    //     if (router.location != '/surfaces/tiles') {
    //       router.pushNamed('surfaces_tiles');
    //     }
    //   },
    // ),
    // PaneItemHeader(header: const Text('Popups')),
    // PaneItem(
    //   key: const Key('/popups/content_dialog'),
    //   icon: const Icon(FluentIcons.comment_urgent),
    //   title: const Text('ContentDialog'),
    //   body: const SizedBox.shrink(),
    //   onTap: () {
    //     if (router.location != '/popups/content_dialog') {
    //       router.pushNamed('popups_content_dialog');
    //     }
    //   },
    // ),
    // PaneItem(
    //   key: const Key('/popups/tooltip'),
    //   icon: const Icon(FluentIcons.hint_text),
    //   title: const Text('Tooltip'),
    //   body: const SizedBox.shrink(),
    //   onTap: () {
    //     if (router.location != '/popups/tooltip') {
    //       router.pushNamed('popups_tooltip');
    //     }
    //   },
    // ),
    // PaneItem(
    //   key: const Key('/popups/flyout'),
    //   icon: const Icon(FluentIcons.pop_expand),
    //   title: const Text('Flyout'),
    //   body: const SizedBox.shrink(),
    //   onTap: () {
    //     if (router.location != '/popups/flyout') {
    //       router.pushNamed('popups_flyout');
    //     }
    //   },
    // ),
    // PaneItemHeader(header: const Text('Theming')),
    // PaneItem(
    //   key: const Key('/theming/colors'),
    //   icon: const Icon(FluentIcons.color_solid),
    //   title: const Text('Colors'),
    //   body: const SizedBox.shrink(),
    //   onTap: () {
    //     if (router.location != '/theming/colors') {
    //       router.pushNamed('theming_colors');
    //     }
    //   },
    // ),
    // PaneItem(
    //   key: const Key('/theming/typography'),
    //   icon: const Icon(FluentIcons.font_color_a),
    //   title: const Text('Typography'),
    //   body: const SizedBox.shrink(),
    //   onTap: () {
    //     if (router.location != '/theming/typography') {
    //       router.pushNamed('theming_typography');
    //     }
    //   },
    // ),
    // PaneItem(
    //   key: const Key('/theming/icons'),
    //   icon: const Icon(FluentIcons.icon_sets_flag),
    //   title: const Text('Icons'),
    //   body: const SizedBox.shrink(),
    //   onTap: () {
    //     if (router.location != '/theming/icons') {
    //       router.pushNamed('theming_icons');
    //     }
    //   },
    // ),
    // PaneItem(
    //   key: const Key('/theming/reveal_focus'),
    //   icon: const Icon(FluentIcons.focus),
    //   title: const Text('Reveal Focus'),
    //   body: const SizedBox.shrink(),
    //   onTap: () {
    //     if (router.location != '/theming/reveal_focus') {
    //       router.pushNamed('theming_reveal_focus');
    //     }
    //   },
    // ),
  ];
  final List<NavigationPaneItem> footerItems = [
    PaneItemSeparator(),
    PaneItem(
      key: const Key('/settings'),
      icon: const Icon(FluentIcons.settings),
      title: const Text('Settings'),
      body: const SizedBox.shrink(),
      onTap: () {
        if (router.location != '/settings') {
          router.pushNamed('settings');
        }
      },
    ),
    // _LinkPaneItemAction(
    //   icon: const Icon(FluentIcons.open_source),
    //   title: const Text('Source code'),
    //   link: 'https://github.com/bdlukaa/fluent_ui',
    //   body: const SizedBox.shrink(),
    // ),
    // TODO: mobile widgets, Scrollbar, BottomNavigationBar, RatingBar
  ];

  getMenuList() async {
    ResponseBodyApi res = await MenuApi.listAuth();
  }

  @override
  void initState() {
    windowManager.addListener(this);
    getMenuList();
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = router.location;
    int indexOriginal = originalItems
        .where((element) => element.key != null)
        .toList()
        .indexWhere((element) => element.key == Key(location));

    if (indexOriginal == -1) {
      int indexFooter = footerItems
          .where((element) => element.key != null)
          .toList()
          .indexWhere((element) => element.key == Key(location));
      if (indexFooter == -1) {
        return 0;
      }
      return originalItems
              .where((element) => element.key != null)
              .toList()
              .length +
          indexFooter;
    } else {
      return indexOriginal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = FluentLocalizations.of(context);

    final appTheme = context.watch<AppTheme>();
    final theme = FluentTheme.of(context);
    if (widget.shellContext != null) {
      if (router.canPop() == false) {
        setState(() {});
      }
    }
    return NavigationView(
      key: viewKey,
      appBar: NavigationAppBar(
        automaticallyImplyLeading: false,
        leading: () {
          final enabled = widget.shellContext != null && router.canPop();

          final onPressed = enabled
              ? () {
                  if (router.canPop()) {
                    context.pop();
                    setState(() {});
                  }
                }
              : null;
          return NavigationPaneTheme(
            data: NavigationPaneTheme.of(context).merge(NavigationPaneThemeData(
              unselectedIconColor: ButtonState.resolveWith((states) {
                if (states.isDisabled) {
                  return ButtonThemeData.buttonColor(context, states);
                }
                return ButtonThemeData.uncheckedInputColor(
                  FluentTheme.of(context),
                  states,
                ).basedOnLuminance();
              }),
            )),
            child: Builder(
              builder: (context) => PaneItem(
                icon: const Center(child: Icon(FluentIcons.back, size: 12.0)),
                title: Text(localizations.backButtonTooltip),
                body: const SizedBox.shrink(),
                enabled: enabled,
              ).build(
                context,
                false,
                onPressed,
                displayMode: PaneDisplayMode.compact,
              ),
            ),
          );
        }(),
        title: () {
          if (kIsWeb) {
            return const Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(appTitle),
            );
          }
          return const DragToMoveArea(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(appTitle),
            ),
          );
        }(),
        actions: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Container(
            height: double.infinity,
            padding: EdgeInsets.only(right: 10),
            alignment: AlignmentDirectional.centerEnd,
            child: ToggleSwitch(
              content: const Text('Dark mode'),
              checked: FluentTheme.of(context).brightness.isDark,
              onChanged: (v) {
                if (v) {
                  appTheme.mode = ThemeMode.dark;
                } else {
                  appTheme.mode = ThemeMode.light;
                }
              },
            ),
          ),
          if (!kIsWeb) const WindowButtons(),
        ]),
      ),
      paneBodyBuilder: (item, child) {
        final name =
            item?.key is ValueKey ? (item!.key as ValueKey).value : null;
        return FocusTraversalGroup(
          key: ValueKey('body$name'),
          child: widget.child,
        );
        // final body = FocusTraversalGroup(
        //   key: ValueKey('body$name'),
        //   child: widget.child,
        // );
        // return TabView(currentIndex: currentTabIndex, tabs: openTabs);
      },
      pane: NavigationPane(
        selected: _calculateSelectedIndex(context),
        header: SizedBox(
          height: kOneLineTileHeight,
          child: ShaderMask(
            shaderCallback: (rect) {
              final color = appTheme.color.defaultBrushFor(
                theme.brightness,
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
            // child: const FlutterLogo(
            //   style: FlutterLogoStyle.horizontal,
            //   size: 80.0,
            //   textColor: Colors.white,
            //   duration: Duration.zero,
            // ),
          ),
        ),
        displayMode: appTheme.displayMode,
        indicator: () {
          switch (appTheme.indicator) {
            case NavigationIndicators.end:
              return const EndNavigationIndicator();
            case NavigationIndicators.sticky:
            default:
              return const StickyNavigationIndicator();
          }
        }(),
        items: originalItems,
        autoSuggestBox: AutoSuggestBox(
          key: searchKey,
          focusNode: searchFocusNode,
          controller: searchController,
          unfocusedColor: Colors.transparent,
          items: originalItems.whereType<PaneItem>().map((item) {
            assert(item.title is Text);
            final text = (item.title as Text).data!;
            return AutoSuggestBoxItem(
              label: text,
              value: text,
              onSelected: () {
                item.onTap?.call();
                searchController.clear();
              },
            );
          }).toList(),
          trailingIcon: IgnorePointer(
            child: IconButton(
              onPressed: () {
                searchFocusNode.requestFocus();
              },
              icon: const Icon(FluentIcons.search),
            ),
          ),
          placeholder: 'Search',
        ),
        autoSuggestBoxReplacement: const Icon(FluentIcons.search),
        footerItems: footerItems,
      ),
      // onOpenSearch: () {
      //   searchFocusNode.requestFocus();
      // },
    );
  }

  @override
  void onWindowClose() async {
    bool _isPreventClose = await windowManager.isPreventClose();
    if (_isPreventClose) {
      showDialog(
        context: context,
        builder: (_) {
          return ContentDialog(
            title: const Text('确认关闭'),
            content: const Text('是否确定关闭软件?'),
            actions: [
              FilledButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.pop(context);
                  windowManager.destroy();
                },
              ),
              Button(
                child: const Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final FluentThemeData theme = FluentTheme.of(context);

    return SizedBox(
      width: 138,
      height: 50,
      child: WindowCaption(
        brightness: theme.brightness,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

class _LinkPaneItemAction extends PaneItem {
  _LinkPaneItemAction({
    required super.icon,
    required this.link,
    required super.body,
    super.title,
  });

  final String link;

  @override
  Widget build(
    BuildContext context,
    bool selected,
    VoidCallback? onPressed, {
    PaneDisplayMode? displayMode,
    bool showTextOnTop = true,
    bool? autofocus,
    int? itemIndex,
  }) {
    return Link(
      uri: Uri.parse(link),
      builder: (context, followLink) => super.build(
        context,
        selected,
        followLink,
        displayMode: displayMode,
        showTextOnTop: showTextOnTop,
        itemIndex: itemIndex,
        autofocus: autofocus,
      ),
    );
  }
}
