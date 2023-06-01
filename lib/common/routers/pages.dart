import 'package:eatm_manager/common/routers/names.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';

import '../../pages/index.dart';
import '../middlewares/index.dart';

class RoutePages {
  // 列表
  static List<GetPage> list = [
    GetPage(
      name: RouteNames.systemLogin,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: RouteNames.systemMain,
      page: () => const MainPage(),
      middlewares: [
        RouteAuthMiddleware(priority: 1),
      ],
    ),
  ];
}

class MainChildPage {
  String? url;
  Icon? icon;
  Widget? page;

  MainChildPage({this.url, this.page});

  MainChildPage.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    icon = json['icon'];
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['page'] = page;
    data['icon'] = icon;
    return data;
  }
}

class MainChildPages {
  static List<MainChildPage> list = [
    MainChildPage(url: '/dashboard', page: Container(child: Text('工艺绑定'))),
    MainChildPage(url: '/kaihua', page: Center(child: Text('看板'))),
  ];

  static Widget getPage(String url) {
    var page = list.firstWhereOrNull((element) => element.url == url);
    return page?.page ?? Container();
  }
}
