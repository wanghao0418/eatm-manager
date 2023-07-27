/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-01 09:46:10
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-27 18:15:36
 * @FilePath: /eatm_manager/lib/global.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:system_theme/system_theme.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'common/store/index.dart';

// 全局静态数据
class Global {
  // 是否为桌面端
  static bool get isDesktop {
    if (kIsWeb) return false;
    return [
      TargetPlatform.windows,
      TargetPlatform.linux,
      TargetPlatform.macOS,
    ].contains(defaultTargetPlatform);
  }

  // 初始化
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (!kIsWeb &&
        [
          TargetPlatform.windows,
          TargetPlatform.android,
        ].contains(defaultTargetPlatform)) {
      SystemTheme.accentColor.load();
    }

    if (isDesktop) {
      await flutter_acrylic.Window.initialize();
      await flutter_acrylic.Window.hideWindowControls();
      await WindowManager.instance.ensureInitialized();
      windowManager.waitUntilReadyToShow().then((_) async {
        await windowManager.setTitleBarStyle(
          TitleBarStyle.hidden,
          windowButtonVisibility: false,
        );
        await windowManager.setSize(const Size(1200, 800));
        await windowManager.setMinimumSize(const Size(1200, 800));
        await windowManager.setPreventClose(true);
        await windowManager.setSkipTaskbar(false);
        await windowManager.maximize();
        await windowManager.show();
      });
    }
    await GetStorage.init('user');
    Get.put<UserStore>(UserStore());
    Get.put<ConfigStore>(ConfigStore());
    Get.put<GlobalTheme>(GlobalTheme());
  }

// 获取系统主题颜色
  static AccentColor get systemAccentColor {
    if ((defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.android) &&
        !kIsWeb) {
      return AccentColor.swatch({
        'darkest': SystemTheme.accentColor.darkest,
        'darker': SystemTheme.accentColor.darker,
        'dark': SystemTheme.accentColor.dark,
        'normal': SystemTheme.accentColor.accent,
        'light': SystemTheme.accentColor.light,
        'lighter': SystemTheme.accentColor.lighter,
        'lightest': SystemTheme.accentColor.lightest,
      });
    }
    return Colors.blue;
  }
}
