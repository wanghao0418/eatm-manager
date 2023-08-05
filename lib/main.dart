import 'dart:ui';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Page;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import 'common/index.dart';
import 'global.dart';

void main() async {
  await Global.init();
  runApp(MyApp());
}

// 重写滚动行为
class MyCustomScrollBehavior extends material.MaterialScrollBehavior {
// Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
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
          final GlobalTheme globalTheme = Get.find<GlobalTheme>();
          return FluentApp(
            debugShowCheckedModeBanner: false,
            themeMode: globalTheme.mode,
            color: globalTheme.accentColor,
            theme: FluentThemeData(
              brightness: Brightness.light,
              accentColor: globalTheme.accentColor,
              fontFamily: 'Roboto',
              visualDensity: VisualDensity.standard,
              focusTheme: FocusThemeData(
                glowFactor: is10footScreen(context) ? 2.0 : 0.0,
              ),
              iconTheme: const IconThemeData(
                color: Colors.black,
              ),
              scaffoldBackgroundColor: Colors.transparent,
            ),
            darkTheme: FluentThemeData(
              brightness: Brightness.dark,
              accentColor: globalTheme.accentColor,
              fontFamily: 'Roboto',
              visualDensity: VisualDensity.standard,
              focusTheme: FocusThemeData(
                glowFactor: is10footScreen(context) ? 2.0 : 0.0,
              ),
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
            ),
            home: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'EMAN',
              initialRoute: RouteNames.systemMain,
              localizationsDelegates: const [
                FluentLocalizations.delegate,
              ],
              theme: material.ThemeData(
                brightness: Brightness.light,
                cupertinoOverrideTheme: CupertinoThemeData(
                  brightness: Brightness.light,
                ),
                expansionTileTheme:
                    const material.ExpansionTileThemeData().copyWith(
                  iconColor: globalTheme.accentColor,
                  collapsedIconColor: Colors.grey[100],
                ),
                fontFamily: 'Roboto',
              ),
              darkTheme: material.ThemeData(
                brightness: Brightness.dark,
                cupertinoOverrideTheme:
                    CupertinoThemeData(brightness: Brightness.dark),
                expansionTileTheme:
                    const material.ExpansionTileThemeData().copyWith(
                  iconColor: globalTheme.accentColor,
                  collapsedIconColor: Colors.grey[100],
                ),
                listTileTheme: const material.ListTileThemeData().copyWith(
                  tileColor: globalTheme.isDarkMode
                      ? const Color(0xff303C54)
                      : const Color(0xffF2F4F8),
                ),
                fontFamily: 'Roboto',
              ),
              initialBinding: AllControllerBinding(),
              getPages: RoutePages.list,
              scrollBehavior: MyCustomScrollBehavior(),
              navigatorObservers: [FlutterSmartDialog.observer],
              builder: FlutterSmartDialog.init(),
            ),
          );
        });
  }
}

// 全局控制器绑定
class AllControllerBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
  }
}
