import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
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
        await windowManager.show();
        await windowManager.setPreventClose(true);
        await windowManager.setSkipTaskbar(false);
      });
    }

    Get.put<UserStore>(UserStore());
    Get.put<ConfigStore>(ConfigStore());
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
