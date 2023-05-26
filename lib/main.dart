import 'package:fluent_ui/fluent_ui.dart' hide Page;
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:system_theme/system_theme.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:window_manager/window_manager.dart';
import 'package:provider/provider.dart';
import 'store/global.dart';
import 'theme.dart';
import 'routes/router.dart';

bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

void main() async {
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

  runApp(MyApp());

  // Future.wait([
  //   DeferredWidget.preload(popups.loadLibrary),
  //   DeferredWidget.preload(forms.loadLibrary),
  //   DeferredWidget.preload(inputs.loadLibrary),
  //   DeferredWidget.preload(navigation.loadLibrary),
  //   DeferredWidget.preload(surfaces.loadLibrary),
  //   DeferredWidget.preload(theming.loadLibrary),
  // ]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(1920, 1080),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => AppTheme()),
              ChangeNotifierProvider(create: (_) => SignedInModel())
            ],
            builder: (context, child) {
              final appTheme = context.watch<AppTheme>();
              return FluentApp.router(
                title: 'Eman自动化',
                themeMode: appTheme.mode,
                debugShowCheckedModeBanner: false,
                color: appTheme.color,
                darkTheme: FluentThemeData(
                    brightness: Brightness.dark,
                    accentColor: appTheme.color,
                    visualDensity: VisualDensity.standard,
                    focusTheme: FocusThemeData(
                      glowFactor: is10footScreen(context) ? 2.0 : 0.0,
                    ),
                    fontFamily: 'MyFont'),
                theme: FluentThemeData(
                    accentColor: appTheme.color,
                    visualDensity: VisualDensity.standard,
                    focusTheme: FocusThemeData(
                      glowFactor: is10footScreen(context) ? 2.0 : 0.0,
                    ),
                    fontFamily: 'MyFont'),
                locale: appTheme.locale,
                builder: (context, child) {
                  return Directionality(
                    textDirection: appTheme.textDirection,
                    child: NavigationPaneTheme(
                      data: NavigationPaneThemeData(
                        backgroundColor: appTheme.windowEffect !=
                                flutter_acrylic.WindowEffect.disabled
                            ? Colors.transparent
                            : null,
                      ),
                      child: child!,
                    ),
                  );
                },
                routeInformationParser: router.routeInformationParser,
                routerDelegate: router.routerDelegate,
                routeInformationProvider: router.routeInformationProvider,
              );
            },
            child: child,
          );
        });
  }
}
