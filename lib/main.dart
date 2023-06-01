import 'dart:ui';
import 'package:fluent_ui/fluent_ui.dart' hide Page;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:system_theme/system_theme.dart';
import 'package:flutter/material.dart' as material;

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
          return FluentApp(
            debugShowCheckedModeBanner: false,
            home: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              color: AppTheme.systemAccentColor,
              themeMode: Get.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              theme: material.ThemeData(
                primarySwatch: material.Colors.blue,
                visualDensity: VisualDensity.standard,
                fontFamily: 'MyFont',
                primaryColor: AppTheme.systemAccentColor,
              ),
              darkTheme: material.ThemeData(
                primarySwatch: material.Colors.blue,
                visualDensity: VisualDensity.standard,
                fontFamily: 'MyFont',
                // primaryColor: systemAccentColor,
              ),
              title: 'EMAN',
              initialRoute: RouteNames.systemMain,
              localizationsDelegates: [
                FluentLocalizations.delegate,
              ],
              initialBinding: AllControllerBinding(),
              getPages: RoutePages.list,
              scrollBehavior: MyCustomScrollBehavior(),
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
