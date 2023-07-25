/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-20 10:25:25
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-25 18:01:37
 * @FilePath: /iniConfig/lib/common/style/global_theme.dart
 * @Description: 全局主题控制器
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart' as material;

class GlobalTheme extends GetxController {
  static GlobalTheme get instance => Get.find<GlobalTheme>();
  final GetStorage _storage = GetStorage('globalTheme');
  final _isDarkMode = false.obs;
  // 是否为暗黑模式
  bool get isDarkMode => _isDarkMode.value;

  set isDarkMode(bool value) {
    _isDarkMode.value = value;
    _mode = value ? ThemeMode.dark : ThemeMode.light;
    _storage.write('isDarkMode', value);
    Get.forceAppUpdate();
  }

  // 主题模式
  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;
  set mode(ThemeMode mode) {
    _mode = mode;
    Get.forceAppUpdate();
  }

  // 主题色
  AccentColor _accentColor = Colors.blue;
  AccentColor get accentColor => _accentColor;
  set accentColor(AccentColor color) {
    _accentColor = color;
    Get.forceAppUpdate();
  }

  // 导航指示器
  PaneDisplayMode _navigationIndicator = PaneDisplayMode.auto;
  PaneDisplayMode get navigationIndicator => _navigationIndicator;
  set navigationIndicator(PaneDisplayMode mode) {
    _navigationIndicator = mode;
    _storage.write('navigationIndicator', mode.toString());
    Get.forceAppUpdate();
  }

  // 按钮图标颜色
  Color get buttonIconColor => _isDarkMode.value ? Colors.white : Colors.black;
  // 页面内边距
  get pagePadding => const EdgeInsets.all(10);
  // 卡片内边距
  get cardPadding => const EdgeInsets.all(10);
  // 盒子阴影
  final BoxShadow _boxShadow = const BoxShadow(
      color: material.Colors.black12,
      offset: Offset(0.0, 1.5), //阴影x轴偏移量
      blurRadius: 8, //阴影模糊程度
      spreadRadius: 3 //阴影扩散程度
      );
  BoxShadow get boxShadow => _boxShadow;
  // 页面内容模块背景色
  Color _pageContentBackgroundColor() {
    return _isDarkMode.value
        ? const Color(0xe427293d)
        : const Color(0xfff5f6fa);
  }

  Color get pageContentBackgroundColor => _pageContentBackgroundColor();
  // 模块间边距
  final double _contentDistance = 15.0;
  double get contentDistance => _contentDistance;
  // 内容模块圆角
  get contentRadius => const BorderRadius.all(Radius.circular(5.0));
  // 内容装饰集合
  get contentDecoration => BoxDecoration(
      color: pageContentBackgroundColor,
      borderRadius: contentRadius,
      boxShadow: [boxShadow]);

  _initStore() {
    int readAccentColorIndex = _storage.read('accentColorIndex') ?? 5;
    bool readIsDarkMode = _storage.read('isDarkMode') ?? false;
    String readNavigationIndicator =
        _storage.read('navigationIndicator') ?? 'PaneDisplayMode.auto';

    Future.delayed(Duration.zero).then((value) {
      isDarkMode = readIsDarkMode;
      accentColor = Colors.accentColors[readAccentColorIndex];
      navigationIndicator = PaneDisplayMode.values.firstWhere(
          (element) => element.toString() == readNavigationIndicator);
    });
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    // 初始化主题色、模式、导航指示器
    _initStore();
  }
}
